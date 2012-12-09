---
layout: post
title: Publishing with Jekyll
---

After using [WordPress](http://wordpress.com) for years for both blogs and content sites, I was looking for a new way to host my own blog, as well as an opportunity to experiment a bit more with CSS and hosting options. A number of Ruby tutorials use writing a CMS as their end product, but I wasn't too keen on doing that and instead came across [Jekyll](https://github.com/mojombo/jekyll) as a way to create a static site from a set of markdown files and layout templates. So after spending a while learning how the different pieces of the site come together, how the Liquid tags work and the best way to deploy the site from the various local and remote systems I've set up, I've finally switched this site over from a standard WordPress install to a deployed Jekyll static site.

There's still a fair bit left to implement - a lot of the styling needs to be done, RSS needs to be fixed up, more pages need to be added and there's probably a lot of stuff that should/shouldn't be in the 'head' tag. However, the basic site seems to work fine and the deploy scripts seem to work from each place I might want to write from. The full site, with the exception of a drafts folder, is [kept on GitHub](http://github.com/simongoudie/blog). I'm not using GitHub Pages to host it at this stage, but I have set up a page that I might use in future. Instead, the site uses [Glynn](https://github.com/dmathieu/glynn) to push it to the shared host that it lives on, or rsync to push to a test server on a VPS.

I've found Jekyll to be a great way to experiment with putting together a site, with a good balance between control over layout/configuration and automated 'magic' to make the site all come together and be ready to upload. I look forward to doing more work with it and will look at using it for other projects in future, too.
