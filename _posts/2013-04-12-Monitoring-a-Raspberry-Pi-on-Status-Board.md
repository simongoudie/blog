---
layout: post
draft: false
title: Monitoring a Raspberry Pi on Status Board
---

[Panic's](http://panic.com) latest iPad app, [Status Board](http://panic.com/statusboard), offers a really attractive dashboard to monitor key statistics, email, social media and other goings on. I really don't have that much use for it, but I downloaded it to play with anyway.


One thing that I thought I could monitor was the CPU load on my [Raspberry Pi](http://raspberrypi.org) server that I keep running from home. It's not a production server, just a sandbox to play in, but I thought it would be the kind of thing that Status Board should be used for. Seeing that Status Board works well with [StatHat](http://stathat.com), and that StatHat offer a feature-reduced free tier, I thought I would see if I could tie all of these together to get something happening.


Here's what I got to work. I'm sure there are better ways to do this and I'm sure something like [Nagios](http://nagios.org) would be a much better alternative, but this was what I chose to play with.


###Getting stats from the Raspberry Pi
My Pi runs [Arch](http://archlinux.org) and is a very barebones setup. It's easy to get the current CPU load average via the `/proc/loadavg` file. This file gives the load average for the last one, five and 15 minute window, as well as some process info. I wanted to log the one-minute average, so only needed the first four characters of this file to be dumped out. Starting a short script, the line


```
loadavg=`head -c 4 /proc/loadavg`
```

was enough to grab the current one-minute average and place it in a variable called 'loadavg'.


###Sending the stats to StatHat
StatHat make it really easy to send them data to log. There are a whole stack of ways to do this programatically, but I opted to use the [cURL](http://curl.haxx.se) method so I could add it to the same script. Once you have a StatHat account ready, sending the data is as easy as adding a single line to finish the script:

```
curl -d "stat=Pi Load&email=YOUR@EMAIL.COM&value=$loadavg" http://api.stathat.com/ez
```

This takes the figure that we pulled from `/proc/loadavg` and send it to StatHat to add to the 'Pi Load' log.


###Doing this more than once
Having the commands to pull the data and send it are great and putting them in a script makes it even easier, but it's no good unless this is being done regularly and automatically. A cron job to do this every five minutes takes care of this task. I'm certainly not a cron expert, but here's what works for me. Running `crontab -e` will open your editor to enter the cron tasks. The syntax to do this is better explained at [this site](http://www.thegeekstuff.com/2011/07/cron-every-5-minutes/) than what I could do, but, effectively, this line will run your script every five minutes and scrap any output (otherwise cron may email it to you, a great way to fill your inbox):

```
*/5 * * * * ~/path/to/your/script.sh > /dev/null 2>&1
```


The script I run is literally just the two lines that I mentioned above, here's the whole thing:

```
#! /bin/zsh
loadavg=`head -c 4 /proc/loadavg`
curl -d "stat=Pi Load&email=YOUR@EMAIL.COM&value=$loadavg" http://api.stathat.com/ez
```


###Displaying the log on Status Board
StatHat is one of the two services that are already integrating with Status Board. This makes it super easy to drop the log into Status Board and have it come out as a nice graph. Just visit the log on the StatHat site, choose the timeframe you want to plot and look for the 'Status Board Graph URL' button at the bottom of the page. This can email the URL to your iPad. Once there, copy the URL, open Status Board and add a new graph, pasting in the URL you received.


###That's about it
With the graph added, you're all done - the cron job will pull the load data every five minutes and send it to StatHat, where it will be pulled from Status Board to display. It may look something like this:

![Pi Load on Status Board]({{ site.url }}/img/piload.jpg "Pi Load on Status Board")


I quite like StatHat - they offer a really good site and adding data is dead easy. Unfortunately, their [one price point of US$99/month](http://www.stathat.com/pricing) means that it won't be worth me signing up to unlock all the features of the site and will remain on their free plan, limited to ten stats (probably enough) with no automatic alerts or small-interval tracking (a bit disappointing). Hopefully, more services will be integrating with Status Board soon and the options will open up a bit.
