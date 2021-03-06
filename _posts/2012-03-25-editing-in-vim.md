---
layout: post
title: Editing in Vim
tags:
- command line
- Dropbox
- Solarized
- text editing
- Vim
- vimrc
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
On the path to becoming a real geek, the command line is pretty key. I've never been scared of the DOS prompt in Windows, but haven't had much exposure to the terminal in OSX or Linus until recently. As part of coming to terms with working from the keyboard, I decided to tackle one of the seminal text editors - either emacs or vi.

I ended up choosing Vim as it seemed to fit my style of working a bit better, purely personal preference. Perhaps a lot of the decision had to do with already being used to the idea of using j/k to move p and down in other programs, like Reeder and the Google apps. So I picked Vim and got to work. I had the typical initial shock of modal editing, that is, one mode for entering text and another mode for everything else, but soon began to see the logic and the power in it. I worked through the built-in tutorial, then found a few more resources to work through online (I think that [this article by Steve Losh](http://stevelosh.com/blog/2010/09/coming-home-to-vim "Coming Home To Vim") made a lot of things click in to place).

Before long, I was somewhat competent. At least, I was no longer deleting paragraphs and not knowing why, and I also learned to work out where I was saving the files I was working on - although I did spray test files throughout the file system in learning this. I found a nice theme, [Solarized](http://ethanschoonover.com/solarized "Solarized"), and worked out how to make Vim behave on the different operating systems. Importantly, I also discovered the power of the .vimrc file and set about putting together a set of options that further enhanced Vim, but without going overboard and copy/pasting dozens of other people's settings into one ugly file.

While I still don't need to use Vim for much coding (most of it is in Xcode), I try to use Vim for all my text notes and replaced Notepad with Vim as the default editor on my Windows machine. Vim's ubiquity means that I can run it on my MacBook, my Windows machines and also on the Ubuntu instances that I'm playing around with. I even put it on my iPhone and iPad, although the utility of this is still questionable! To keep everything in sync, I store my master .vimrc file in a Dropbox folder and then use the 'source' command from each machine's local .vimrc to import these settings. This means that there's only one .vimrc file to change and all the settings are kept up to date on all machines. Any OS-specific settings also get put in the local file, but there aren't very many of these. In case anyone is interested, I have added my settings files, including the master .vimrc, to my GitHub profile - these can be found at: [https://github.com/simongoudie/dotfiles](https://github.com/simongoudie/dotfiles "dotfiles").
