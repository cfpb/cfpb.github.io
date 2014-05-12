---
published: true
layout: post
author: Shashank Khandelwal
title: "Automating, enhancing, and improving eRegulations"
tagline: "Behind the scenes"
excerpt: "It's been approximately six months since we released our first regulation on [eRegulations](http://www.consumerfinance.gov/eregulations), our effort to make regulations more usable. We talk about what we've been up to since then." 
---

Regulation Z (Truth in Lending) is now hosted on eRegulations – CFPB's 
platform to make regulations easier to find, read, and understand.  This
regulation follows approximately six months since the last regulation
(Regulation E – Electronic Fund Transfers) was first hosted. That's admittedly
a long time for what seems like a simple content update. However,
Regulation Z differs significantly from Regulation E, requiring us to improve
and update the eRegulations platform.  eRegulations now handles longer
regulations gracefully, and these updates also make it significantly easier to
host additional regulations going forward.
Here, we'll share some of the more interesting improvements and in
the process also reveal more about how our platform works. 

## Hosting larger regulations

The first and foremost difference between the two regulations is that Regulation Z is
significantly larger than Regulation E in almost all aspects.  In Table 1, you can see the
difference between Regulation E and Regulation Z for each type of content. For example, Regulation E has 26
sections while Regulation Z has 54. 

|            | Regulation E | Regulation Z |
| ---------- | ------------ | ------------ |
| Subparts   | 2            | 7            | 
| Sections   | 26           | 54           | 
| Appendices | 2            | 15           | 

_Table 1: The number of each type of content per regulation._

Regulation E is 1.5 MB on disk, while Regulation Z is almost ten times larger at 11 MB, when
both texts are represented as a pretty-printed JSON trees (not including
images). That's a lot of text; in comparison, <cite>War and Peace</cite> by Leo Tolstoy is
3.1 MB. The fact that Regulation Z is a significantly longer regulation than Regulation E
drove how we approached the updates and improvements to the tool –
from the need to automatically retrieve content changes,
to allowing additional types of appendices,
to separating the supplement into more manageable chunks.

## Compiling regulations

A primary feature of eRegulations is the ability to view past, current, and
future versions of a regulation. Previously, the source content that was fed to
the parser to generate each version was created manually. The most significant
change we made over the past six months was to automate this process.

Each version of a regulation consists of a series of Federal Register (FR)
final rule notices applied to the previous version of the regulation. Each
notice describes changes to individual paragraphs of the regulation (think of
it like a diff). A change can add, revise, delete, or move a paragraph and looks
something like this: 

> 1. Section 1026.32 is amended by:
> 2. Revising paragraph (a)(2)(iii)
> 3. The revisions read as follows:
> 4. (a) *** 
> 5. (2) ***
> 6. (iii) A transaction originated by a Housing Finance Agency, where the Housing
> Finance Agency is the creditor for the transaction; or 
> 
> This example is from <https://www.federalregister.gov/articles/2013/10/01/2013-22752/amendments-to-the-2013-mortgage-rules-under-the-equal-credit-opportunity-act-regulation-b-real#p-amd-32>

Lines 1 and 2 describe which paragraph has changed, and how it has changed
(known as the amendatory instructions). Line 6 shows you how paragraph 1026.36
(a)(2)(iii) reads after the revision. A notice can contain multiples of these
changes. 

Each version of a regulation on our platform is represented on the back end
as a data structure (more specifically an ordered n-ary tree) that represents
the entire regulation at that point in time. For each version of Regulation E, we manually
read each FR notice and meticulously compiled plaintext versions that were fed
to our parser to generate the tree structure. This was possible since in Regulation E we have three
versions consisting of eight FR notices. Regulation Z, on the other hand, has 12
versions and 23 notices. Manual compilation of versions would be
inefficient and more prone to error. It also is not a sustainable solution
going  forward. We wanted to be able to simply start the parser when the next
Regulation E or Z notice was published – without having to manually apply the
changes from the new notice.


