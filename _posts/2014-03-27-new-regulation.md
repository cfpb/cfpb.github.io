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

The fact that Z is significantly longer of a regulation than E drove almost
every aspect of what  we did ove r the next six months, especially when it came
to actually getting all the content together. 

## Compiling regulations

One of the primary features of eRegulations is the ability to see past, current
and future versions of a regulation. Each version of a regulation can be
thought of as the previous version of a regulation, plus a series of Federal
Register (FR) final rule notices. Each FR notice describes specific changes to
the regulations: which can add, revise, move or delete individual paragraphs.
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
behind-the-scenes as a data structure (more specifically an n-ary tree) that
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
of information they contain. The appendices for Z contain equations, tables,
SAS code, and many images. Each of those presented unique challenges. To handle
tables we had to parse the XML that exhaustively represented the tables into
something [meaningful and concise]
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








{% highlight python %}
"the term .* means"    # likely indicates a defined term
"\ba\b"                # only matches the word "a"; doesn't match "a" inside another word such as "bad"
{% endhighlight %}

Regexes also let us *retrieve* matching text. In our example above, we could determine not only that a defined term was likely present but also what that term or phrase would be. Expressions may include multiple segments of retrieved text (known as "capture groups"), and advanced tools will provide deeper inspection such as segmenting out repeated expressions.

{% highlight python %}
"Appendix ([A-Z]\d*) to Part (\d+)"
# Allows us to retrieve 'A6' and '2345' from "Appendix A6 to Part 2345"
{% endhighlight %}

Regular expressions serve as both a low-ish level tool for parsing and as a building block on which almost all parsing libraries are constructed. Understanding them will help you debug problems with higher-level tools as well as know their fundamental limitations.

## When is an (i) not an (i)?

Regulations generally follow a relatively strict hierarchy, where sections are broken into many levels of paragraphs and sub-paragraphs. The levels begin with the lower-case alphabet, then arabic numerals, followed by roman numerals, the upper-case alphabet, and then italic versions of many of these. Paragraphs each have a "marker", indicating where the paragraph begins and giving it a reference, but these markers may not always be at the beginning of a line. This means that, to find paragraphs, we'll need to search for markers *throughout* every line of text.

It's not a simple matter of starting a new paragraph whenever a marker is found, however. Paragraph markers are also sprinkled throughout the regulation inside citations to *other* paragraphs (e.g. `See paragraph (b)(4)`). To solve this issue, we can run a citation parser (touched on shortly) to find the citations within a text and ignore paragraph markers found within them.

There's also a pesky matter of ambiguity. Many of the roman numerals are identical (in appearance) to members of the lower-case alphabet. Further, when using plain text as a source, all italics are lost, so the deepest layers of the paragraph tree are indistinguishable from their parents. Luckily, we can both keep track of what we have seen before (i.e. what *could* the next marker be) as well as peek forward to see which marker follows. If a (i)-marker is followed by a (ii) or a (j), we can deduce exactly to which level in the tree the (i) corresponds.

## Parser combinators: Not as scary as they sound

Regular expressions certainly require additional mental overhead by future developers, who will generally "run" expressions in their mind to see what they do. Well-named expressions help a bit, but the syntax for naming capture groups in generally quite ugly. Further, combining expressions is error-prone and leads to even more indecipherable code. So-called "parser combinators" (i.e. parsers that can be combined) resolve or at least alleviate both of these issues. Combinators allow expressions to be named and easily combined to build larger expressions. Below, examples demonstrate these features using `pyparsing`, a parser combinator library for Python.

{% highlight python %}
part = Word(digits).setResultsName("part")
section = Word(digits).setResultsName("section")
part_section = part + "." + section

parsed = part_section.parseString("1234.56")
assert(parsed.part == "1234")
assert(parsed.section == "56")
{% endhighlight %}

Parser combinators allow us to match relatively sophisticated citations, such as phrases which include multiple references separated by conjunction text. The parameter `listAllMatches` tells pyparsing to "collect" all the phrases which match our request. In this case, that means we can handle each citation by walking through the list.

{% highlight python %}
citations = (
    citation.copy().setResultsName("head")
    + ZeroOrMore(conj_phrase 
                 + citation.copy().setResultsName("tail",
                                                  listAllMatches=True)))

cits = citations.parseString("See paragraphs (a)(2), (3), and (b)")
for cit in [citations.head] + citations.tail:
    handleCitation(cit)
{% endhighlight %}

## What about meaning?

Thus far, we have matched text, searched for markers, and retrieved sophisticated values out of the regulation. I can understand why this might feel like a bit of a letdown — the parser isn't doing any magic. It doesn't know what sentences mean; it simply knows how to find and retrieve specific *kinds* of substrings. While we could argue that this is a foundation of understanding, let's do something fun instead.

The problem we face is that we must determine what has changed when a regulation is modified. Modifications don't result in new versions of the regulaton from the Government Printing Office (which only publishes entire regulations once a year). Instead, we must look at the "notice" that modifies the regulation (effectively a diff). Unfortunately, the pin-point accuracy that we need appears only in English phrases like: 

    4. Section 1005.32 is amended by revising paragraphs (b)(2)(ii) and (c)(3), adding paragraph (b)(3), revising paragraph (c)(4) and removing paragraph (c)(5) to read as follows

We can certainly parse out some of the citations, but we won't understand what's happening to the text with these citations alone. To aid our efforts, let's focus on the parts of this sentence that we care about. Notably, we only really care about citations and verbs ("revising", "adding", "removing"). Citations will play both the roles of context and nouns (i.e. what's being modified). We can reduce the sentence into a sequence of "tokens", in this case becoming:

    [Citation, Verb, Citation, Citation, Verb, Citation, Verb, Citation, Verb, Citation]

Each Citation token will know its (partial) citation (e.g. paragraph (b)(3) with no section), while each Verb will know what action is being performed as well as the active/passive voice ("revising" vs. "revised").

We next convert all passive verbs into their corresponding active form by changing the order of the tokens. For example, "paragraph (b) is revised" gets converted into "revising paragraph (b)" in token form. Next, we can carry citation information from left to right. In this sentence, "Section 1005.32" carries context to each of the other paragraphs, filling in their partial citation information. 

Finally, we can step through our list of tokens, keeping track of which modification mode we are in. We'd see "Section 1005.32" first, but since we start with no verb/mode set, we will ignore it. We then see "revising" and set our modification mode correspondingly. We can therefore mark each of the next two citations as "modified". We then hit an "adding" verb, so we switch modes and mark the following citation as "added". We continue this way, switching modes and marking citations until the whole sentence is parsed.

    [Citation[No Verb], Verb == revise, Citation[Revise], Citation[Revise], Verb == add, Citation[Add], Verb == revise ...

## Rules and anarchy

With combinations of just these tools, we can parse a great deal of content out of plain text regulations, including their structure, citations, definitions, diffs, and much more. What we've created has a great many limitations, however. The rule-based approach requires our developers think up "laws" for the English language, an approach which has proven itself ineffective in larger projects. Natural language is, in many ways, chaos, where machine learning and statistical techniques shine. In that realm, there is an expectation of inaccuracy simply because the problem is *so big*.

Fortunately, our task was not so large. The rule-based tools described above are effective with our limited set of examples (a subset of our own regulations). While the probabilistic techniques have, on average, higher accuracy for the general use case, they would not be as accurate as our tailored rules for our use cases. Striking the balance between rules and anarchy is difficult, but in this particular project, I believe we have chosen well.
