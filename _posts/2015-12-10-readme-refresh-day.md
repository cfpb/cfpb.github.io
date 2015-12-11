---
published: true
layout: post
author: Marc Esher
title: Improving the new developer experience with a README Refresh Day
excerpt: We held a README Refresh Day to help us improve the quality of our open source software and its ability to be used and adopted by the general public
---


As part of our 2015 [Technology and Innovation Fellowship](http://www.consumerfinance.gov/jobs/technology-innovation-fellows/),
11 new developers joined the CFPB’s Design and Development team.
During the new fellows’ orientation, the entire development team took advantage of this fresh energy and perspective to ensure that documentation on some of our critical open source software was accurate.
Specifically, we held a "README Refresh Day," where small teams looked at seven README files on our
[GitHub repositories](https://github.com/cfpb) and submitted improvements and recommendations for future improvements.

<div class="content-sidebar">
  <h3>What is a README?</h3>
  <p>A README, or "read me," is often the first documentation that a user will read about a software package.
  This “digital welcome mat” is a text file that describes the software being used or developed and provides a roadmap for how the software can be installed and used.
  The lack of a README, or having one that is poorly written,
  is a barrier to adoption and can reduce the software’s ability to be understood and used.</p>

  <p>The convention to include a README file in a software package dates back many years and is now quite common in open source software.
  A strong README will explain the problems addressed by the software, the technology being used, how to install and configure,
  software and hardware dependencies, how to run automated tests, how to contribute changes, how to get help, and so on.</p>

  <p>Frequently, a file named <code>README.md</code> or <code>README.txt</code> lives alongside software source code.
  On GitHub, users see the README before anything else when viewing a software repository,
  as GitHub displays a nicely formatted version of it for every repository where a README exists.
  For CFPB software, we follow this convention and include a README for everything we build.</p>

  <p>Because of the README’s nature as welcome mat to a software project, we expect our READMEs to be accurate and helpful to users and collaborators.
  To simplify the creation of READMEs for our software teams,
  we provide a template, which ensures that projects start off with a consistently organized and formatted README.</p>
</div>

The README Refresh Day helped us improve the quality of our open source software and its ability to be used and adopted by the general public.
This effort effectively helps to pave the path for participation and collaboration, and helps to build a community around software.
These are key tenets in open source software development, the presence of which helps to ensure software quality and success.
The README Refresh Day also presented a number of added benefits:
(1) It helped orient new developers to technical environments and processes,
and (2) it helped to reinforce an important cultural value: Empathy – empathy for other developers,
or anyone in the public who would want to understand our software products.
**The easier our software is to understand and develop, the faster and more effectively we can deliver value to the American public.**

## The Challenge

Collaborators on software projects are frequently encouraged to write good installation and usage documentation and keep that information up to date, but even on the strongest of teams, creating and maintaining correct, up-to-date documentation is a real challenge. The documentation often:

1. Does not clearly define the problems the software attempts to solve
1. Assumes a level of expertise on the part of users/contributors that is too high
1. Omits key installation and configuration details
1. Does not keep up with changes to the software and thus drifts out of accuracy (aka "documentation drift" or “documentation rot”)

## Organizing the event

A small group of existing CFPB developers organized the event, including planning and event-day activities,
documented at [https://github.com/cfpb/readme_refresh_day](https://github.com/cfpb/readme_refresh_day).
We scheduled it during the fellowship immersion period as an activity to bring new developers closer with existing developers,
and also to provide all developers – veteran and newcomer – with an opportunity to explore software created by other CFPB project teams.
This also provided veteran CFPB developers an exercise in humility and empathy,
as they watched other developers attempt to install and work on software, which they had created previously, using just the README.

## Outcomes

Our raw notes can be read at [https://github.com/cfpb/readme_refresh_day](https://github.com/cfpb/readme_refresh_day/blob/master/notes.md).

During our three-hour session, 25 developers worked on software they had never seen before, using just the README.
In the group intro discussion, our new developers contributed valuable insights into what constitutes a good README,
and these suggestions will become part of our [open source template](https://github.com/cfpb/open-source-project-template).
Our developers shined a light on out-of-date or completely missing instructions and assumptions made by previous authors.
We also looked for missing or broken "badges," such as [Travis CI](https://travis-ci.org) and [Coveralls](https://coveralls.io),
and added or fixed those.

<div class="content-sidebar">
  <h3>Activities for continuous README improvement</h3>

  <p>Although our README Refresh Day was an event, it’s important that keeping project documentation accurate becomes habitual.
  To that end, some ideas:</p>

  <ol>
    <li>In an agile process, make a README review part of the "definition of done".</li>
    <li>As part of agile sprint reviews, include a README review.</li>
    <li>Automate the building, installation, and configuration of software based solely on steps from the README,
        such that any changes to the software that break these steps will be found quickly and appropriate people will be notified.</li>
  </ol>
</div>

Additionally, it was an excellent opportunity for new fellows to get a hands-on introduction to some of CFPB’s open source software projects.
If those developers who haven’t seen the software before couldn’t figure out how to install or use it from the README,
they had the opportunity to dig into it (albeit briefly) and try to determine what might be missing from the README.
At the end, even if they had no answers, at least they had a much better idea of the questions they needed to ask.

The session resulted in 14 [pull requests](https://help.github.com/articles/using-pull-requests/) to nine of our open source projects on [GitHub](https://github.com/cfpb),
and 21 issues added to these repositories for questions, comments, or enhancement suggestions.
We also came away with a humbling sense of the differences in README quality amongst our repositories,
and we’ll use this learning to improve across the board.

If you want your developers to learn more about software with which they’re unfamiliar, develop empathy for new users,
and improve the welcome mats to your projects, hold a README Refresh Day.

For an activity that requires only a day or two of planning, the results in both teamwork and software/documentation improvements are impressive.
