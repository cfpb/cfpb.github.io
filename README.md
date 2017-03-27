# [cfpb.github.io](https://cfpb.github.io/)

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

**Note:** As of 6/23/16, you may need to run this command before running
`bundle install` to handle a bug in one of the dependencies:

```sh
bundle config build.nokogiri --use-system-libraries
```

[Fork and clone the repo](https://help.github.com/articles/fork-a-repo/)
to your local machine.

From the project directory, run Jekyll:

```sh
bundle exec jekyll serve --watch
```

Open it up in your browser: <http://localhost:4000/>


## Working with the front end

The cfpb.github.io project front end currently uses the following:

- [Jekyll](http://jekyllrb.com/): Static site generator used by GitHub Pages.


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
