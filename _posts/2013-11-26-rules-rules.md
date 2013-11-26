---
published: false
layout: post
author: CM Lubinski
title: Rules about Rules
---

One of the core contributions found in the recently released [eregs](http://eregs.github.io/eregulations) project is a plain-text parser for regulations, also known as rules. This parser pulls structure from the documents such that each paragraph can be properly index; it discovers citations between the paragraphs and to external works; it determines definitions and even calculates differences between versions of the regulation. Due to the nature of the enterprise, we cannot leave room for probabilistic methods employed via machine learning. Instead we retrieve all of the information through parsing, a rule-based approach to natural language processing.

## XML: So Much Structure, So Little Meaning

We might start by wondering, isn't this all available via XML? Surely, with a structured language such as XML defining a regulation, we don't have much to do, right? As Cornell [discovered](http://www.hklii.hk/conference/paper/2B3.pdf), not all XML documents are created equal. Their analysis cites major issues in both inconsistent markup as well as the more insidious structure-without-meaning. Referring to the documents as a "bag of tags" conveys the problem well; just because a document has formatting does not mean it follows a logical structure. In particular, documents consisting almost exclusively of header and paragraph tags are not much of a step up from plain text documents with new-line characters. Further, when the markup is incorrect, it's actually a bit *more* cumbersome than plain text, as the structure is actively misleading.

While our current development relies more heavily on XML, our initial code used plain-text-only versions of the regulation as its source documents. We continue to use plain text in many of our features, however, as it's easier to reason about. For the sake of simplicity, this writeup will proceed with the assumption that the regulation is provided as a plain-text document.

## Regular Expressions: Regexi?

Regular expressions are one of the building blocks of almost any text parser. While we won't discuss them in great detail (there are many, better resources available,) I will note that learning how to write simple regexes doesn't take much time at all. As you progress and want to match more and more, Google around; due to their wide spread use, it's basically guaranteed that someone's had the same problem.

Regular expressions allow you to describe the "shape" of text you would like to match. For example, if a sentence has the phrase "the term", followed by some text, followed by "means" we might assume that that sentence is defining a word or phrase. Regexes give us many tools to narrow down the shape of text, including special characters to indicate whitespace, the beginning and end of a line, and "word boundaries" like commas, spaces, etc.

```
"the term .* means"    # likely indicates a defined term
"\ba\b"                # only matches the word "a"; doesn't match "a" inside another word
```

Regexes also let us *retrieve* matching text. In our example above, we could determine not only that a defined term was likely present but also what that term or phrase would be. Expressions may include multiple segments of retrieved text (known as "capture groups"), and advanced tools will provide deeper inspection such as segmenting out repeated expressions.

```
"Appendix ([A-Z]\d*) to Part (\d+)"
# Allows us to retrieve 'A6' and '2345' from "Appendix A6 to Part 2345"
```

Regular expressions serve as both a low-ish level tool for parsing and as a building block on which almost all parsing libraries are constructed. Understanding them will help you debug problems with higher-level tools as well as know their fundamental limitations.

## When is an (i) not and (i)?

Regulations generally follow a relatively strict hierarchy, where sections are broken into many levels of paragraphs and sub-paragraphs. The levels begin with the lower-case alphabet, then arabic numerals, followed by roman numerals, the upper-case alphabet, and then italic versions of many of these. Paragraphs each have a "marker", indicating where the paragraph begins and giving it a reference, but these markers may not always be at the beginning of a line. This means that, to find paragraphs, we'll need to search for markers *throughout* every line of text.

It's not a simple matter of starting a new paragraph whenever a marker is found, however. Paragraph markers are also sprinkled throughout the regulation inside citations to *other* paragraphs (e.g. `See paragraph (b)(4)`). To solve this issue, we can run a citation parser (touched on shortly) to find the citations within a text and ignore paragraph markers found within them.

There's also a pesky matter of ambiguity. Many of the roman numerals look a heck of a lot like members of the lower-case alphabet. Further, when using plain text as a source, all italics are lost, so the deepest layers of the paragraph tree are indistinguishable from their parents. Luckily, we can both keep track of what we have seen before (i.e. what *could* the next marker be) as well as peek forward to see which marker follows. If a (i)-marker is followed by a (ii) or a (j), we can deduce exactly to which level in the tree the (i) corresponds.

## Parser Combinators: Not As Scary As They Sound

Regular expressions certainly require additional mental overhead by future developers, as they must generally "run" expressions in their mind to see what they do. Well-named expressions help a bit, but the syntax for naming capture groups in generally quite ugly. Further, combining expressions is error-prone and leads to even more indecipherable code.

So-called "parser combinators" (i.e. parsers that can be combined) resolve or at least alleviate both of these issues. Combinators allow expressions to be named and easily combined to build larger expressions. Below, examples demonstrate these features using `pyparsing`, a parser combinator library for Python.

```
part = Word(digits).setResultsName("part")
section = Word(digits).setResultsName("section")
part_section = part + "." + section

parsed = part_section.parseString("1234.56")
assert(parsed.part == "1234")
assert(parsed.section == "56")
```

Parser combinators allow us to match relatively sophisticated citations, such as phrases which include multiple references separated by conjunction text. The parameter `listAllMatches` tells pyparsing to "collect" all the phrases which match our request. In this case, that means we can handle each citation by walking through the list.

```
citations = (
    citation.copy().setResultsName("head")
    + ZeroOrMore(conj_phrase 
                 + citation.copy().setResultsName("tail",
                                                  listAllMatches=True)))

cits = citations.parseString("See paragraphs (a)(2), (3), and (b)")
for cit in [citations.head] + citations.tail:
    handleCitation(cit)
```

## What About Meaning?

Thus far, we have matched text, searched for markers, and retrieved sophisticated values out of the regulation. I can understand why this might feel like a bit of a let down - the parse isn't doing any magic. It doesn't know what sentences mean; it simply knows how to find and retrieve specific *kinds* of substrings. While I might argue that this is a foundation of understanding, let's do something fun instead.

The problem we face is to determine what has changed when a regulation is modified via a notice. Unfortunately, the pin-point accuracy that we need appears only in English phrases like 
```
4. Section 1005.32 is amended by revising paragraphs (b)(2)(ii) and (c)(3), adding paragraph (b)(3), revising paragraph (c)(4) and removing paragraph (c)(5) to read as follows
```
We can certainly parse out some of the citations, but we won't understand what's happening to the text with these citations alone. To aid our efforts, let's focus on the parts of this sentence that we care about. Notably, we only really care about citations and verbs ("revising", "adding", "removing"). Citations will play both the roles of context and nouns (i.e. what's being modified). We can reduce the sentence into a sequence of "tokens", in this case becoming
```
[Citation, Verb, Citation, Citation, Verb, Citation, Verb, Citation, Verb, Citation]
```
with each Citation keeping track of its (partial) citation information and each Verb knowing which action is being performed, as well as the active/passive voice ("revising" vs. "revised").

We next convert all passive verbs into their corresponding active form by changing the order of the tokens. For example, "paragraph (b) is revised" gets converted into "revising paragraph (b)" in token form. Next, we can carry citation information from left to right. In this sentence, "Section 1005.32" carries context to each of the other paragraphs, filling in their partial citation information. 

Finally, we can step through our list of tokens, keeping track of which modification mode we are in. We'd see "Section 1005.32" first, but since we start with no mode set, we will ignore it. We then see "revising" and set our modification mode correspondingly. We can therefore mark each of the next two citations as "modified". We then hit an "adding" verb, so we switch modes and mark the following citation as "added". We continue this way, switching modes and marking citations until the whole sentence is parsed.

With combinations of these tools, we can parse the structure of regulations, their citations, their definitions, changes between regulations, and much more. Of course, machine learning techniques are more scalable, but for this use case, rules about rules have worked well.
