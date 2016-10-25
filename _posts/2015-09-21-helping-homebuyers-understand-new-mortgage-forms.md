---

published: true
layout: post
author: Nicholas Johnson
title: Helping homebuyers understand new mortgage forms
excerpt: Starting October 3, homebuyers will see two new forms during the mortgage process. Both forms were designed by the CFPB to be clear, concise, and consumer friendly. But we know that no form can possibly answer every question homebuyers will have about their mortgage, so we went one extra step. Both forms feature a URL that homebuyers can visit to get help understanding the forms.

---

![On the right, the new Loan Estimate form. On the left, a web page that helps
to explain it.](../../img/form-explainers/01-web-tool-and-paper-form-side-by-
side.jpg) *On the right, the new Loan Estimate form. On the left, a web page
that helps to explain it.*

Starting October 3, homebuyers will see two new forms during the mortgage
process. One, the [Loan Estimate](http://www.consumerfinance.gov/owning-a-home
/loan-estimate), will help consumers understand the estimated costs and
conditions of every mortgage they consider. The other, the [Closing
Disclosure](http://www.consumerfinance.gov/owning-a-home/closing-disclosure),
will give consumers a final overview of their mortgage terms at closing.

Both forms were [designed by the
CFPB](http://www.consumerfinance.gov/knowbeforeyouowe/) to be clear, concise,
and consumer friendly. We put the forms through several rounds of user testing
to make sure the average homebuyer can understand the often complex terms and
calculations shown on both forms.

But we know that no form can possibly answer every question homebuyers will
have about their mortgage, so we went one extra step. Both forms feature a URL
that homebuyers can visit to get help understanding the forms.

![The URL on a paper Loan Estimate form.](../../img/form-explainers/02-url-on-
paper-form.jpg) *The URL on a paper Loan Estimate form.*

Those URLs point to a set of tools that help answer consumers’ questions about
the forms. These tools went through a design and usability testing process, and
we’re super excited to launch them right alongside the forms on October 3.

## Design

When we started designing these tools, we had a very clear use case in mind: a
homebuyer with a form in one hand and a mouse in the other.

![A homebuyer looking at both the paper form and the web page that explains
it.](../../img/form-explainers/03-homebuyer-with-ipad-and-paper-form.jpg) *A
homebuyer looking at both the paper form and the web page that explains it.*

Though the specifics of the situation might change (the form might be a PDF
open in a browser tab or the mouse might be a tablet), the big idea is the
same: most of our users are going to be looking for help with a specific part
of their form by looking for a specific part of their form.

That’s why we designed the interface with the forms themselves front and center
on screens of all sizes.

Thanks to previous work on the [Owning a
Home](http://www.consumerfinance.gov/owning-a-home/) project, we had lots of
research to guide us on what parts of the form might be confusing and what
homebuyers need to watch out for (e.g., making sure the address listed on the
form is exactly correct). Those areas are all highlighted in the Loan Estimate
and Closing Disclosure tools, and a quick click or tap pulls up info that helps
answer homebuyers’ questions.

The Closing Disclosure tool also highlights areas of that form that homebuyers
should compare to their original Loan Estimate form to see if any mortgage
costs or conditions have changed (the forms were specifically designed to be
compared side by side). The tool helps homebuyers understand what changes are
allowed under current mortgage regulations.

We tested the tools with potential homebuyers to make sure our design made
sense. Those users helped us see issues we wouldn’t have spotted otherwise,
like how confusing it was to lump simple definitions of terms on the form in
with more complex explanations of what to watch out for. That kind of usability
testing data let us continuously refine the tools’ interface.

## Technology

The universe of forms that need explaining isn’t limited to Loan Estimates and
Closing Disclosures. Those may be the particular forms we’ll be explaining on
October 3, but we built the technology to be flexible enough to handle just
about any kind of form.

There are three things needed to explain most paper forms on the web: an image
of each form page, content explaining the different parts of the form, and a
map that ties the part of the form to be explained to the correct piece of
content. Together, those three things can create an interface that shows the
form with hotspots positioned over each part to be explained. Tapping or
clicking those hotspots shows the associated content.

Our tools use an HTML file for each page of the form to be explained. That file
contains only a `data` object with two properties, `img` and `terms`. For
example:

```javascript
data = {
  "img": url_for('static', filename='img/form-page.png'),
  "terms":
  [
    {
      "term": "Estimated Closing Costs",
      "definition": "<p>Upfront costs you will be charged to get your loan and
      transfer ownership of the property.</p>",
      "id": "estimated-closing",
      "category": "definitions",
      "left": "6.95%",
      "top": "85.20%",
      "width": "23.26%",
      "height": "4.39%"
    }
    /* The rest of the terms being explained */
  ]
}
```

The `img` property is just a path to the image file of the form page being
explained. The `terms` array is where the real action happens. It contains all
the information needed to explain a particular part of the form, like the name,
definition, and position of the explained part.

Structuring explainer pages like this gives a couple of benefits. First, all
the content is in one chunk, so pages can be created and edited without digging
through masses of HTML. Even better, though, is how the simple structure of the
data lets non-technical folks write and tweak definitions without needing to
understand anything more than very simple HTML.

We’re excited to launch our new Loan Estimate and Closing Disclosure tools on
October 3. We’re just as excited about the future of the form explainer
concept. Like [much of our work at the CFPB](https://github.com/cfpb/), the
code for these tools is open source and free for anyone to use or adapt for
their own projects. The [code is all on
GitHub](https://github.com/cfpb/owning-a-home/tree/master/src/loan-estimate),
and we’d love to see it used and improved.
