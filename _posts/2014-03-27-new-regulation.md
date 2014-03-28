---
published: true
layout: post
author: Shashank Khandelwal
title: "Automating, enhancing and improving eRegulations"
tagline: Behind the scenes
excerpt: "It's been approximately six months since we released our last regulation on [eRegulations](http://www.consumerfinance.gov/eregulations), our effort to make regulations more usable. We talk about what we've been up to since then. " 
---

As I'm writing this, the rest of my team is working on deploying new code
and content through our process into production. It's a very exciting time,
as we're going to be hosting Regulation Z (Truth in Lending) on our
eRegulations platform. It's taken us approximately six months since the
last regulation (Regulation E - Electronic Fund Transfers) to release this new
one. That's admittedly a long time between what is seemingly a content
update. However, Regulation Z is significantly different than Regulation E in a
number of ways that made it necessary for us to improve and update the
eRegulations platform. I'd like to share some of the more interesting
things we did, and in the process also reveal a bit more about how our platform
works. 

## Significant differences in size

The first and foremost difference between the two regulations is that Z is
significantly larger than E in almost all aspects.  In Table 1, for each type
of content you can see the difference between E and Z. For example, E has 26
sections while Z has 54. 

| | Regulation E | Regulation Z |
| ----- | ---- | ----- |
|Subparts | 2 | 7 | 
|Sections| 26 | 54 | 
|Appendices| 2| 15 | 

Table 1: The number of each types of content per regulation.

On disk, represented as pretty-printed JSON trees, E is 1.5Mb - Z is almost ten
times larger at a whopping 11Mb. That's a lot of text. The fact that Z is
significantly longer of a regulation than E drove almost every aspect of what
we did over the next six months, especially when it came to actually getting
all the content together. 

## Compiling regulations

One of the primary features of eRegulations is the ability to see past, current
and future versions of a regulation. Each version of a regulation can be
thought of as the previous version of a regulation, plus a series of Federal
Register (FR) final rule notices. Each FR notice describes specific changes to
the regulations: which can add, revise, move or delete individual paragraphs.
Basically each FR notice is a diff of the new changes, to derive the
regulation, you would have to apply the diff. 

For example: 

> Section 1026.32 is amended by:

> a. Revising paragraph (a)(2)(iii)

> The revisions read as follows:

> (a) *** 

> (2) ***

> (iii) A transaction originated by a Housing Finance Agency, where the Housing
> Finance Agency is the creditor for the transaction; or 

> *[1] This example is from https://www.federalregister.gov/articles/2013/10/01/2013-22752/amendments-to-the-2013-mortgage-rules-under-the-equal-credit-opportunity-act-regulation-b-real#p-amd-32*

Each version of a regulation on our platform is essentially represented
behind-the-scenes as a data structure (more specifically an ordered n-ary tree) that
represents the entire regulation at that point in time. For E, we meticulously
compiled plaintext versions and let our parser generate these trees. E is 3
versions, and 8 FR notices while Z is 12 versions and 23 notices. It became
apparent early on that any manual compilation of regulations would not only be
too error prone, but also not a maintainable and sustainable solution. The most
significant change over the past six months was to parse and compile FR notices
into regulation versions. 

