# [cfpb.github.io](http://cfpb.github.io/)

A site for the CFPB to share and discuss its technology work with the world.

## Running it locally

Content editors and developers probably want to set up cfpb.github.io on
their local machine so they can preview updates without pushing to GitHub.

Before you get started make sure you have an up-to-date version of Ruby and Bundler.
We use [Homebrew](http://brew.sh/):

```sh
brew install ruby
gem install bundler
```

As the site is intended to be deployed on GitHub Pages, installing the
GitHub Pages gem is the best way to install Jekyll and related dependencies.
Run the following command to install it:

```sh
bundle install
```

[Fork and clone the repo](https://help.github.com/articles/fork-a-repo/)
to your local machine.

From the project directory, run Jekyll:

```sh
bundle exec jekyll serve --watch --baseurl ''
```

Open it up in your browser: <http://localhost:4000/>


## Working with the front end

The cfpb.github.io project front end currently uses the following:

- [Jekyll](http://jekyllrb.com/): Static site generator used by GitHub Pages.

## _config.yml

Options within the `_config.yml` file allow you to control the site's title,
subtitle, logo, author information, and the left column navigation.

### Project Page URL Structure

_This is an excerpt from the
[Jekyll docs](http://jekyllrb.com/docs/github-pages/)
on configuring your URL for Project Pages._

Sometimes it's nice to preview your Jekyll site before you
push your `gh-pages` branch to GitHub.
However, the subdirectory-like URL structure GitHub uses for Project Pages
complicates the proper resolution of URLs.
Here is an approach to utilizing the GitHub Project Page URL structure
(`username.github.io/project-name/`) whilst maintaining
the ability to preview your Jekyll site locally.

1. In `_config.yml`, set the `baseurl` option to `/project-name`
   – note the leading slash and the **absence** of a trailing slash.
2. When referencing JS or CSS files, do it like this:
   `{{ site.baseurl }}/path/to/css.css` – note the slash immediately following
   the variable (just before "path").
3. When doing permalinks or internal links, do it like this:
   `{{ site.baseurl }}{{ post.url }}` – note that there is **no** slash
   between the two variables.
4. Finally, if you'd like to preview your site before committing/deploying
   using `jekyll serve`, be sure to pass an **empty string** to the `--baseurl`
   option, so that you can view everything at `localhost:4000` normally
   (without `/project-name` at the beginning): `jekyll serve --baseurl ''`

This way you can preview your site locally from the site root on localhost,
but when GitHub generates your pages from the gh-pages branch all the URLs
will start with `/project-name` and resolve properly.


## Getting involved

We welcome your feedback and contributions.
See the [contribution guidelines](CONTRIBUTING.md) for more details.

**Note:** Currently this file has standard language geared toward code contributions.
Interested in contributing to design discussions? Just check out the
[issues](https://github.com/cfpb/cfpb.github.io/issues) and dive right in!

----

## Open source licensing info
1. [TERMS](TERMS.md)
2. [LICENSE](LICENSE)
3. [CFPB Source Code Policy](https://github.com/cfpb/source-code-policy/)
