---
layout: post
title: Three ways to save data in iOS apps
tags:
- apps
- development
- file system
- iOS
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
Today I tested three different ways to implement data saving in a test iOS app. Here's what I got to work:

The save and load snippets here fit into the app by storing the data when a 'save' button is pressed, and recalling it when the 'load' button is pressed. In each case, the function is called with the text to be saved passed to it as the NSString object 'textToWrite'.

*Using a file, text.txt:*

    + (void) writeToFile:(NSString *) textToWrite {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Text.txt"];
        NSError *error;
        NSLog(@"filePath = %@ and textToLoad = %@", filePath, textToWrite);
        [textToWrite writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error: &error];
    };

    + (NSString *) loadFromFile {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Text.txt"];
            NSError *error;
            NSString *textToLoad = [NSString stringWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error: &error];
            NSLog(@"filePath = %@ and textToLoad = %@", filePath, textToLoad);
            if (textToLoad) {  
                return textToLoad;  
            } else
                return nil;
    };

*Using user defaults:*

    + (void) writeToFile:(NSString *) textToWrite {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:textToWrite forKey:@"savedText"];
        [prefs synchronize];
    };

    `+ (NSString *) loadFromFile {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *textToLoad = [NSString stringWithFormat:@""];
        textToLoad = [prefs stringForKey:@"savedText"];
        NSLog(@"Using defaults, textToLoad = %@", textToLoad);
        if (textToLoad) {  
            return textToLoad;  
        } else
            return nil;
    };

*Using property lists (some of this is copy/paste, but I think I get most of what's going on):*

    + (void) writeToFile:(NSString *) textToWrite {
        NSString *error = @"Save failed";
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"savefile.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObject:textToWrite forKey:@"savedText"];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
        else {
            NSLog(@"Something happened. Error message is: %@",error);
        }   
    };

    + (NSString *) loadFromFile {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"savefile.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"savefile" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                  format:&format errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        NSLog(@"Using plist at %@, textToLoad = %@", plistPath, [temp valueForKey:@"savedText"]);
        return [temp valueForKey:@"savedText"];
    };

User defaults is obviously the easiest of the options, although it's probably also the least correct option to use in most cases. For this app, which is a simple text editor that can save and reload files, the file-based method is probably the most appropriate.
