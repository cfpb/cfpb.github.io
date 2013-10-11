_This project is the internal development repository for the site that will soon live on the public GitHub at
<https://github.com/cfpb/cfpb.github.io> and publish to <http://cfpb.github.io/>._


# [cfpb.github.io](https://cfpb.github.io/)

A site for the CFPB to share and discuss its technology work with the world.



## Contributing

This site is published with [Jekyll](http://jekyllrb.com/) via [GitHub Pages](http://pages.github.com/). 
If you would like to contribute, follow the directions below.


### Quick start

1. [Fork this project here on GitHub](https://github.cfpb.gov/CFPB/cfpb.github.io/fork)
1. Clone your fork to your machine.
1. Make your edits.
1. Commit the edits and push them to the `gh-pages` branch of _your_ repository.
1. Preview your changes by going to `https://github.cfpb.gov/pages/[yourname]/cfpb.github.io/`
1. When satisfied, make a pull request from your repo back to the main CFPB repo.

You can try to run Jekyll locally in order to preview the site without having to commit to Git, but it's not
strictly necessary. If you want to try it, follow the
[setup instructions in the Developer Handbook](https://github.cfpb.gov/pages/cfpb/handbook/edit-me.html).
Otherwise, you can simply push your site to your `gh-pages` branch, and bam – instant site.


### More details

#### Start writing a new post

To create a new post, just make a new file in the `_posts/` directory with a filename in the following format:
`yyyy-mm-dd-url-friendly-title.md`, where `yyyy-mm-dd` is the desired publication date (e.g., 2013-10-11) and
`url-friendly-title` is, well, a URL-friendly title (typically just the title of the post, all lowercase, with
dashes in place of spaces).

Then, inside that post, be sure to add at least the minimum
[YAML front matter](http://jekyllrb.com/docs/frontmatter/) (see anything in the _posts folder for an example):

```
---
layout: post
title: The title of your post
author: Your name, or the group for whom you're writing
---
```

Leave a blank line below that, and begin writing your content in
[Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) format.

#### More on previewing locally

To preview locally, you'll need to rename the `_config.yml` file to a temporary name like `_config_gh.yml`, and
rename `_config_local.yml` file to just `_config.yml` before you try to run Jekyll. _**Don't commit the modified
config files!**_
