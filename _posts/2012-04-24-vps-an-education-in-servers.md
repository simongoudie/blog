---
layout: post
title: VPS - an education in servers
tags:
- Apache
- CentOS
- CLI
- Linux
- mySQL
- PHP
- servers
- spotVPS
- VPS
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
You can get Virtual Private Servers for $15/year. A YEAR! Sure, they've got less RAM than my couch, but $15 is a pretty small price to pay for a new playground. I signed up for [SpotVPS' offering](http://spotvps.com "SpotVPS") ([affiliate link!](http://www.comforthost.net/billing/aff.php?aff=155 "Comfort Host")), which is a VPS with 128MB RAM (256MB burstable), 10GB storage and 500GB of bandwidth.

It's dead easy to set up, you just specify which OS you want loaded on your virtual server, then away you go. There's next to nothing by way of support, so it is a bit daunting to be left with the barebones of a server and not much else. I initially SSHed in and had a look around, realising that I should get a better feel for the OS. I initially opted for an Ubuntu install, as I had had a bit of practice on the desktop; however, this seemed to use too much memory, so I switched for [CentOS](http://www.centos.org/ "CentOS"). I don't know a whole lot about CentOS, but it turns out to be an offshoot of Red Hat Enterprise that is very stable, but not necessarily on the latest versions. The book ['The Definitive Guide to CentOS'](http://www.amazon.com/Definitive-Guide-CentOS-Professionals-ebook/dp/B004VH7L0K/ref=tmm_kin_title_0?ie=UTF8&m=AG56TWVU5XWC2 "The Definitive Guide to CentOS") is a pretty easy read and was really helpful in getting a handle on what was going on and before too long I had user accounts set up and some idea about using Yum to install packages.

After this orientation, I was able to install and setup:
<ul><li>Webmin, to make server management much easier</li>
<li>PHP, mySQL and configure the existing Apache install</li>
<li>proFTP</li>
<li>update DNS settings to route a spare domain name <a href="http://simon4.com">(Simon4)</a></li>
<li>and, finally, WordPress.</li></ul>

Having WordPress up and running was the first achievement I was aiming for, as a way to prove that I could setup and configure a server with the necessary requirements. With WordPress running, a lot of other common web hosting tasks would be possible, so I'm pretty happy with hitting this target.

So, lessons learned from a bargain-basement VPS setup?
<ul>
<li>Firstly, 128MB of RAM is nothing! Even now, the server typically idles at around 180MB being used after a reset, frequently maxing out and throwing strange errors in the SSH session. Moving up to 512MB (1024MB burstable) is only $50/year, and I'll probably make this change if I continue to use the server.</li>
<li>Second, a VPS is a great test environment. If things go horribly wrong, then it is just a button press to restore the SOE or change to a new OS.</li>
<li>Third, Linux should not be feared. I don't have a great deal of experience with Linux systems, but there is plenty of documentation and Googling for answers is a a great way to get a feel for the system and the esoteric corners that you need to explore. If something isn't working, you just start at the bottom and work backwards to find what's broken!</li>
<li>Fourth, setting up a server is a great way to see just how transparent the structure of the web really is. You get to see every cog and play with every setting. You quickly realise, just like learning HTML, that the every web site is based on the same common technical elements.</li>
<li>Lastly, the command line is woefully underrated. Being able to administer whole servers from a CLI shows the real power of the interface. SSH out is blocked at work, but I had the exact same abilities with a <a href="http://www.panic.com/blog/2011/04/introducing-prompt-ssh-for-ios/">Prompt</a> session running on my iPhone over 3G. I really look forward to developing some more bash and scripting skills to exploit the command line.</li>
</ul>

All in all, I was pretty happy with what I was able to put together for $15 and half a weekend's worth of effort and research. I've now got my own platform to experiment with, break and repair with full control (as opposed to having to fill out tickets for a hosting company to action when changing MX records - also a project that was accomplished on the weekend).