We now automatically compile regulation versions. Each FR notice is processed
by parsing the [amendatory instructions](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/diff.py#L210)
(what has changed) and the [actual changes](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/build.py#L302)
(how it has changed), [matching those up](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/changes.py#L101),
and [compiling the changes](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/compiler.py#L509)
into a new version. Each FR notice has a corresponding XML representation –
this also drove the conversion of our parser from being text-based to
XML-based. This resulted in a far more sustainable application requiring less
manual intervention to add an additional regulation. 


## Splitting and cleaning Federal Register notices

An individual regulation paragraph can change in a limited number of ways. A
paragraph can be added, revised, moved, or deleted. Usually, these changes are
written with reasonably consistent phrasing – making parsing them tractable.
However, sometimes there are exceptions when the change is not expressed as
clearly as possible. Adding rules to the code  for these exceptions
would have diminishing returns in the sense that the effort of getting the code
correct, tested and ensuring that it doesn't break any of the other parsing,
would far outweigh the benefits of the unique rule. To handle those special
cases, we built a mechanism to allow us to keep local copies of the XML notices
taken from the Federal Register and make changes to that copy to make it
easier to parser. The parser looks first in our local repository of notices to
see if a copy of a required notice exists, before downloading it from the
Federal Register. This enabled us to gracefully handle phrases that aren't used
frequently enough to warrant their own custom rule.

The same mechanism came in handy when we discovered that several notices for Regulation Z
had more than one effective date. Notices with the same effective date are what
comprise a version of a regulation. The following example illustrates how
complicated this can get: 

> This final rule is effective January 10, 2014, except for the amendments to
> §§ 1026.35(b)(2)(iii), 1026.36(a), (b), and (j), and commentary to §§
> 1026.25(c)(2), 1026.35, and 1026.36(a), (b), (d), and (f) in Supp. I to part
> 1026, which are effective January 1, 2014, and the amendments to commentary to
> § 1002.14(b)(3) in Supplement I to part 1002, which are effective January 18,
> 2014. 
> 
> From: <https://www.federalregister.gov/articles/2013/10/01/2013-22752/amendments-to-the-2013-mortgage-rules-under-the-equal-credit-opportunity-act-regulation-b-real#p-40>

In these cases, we manually split up the notices, creating a new XML source
document for each effective date. This was another situation in which a manual
override made the most sense given time and effort constraints. 

## Improving appendices 

The types of information the appendices for Regulation Z contain are far more varied than
those for Regulation E. First, the structure of the text in the appendices for Regulation Z differs
from that of Regulation E. This required a complete re-write of the appendix parsing code
to allow for the new format. Secondly, the appendices for Regulation Z contain equations,
tables, SAS code, and many images. Each of those presented unique challenges.
To handle tables we had to parse the XML that exhaustively represented the
tables into something [meaningful and concise](https://github.com/cfpb/regulations-parser/blob/master/regparser/layer/formatting.py),
and then display that in visually pleasing HTML [tables](https://github.com/eregs/regulations-site/blob/master/regulations/generator/layers/formatting.py#L18).
The SAS code was handled by the same mechanism. 

Some of the appendices in Regulation Z contain many images.  To speed up page loads for
those sections we re-saved all of the images using image formats that compress
the content with minimal quality degradation and introduced thumbnails.
Clicking on the thumbnail brings the user to the larger image, but the
thumbnails ensure that pages load faster.  We also lazy-load the images on
scroll to speed up the initial page load. Regulation Z, in its original form,
also contains a number of appendices where the images contain text. We pulled
the text out of those images, so that the text is now searchable and
linkable providing for a better user experience. With the exception of
compiling regulations, most of the changes we made for Regulation Z were
directly a result of that fact that Regulation Z is longer. 


## Breaking up the supplement

Supplement I is the part of the regulation that contains the official
interpretations to the regulation. Loading Supplement I as a single page worked
well for Regulation E (where the content is relatively short) but with Regulation Z this
led to a degraded experience as the supplement is significantly longer. We
split Supplement I, so it could be displayed a subpart at a time. Displaying
the interpretations a subpart at a time was considered a more cohesive
experience by our product owner (rather than breaking Supplement I to be read a
section at a time).  Our code was previously written with the intent of
displaying a section at a time (with the entirety of Supplement I considered as
a section). This worked nicely because that also reflects how the data that
drives everything is represented. With the Supplement displayed a subpart at a
time, there is no corresponding underlying data structure that tells us that
the following sections of Supplement I should be collected and displayed
together. This required a [rewrite](https://github.com/eregs/regulations-site/blob/master/regulations/views/partial_interp.py#L35)
of some of our display logic.  Supplement I is now easier to read as a result.   

## Conclusion

We made many other changes to the eRegulations tool along the way:
introducing a landing page for all the regulations,
extending the logic to identify defined terms with the regulation, and based on
user feedback – introducing help text to the application. Each one of those
represents a significant effort, but here we wanted to explain some of the larger
efforts. All our code is open source, so you can see what we've been up to in
excruciating detail (and suggest changes).

Through this set of changes, we've hopefully made it easier to navigate,
understand, and comply with Regulation Z.
Going forward it will also be easier to add future regulations and
deal with longer regulations.