Each FR notice also has a corresponding XML representation. We converted our
primary regulations parser from being text-based to XML based. This enabled us
to parse each FR notice by parsing the [amendatory
instructions](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/diff.py#L210)
(what has changed) and the [actual
changes](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/build.py#L302)
(how it has changed), [matching those
up](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/changes.py#L101)
and [compiling the
changes](https://github.com/cfpb/regulations-parser/blob/master/regparser/notice/compiler.py#L509)
into a new version. When you account for all the corner cases, all of that
probably accounted for 3 months of development time.  In the end though, we
think we have a fair more sustainable application that requires less manual
intervention to add an additional regulation. 

## Fixing FR Notices

Parsing amendatory instructions is tractable because the vocabulary of changes
is limited (changes are expressed relatively consistently), however sometimes
things are not expressed clearly or use a turn of phrasing that is unique.
Adding these rules to the code would have diminishing returns in the sense that
the effort of getting the code correct, tested and ensuring that it doesn't
break any of the other parsing would far outweigh the benefits of the unique
instance. To handle those cases, we built in a system to allow us to keep local
copies of the XML notices, and change those manually. The parser looks first in
our local repository of notices to see if a required notice exists, before
downloading it from the Federal Register. This enabled us to make quick changes
to the source XML that helps our parser along. 

The same mechanism came in handy when we discovered that several notices for Z
had more than one effective date. Notices with the same effective date are what
comprise a version of a regulation. The following example illustrates how
complicated this can get: 

> This final rule is effective January 10, 2014, except for the amendments to
> §§ 1026.35(b)(2)(iii), 1026.36(a), (b), and (j), and commentary to §§
> 1026.25(c)(2), 1026.35, and 1026.36(a), (b), (d), and (f) in Supp. I to part
> 1026, which are effective January 1, 2014, and the amendments to commentary to
> § 1002.14(b)(3) in Supplement I to part 1002, which are effective January 18,
> 2014. 

> [2] From: (https://www.federalregister.gov/articles/2013/10/01/2013-22752/amendments-to-the-2013-mortgage-rules-under-the-equal-credit-opportunity-act-regulation-b-real#p-40)

In these cases, we manually split up the notices, creating a new XML source
document for each effective date. This was another situation in which a manual
override made the most sense given time and effort constraints. 

## Appendices 

The appendices for Z include are far more varied than those for E in the types
of information they contain. First, the structure of the text in the appendices
for Z differs from that of E. This required a complete re-write of the appendix
parsing code to allow for the new format. Secondly. the appendices for Z
contain equations, tables, SAS code, and many images. Each of those presented
unique challenges. To handle tables we had to parse the XML that exhaustively
represented the tables into something [meaningful and concise]
(https://github.com/cfpb/regulations-parser/blob/master/regparser/layer/formatting.py),
and then display that in visually pleasing HTML [tables]
(https://github.com/eregs/regulations-site/blob/master/regulations/generator/layers/formatting.py#L18).
The SAS code was handled by the same mechanism. Some of the appendices in Z
contain many images.  To speed up page loads for those sections we re-saved
some of the images using image formats that compress the content with minimal
quality degradation and introduced thumbnails. Clicking on the thumbnail brings
the user to the larger image, but the thumbnails ensure that pages load faster.
Regulation Z also contained a number of appendices where the images contained
text. We pulled out the text out of those images, so that the text is now
searchable and linkable providing for a better user experience.  With the
exception of compiling regulations, most of the changes we made for Regulation
Z were directly a result of that fact that regulation Z is longer. 


## Subterps

Loading Supplement I as a single page worked well for Regulation E (where the
content is relatively short) but with Z this led to a degraded experience. We
split Supplement I, so it could be displayed a subpart at a time - we named
these subterps. Our code was previously written with the intent of displaying a
section at a time (the entirety of Supplement I considered as a section). This
worked nicely because that also reflects how the data that drives everything is
represented. With subterps, there is no corresponding underlying data structure
that tells us that the following sections of Supplement I should be collected
and displayed together. This required a [rewrite]
(https://github.com/eregs/regulations-site/blob/master/regulations/views/partial_interp.py#L35)
of some of our display logic.  Supplement I is now easier to read as a result.   

## Conclusion

We made many other changes: introducing a landing page for all the regulations,
extending the logic to identify defined terms with the regulation, and based on
user feedback - introducing help text to the application. Each one of those
represents a significant effort, but here I want to explain some of the more
interesting ones. All our code is open source, so you can see what we've
been up to in excruciating detail (and suggest changes).

Through these set of changes, we've hopefully made it much easier to add the
next regulation and also deal with longer regulations. I've just received word
that we're moving from our build server to our staging seerver. I'm so excited,
I hope you will be too. 
