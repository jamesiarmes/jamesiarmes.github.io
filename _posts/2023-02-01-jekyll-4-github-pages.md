---
layout: post
title:  Using Jekyll 4 with GitHub Pages
date:   2023-02-01 00:50:00 -0500
image:  /assets/img/covers/jekyll.preview.png
category: blog
tags:
- github
- jekyll
- website
---
![Jekyll logo][jekyll-logo]{: .post-image.full-width }
This site is built using [Jekyll][jekyll] and hosted on [GitHub Pages][pages].
I've been using this setup for some time, since switching from a Drupal site
(which was overkill for this small blog and the little traffic it receives) and
paid hosting. Until recently, I used the default setup on GitHub Pages which
uses jekyll 3.9.2. When I decided to [hit the reset button][reset], I saw that
Jekyll 4.0.0 was released in 2019 (nearly four years ago!) and with the release
of [4.3.0][4.3.0], the 3.9.x releases were officially moved to security updates
only.

GitHub has, unfortunately, made no mention of updating the supported version
used for GitHub Pages. However, at its core, Pages is just a static hosting
service with some support for building from Jekyll. I opted to move forward
using the latest version of Jekyll, knowing that I would have to handle building
the site myself.

## Jekyll 4

Jekyll 4.0.0 was a complete rewrite of the codebase. This rewrite dropped
support for older ruby versions, removed dependencies that were no longer
maintained, and included a number of enhancements.

Some of the major enhancements in the 4.x releases:

* Many improvements to caching
* A new Sass processor
* An updated markdown engine
* Better handling of links
* Configuration options for gem-based themes
* Support for logical operators in conditional expressions
* Support for Ruby 3.x
* Support for CSV data

There's much more, and of course all of the bug fixes and security updates
included in every release. Checkout the [releases][releases] page for more
details.

## Deploying Jekyll 4 on GitHub Pages

To deploy Jekyll 4 on GitHub Pages, you'll need to use
[GitHub Actions][actions]. GitHub Actions is a {% glossary CI/CD %} service that
allows you to automate tasks in your workflow. You can use it to build, test,
and deploy your code similar to other systems like Jenkins or CircleCI.

Workflows are configured in YAML files in the `.github/workflows` directory of
your repository. You can have multiple workflows, each of which can have one or
more jobs, which in turn contain one or more steps. For our purposes, we need
one workflow with two jobs, one to build the site and another to deploy it to
GitHub Pages.

For example, the workflow file for this site looks like this:

<figure>
  <figcaption>.github/workflows/deploy.yml</figcaption>
  {% highlight yaml %}
{% include_relative workflows/deploy.yml %}
  {% endhighlight %}
</figure>

Now, anytime I push a change to my `main` branch, the site is built and deployed
automatically!

![Screenshot of a successful run of the workflow][workflow-run]

[4.3.0]: https://jekyllrb.com/news/2022/10/20/jekyll-4-3-0-released/
[actions]: https://docs.github.com/actions
[jekyll]: https://jekyllrb.com/
[jekyll-logo]: /assets/img/covers/jekyll.svg
[pages]: https://pages.github.com/
[releases]: https://jekyllrb.com/news/releases/
[reset]: {% post_url 2022-11-12-gone-but-not-forgotten %}
[workflow-run]: /assets/img/jekyll-4/workflow-run.png
