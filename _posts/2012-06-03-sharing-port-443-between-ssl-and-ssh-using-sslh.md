---
layout: post
title: Sharing port 443 between SSL and SSH using SSLH
tags:
- Apache
- CentOS
- certificates
- firewall
- localhost
- multiplexing
- port 22
- port 443
- ports
- sharing
- ssh
- ssl
- sslh
- VPS
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
The port that SSH runs on, port 22, is firewalled on a lot of networks. Conversely, ports 80 and 443 are almost always open for HTTP and HTTPS traffic, respectively. This presents an opportunity to SSH via port 443 rather than 22. However, only one service can listen on a port at once, so you would usually have to choose to run one or the other. There is another service though, [SSLH](http://www.rutschle.net/tech/sslh.shtml "SSLH"), that can run as a multiplexer and listen on 443 instead of SSL or SSH. When SSLH receives traffic, it can decide if it should go to SSL or SSH and redirect accordingly, effectively meaning that both SSL and SSH can run on the same port.

Setting up SSLH was more of a learning experience than I expected, so I'm making some notes here that might help someone else, and myself in future.

Installing on my [CentOS VPS](http://simongoudie.com/blog/vps-an-education-in-servers/ "VPS - an education in servers") ([affiliate link!](http://www.comforthost.net/billing/aff.php?aff=155 "SpotVPS")) was simple enough. Yum found it and installed it using a simple:

    yum install sslh

Looking at the readme file gives a quick copy instruction for CentOS to set up the config file:

    cp scripts/etc.rc.d.init.d.sslh /etc/rc.d/init.d/sslh

That's the easy bit - SSLH is now ready to run, but there's a bit of configuration to do first. The goal is to reach the following situation:
<ul>
<li>Connection is made to port 443</li>
<li>SSLH receives it and recognises traffic type</li>
<li>If SSH, the traffic is passed to localhost:22, where SSH is listening on all port 22 connections</li>
<li>If SSL, the traffic is passed to localhost:443, where Apache is listening only on localhost:443 for secure connections</li>
</ul>

The SSLH configuration file (at /etc/init.d/sslh) looks pretty straightforward, with only one line to change:

    OPTIONS="--user nobody --pidfile $PIDFILE -p 0.0.0.0:443 --ssl localhost:443 --ssh localhost:22

Looking at this line, the intention is to set the user running the process as 'nobody'; allocate a process id; listen at 0.0.0.0:443, which is port 443 on all IP addresses; redirect SSL traffic to localhost:443; and redirect SSH traffic to localhost:22 (Note that this is NOT the configuration that worked for me, keep reading).

It's worth noting that there are other SSLH configuration files, such as /etc/sysconfig/sslh. I'm sure that these are there to make the settings easier, and indeed the readme references the one at /etc/default/sslh, but I just ended up getting confused and setting conflicting options. In the end, I just deleted the additional settings files and just used the main file at /etc/init.d/sslh.

SSH doesn't need to be changed, as by default it listens to port 22 on all IPs, including localhost. As a side note, localhost should be equivalent to 127.0.0.1 and to the machine name.

SSL does need to be changed, as by default, it will be listening to port 443 on all IPs. This will clash with SSLH, which needs sole access to port 443. Instead, according to our goals above, we need SSL to listen only on localhost:443. This is where I ran into trouble. Apache has one main config file at /etc/httpd/conf/httpd.conf where the main LISTEN directives are listed, however, neither Listen 443 nor Listen localhost:443 should go there. The secure site is handled as a virtual host, which has a spot at the bottom of the httpd.conf file. The virtual host section contains all the information about the SSL certificates (another post altogether) as well as the port to listen on. However, another gotcha is that the httpd.conf file includes other files, in the same way that source files use 'require' and 'include' or web files can pull in css or javascript files. In this case, the httpd.conf pulls in the file at /etc/httpd/conf.d/ssl.conf. It is in this file that the virtualhost settings should be listed. Getting these mixed up means that you're very like to get overlaps on ports when you restart Apache.

Making things more complex was that, no matter what I did, I couldn't resolve the clash caused by SSLH listening to port 443 on all IPs and SSL listening on localhost:443, which is obviously included in all IPs. I never worked this out, and instead changed SSL to listen on port 442 with the virtualhost section starting with:

    <VirtualHost localhost:442>

This meant that the SSLH config file also needed to be updated to point SSL traffic to localhost:442 instead of localhost:443. Clash resolved, with the SSLH options line now reading:

    OPTIONS="--user nobody --pidfile $PIDFILE -p 0.0.0.0:443 --ssl localhost:442 --ssh localhost:22

Restarting the HTTPD service, then the SSLH service and then using a web browser to check the https:// site, it looked like all was in order for the SSL setup. Unfortunately, SSH was still not working on port 443. When trying to connect, the client would initiate the connection, but receive no response from the server. Switching SSLH to the foreground verbose mode with the --v switch, it showed that it was intercepting the traffic, but the connection was being refused (suspiciously, the error included the letters ssl). No amount of port configuration changing on either the SSLH side or the SSH side was helping and I was ready to admit defeat. As one last test, I deleted the --ssl section from the SSLH options line to remove SSL from the equation. SSH then connected perfectly. I then added the --ssl section back in, but this time *after* the --ssh section. Restarted all services and both SSL and SSH ran beautifully via external connections on port 443! I can only assume that SSL was jumping in first and causing trouble by not passing the traffic to SSH. By reordering the options, SSH must get first shot at the traffic and must be better at deciding to take it or pass it on to SSL.

The final /etc/init.d/sslh options line used was:

    OPTIONS="--user nobody --pidfile $PIDFILE -p 0.0.0.0:443 --ssh localhost:22 --ssl localhost:442

Obviously, this is not a perfect setup and I'm sure I've overlooked some basic points, especially about how to leave Apache listening to localhost:443 rather than switching to localhost:442. However, I'm happy to have SSLH working correctly and now have a much better understanding of how Apache is configured, how ports are configured and how Linux services work.

So, for future reference, my SSLH 1.13 setup checklist for CentOS 6.2 is as follows (assuming correct permissions level and not including TLS/SSL certificate setup):
<ul>
<li>install SSLH:</li>'yum install sslh'
<li>copy the CentOS config file across:</li>'cp scripts/etc.rc.d.init.d.sslh /etc/rc.d/init.d/sslh'
<li>set Apache to listen for secure sites on localhost:442, using /etc/httpd/conf.d/ssl.conf:</li> '&lt;VirtualHost localhost:442&gt;...'
<li>set SSLH options line in /etc/init.d/sslh:</li> 'OPTIONS="--user nobody --pidfile $PIDFILE -p 0.0.0.0:443 --ssh localhost:22 --ssl localhost:442'
<li>(re)start services, first:</li> 'service httpd restart'
<li> and then:</li> 'service sslh start'
</ul>
