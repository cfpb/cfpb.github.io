# CFPB Jekyll-It

Static sites are all the rage these days. This starter kit gives all you need to get one going on the Consumer Financial Protection Bureau's Github install using a ```gh-pages``` branch.

## To start

1. You can [learn more about Jekyll](http://jekyllrb.com/).
2. Read up on [how Github Pages work](http://pages.github.com/).
3. You can try to run Jekyll locally, but you don't have to. To install it, follow the [instructions in the Developer Handbook](https://github.cfpb.gov/pages/cfpb/handbook/edit-me.html). Otherwise, you can simply push your site to your ```gh-pages``` branch, and bam – instant site.

## Next

Let's do this. Via the Terminal:

    mkdir my-new-blog; cd my-new-blog
    git clone git://github.cfpb.gov/davidakennedy/cfpb-jekyll-it.git

## What This Does 

All this kit does is set you up with the typical Jekyll directory structure, a sample index.html file, a sample post, a shared header and footer, and a set of default configurations. That's it -- no fanciness.

To create a new post, just:

    touch _posts/yyyy-mm-dd-url-friendly-title.md

... where yyyy-mm-dd is a date (e.g., 2012-08-31) and url-friendly-title is, well, a URL-friendly title.  Then inside that post, be sure to add at least the minimal [YAML front matter](http://jekyllrb.com/docs/frontmatter/) (see the _posts folder for an example):

    ---
    layout: post
    title: A test post
    ---

    This is a test.

## Important Notes

* Includes a sample about page and test post for you to get started with.
* The main menu and site title can be changed by editing the ```header.html``` file in the ```_includes``` directory.
* Comes with a basic one-column layout/design based on [Staticly](https://github.cfpb.gov/davidakennedy/staticly).
* Has a basic ```_config.yml``` file to control your site settings. Be sure to change your ```baseurl``` setting to the URL of your Github pages branch.

CFPB Jekyll-It is great for internal blogs, a note-taking repo or project documentation.

Static, ftw.

## Running Jekyll Locally

(This assumes you are working on a Mac and have Homebrew installed in user-land.)

1. Install Ruby:

```
$ brew install ruby
```

2. Add homebrew Ruby to your path:

Edit your `~/.bash_profile`

Prepend: $HOME/homebrew/opt/ruby/bin

Path example:

```
export PATH=$HOME/homebrew/bin:$HOME/homebrew/sbin:
$HOME/homebrew/share/npm/bin:$HOME/homebrew/share/python:
$HOME/homebrew/opt/ruby/bin:$PATH
```

3. Install Jekyll

```
$ gem install jekyll
```

[Jekyll docs](http://jekyllrb.com/docs/home/)

4. Configure Jekyll

Use the config in this repo as a guide:

`_config.yml` is for `gh_pages`

`_config_local.yml` is for local Jekyll

5. Sites directory

Create a directory inside your repo that is names `_sites`
Edit your `.gitnore` and add `/_sites/*` as an excluded path

5. Run Jekyll:

```
$ cd  ~/repo_path/
$ jekyll serve --watch --config _config_local.yml
```
6. Browse:

Open up your browesr to http://localhost:4000 to view your site

### Changelog

* **July 9, 2013**: Initial release; V 0.1
* **July 15, 2013**: Release; V 0.1.1
  - Adds some extra styles to articles and puts main menu in Avenir.