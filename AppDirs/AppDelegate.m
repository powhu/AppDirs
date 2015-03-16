//
//  AppDelegate.m
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSWindow *window = [[NSApplication sharedApplication] windows].firstObject;
    window.titleVisibility = NSWindowTitleHidden;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
