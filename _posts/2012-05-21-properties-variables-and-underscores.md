---
layout: post
title: Properties, variables and underscores
tags:
- development
- github
- Objective-C
- properties
- synthesize
- turns out
- underscores
- variables
- Xcode
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
This was something that confused me for quite a while. No doubt I'm still missing most of the detail involved, but I wanted to jot down here my current understanding of the way instance variables and properties are used in Objective-C code.

The puzzle starts with the header code that is in many tutorials and examples (please bear with my mockup):

    @interface TheClassName : NSObject <NSCoding> {
        NSMutableArray * _foo;
        NSInteger _bar;
    }

    @property NSMutableArray * foo;
    @property NSInteger bar;

and then continues at the start of the matching .m file:

    #import "TheClassName.h"

    @implementation TheClassName

    @synthesize foo = _foo;
    @synthesize bar = _bar;

In isolation, I understood the idea of declaring variables, as well as the idea of synthesizing properties. However, looking at the above combination, why declare variables, then created them as properties, synthesize them, and then complicate things by using names with underscores? Seems like trebling the work and then obfuscating it!

Thankfully, we have [StackOverflow](http://stackoverflow.com "Stack Overflow"), which has addressed this matter a number of times. The question that helped me the most, though, was this one: '[Why do you use an underscore for an instance variable, but not its corresponding property?](http://stackoverflow.com/questions/2371489/why-do-you-use-an-underscore-for-an-instance-variable-but-not-its-corresponding "Stack Overflow ivars and underscores")'

[Turns out](https://twitter.com/#!/hotdogsladies/statuses/72390171408089088 "Turns Out"), the underscore works to differentiate the raw instance variable (_foo), which should only be referenced from inside the instance (and even then it's apparently not a good idea, for reasons to do with reference counting I think), with the property (foo) and its associated methods (foo and setFoo), which can be safely used and called from elsewhere. Therefore, when setting foo, you have the option of the unsafe 

    _foo = x;

or the safer

    [self setFoo:x];

or, from outside the class, the safe

    [TheClassName setFoo:x];

It's an added layer of abstraction from working directly with the variable, but if it makes it safer to rely on Xcode's memory management, then I'm ok with that. Looking back over the code I've been writing, I realised that I had a fantastic combination of property usage and variable usage, with no logic behind any of it. A short time later, all of that was much more consistent and made full use of the properties, with no remaining references to the raw variables. Everything compiled and ran fine, so I feel much more confident about the way I'm creating and using these properties.

[The code is still on GitHub](https://github.com/simongoudie/Tracking "GitHub: Simon Goudie") and any comments would be appreciated. Likewise, I'm sure the above story is wildly inaccurate in parts, so let me know!
