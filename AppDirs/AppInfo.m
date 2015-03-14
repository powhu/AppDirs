//
//  AppInfo.m
//  iOSDirs
//
//  Created by Yang on 2015/03/12.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import "AppInfo.h"
#import <Cocoa/Cocoa.h>

@implementation AppInfo

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.sandboxPaths = @{}.mutableCopy;
        self.bundlePaths = @{}.mutableCopy;
    }
    return self;
}

-(void)getInfoPlistInfo:(NSURL*)bundleURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *appURL;
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL:bundleURL
                                       includingPropertiesForKeys: nil
                                                          options: NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles
                                                     errorHandler: nil];
    while ((appURL = [dirEnum nextObject]))
    {
       
        if ([[appURL.path lastPathComponent] rangeOfString: @".app"].location != NSNotFound)
        {
            NSURL *infoPlistURL = [appURL URLByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfURL:infoPlistURL] options:NSPropertyListImmutable format:nil error:nil];
            self.appName = ([info[@"CFBundleDisplayName"] length] > 0) ? info[@"CFBundleDisplayName"] : [[appURL.path lastPathComponent] stringByReplacingOccurrencesOfString:@".app" withString:@""];
            self.appShortVersion = info[@"CFBundleShortVersionString"];
            self.appVersion = info[@"CFBundleVersion"];
            //Icon
            [self getAppIcon:appURL];
            
            break;
        }
    }
}

-(void)getAppIcon:(NSURL*)appURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL:appURL
                                       includingPropertiesForKeys: nil
                                                          options: NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles
                                                     errorHandler: nil];
    
    for (NSURL *url in dirEnum)
    {
        NSString *fileName = [[url path] lastPathComponent];
        if ([fileName rangeOfString:@"AppIcon"].location != NSNotFound)
        {
            if ([fileName rangeOfString:@"57x57"].location != NSNotFound)
            {
                self.appIcon = [[NSImage alloc] initByReferencingURL:url];
                break;
            }
            else if ([fileName rangeOfString:@"60x60"].location != NSNotFound)
            {
                self.appIcon = [[NSImage alloc] initByReferencingURL:url];
                break;
            }
            else if ([fileName rangeOfString:@"76x76"].location != NSNotFound)
            {
                self.appIcon = [[NSImage alloc] initByReferencingURL:url];
                break;
            }
        }
    }
    
    if (self.appIcon == nil)
        self.appIcon = [NSImage imageNamed:@"defaultIcon"];
    else
    {
        NSImage *temp = [self.appIcon copy];
        self.appIcon = [NSImage imageWithSize:CGSizeMake(60, 60) flipped:0 drawingHandler:^BOOL(NSRect dstRect) {

            NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:dstRect xRadius:13 yRadius:13];
            [p addClip];
            [temp drawInRect:dstRect];

            return 1;
        }];
    }
}

+(NSArray*)allDeviceFolderUrl
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryDirURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] firstObject];
    NSMutableArray *deviceList = [NSMutableArray array];
    
    if (libraryDirURL != nil)
    {
        libraryDirURL = [libraryDirURL URLByAppendingPathComponent: @"Developer/CoreSimulator/Devices"];
        
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL: libraryDirURL
                                           includingPropertiesForKeys: nil
                                                              options: NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles
                                                         errorHandler: nil];
        NSURL* baseInfoURL;
        
        while ((baseInfoURL = [dirEnum nextObject]))
        {
            [deviceList addObject:baseInfoURL];
        }
        
    }
    
    return deviceList;
}

+(NSArray*)allAppInfo
{
    NSFileManager	*fileManager = [NSFileManager defaultManager];
    NSMutableArray *appArray = @[].mutableCopy;
    NSMutableDictionary *tempAppsDic = @{}.mutableCopy;
    
    for (NSURL *url in [AppInfo allDeviceFolderUrl])
    {
        //Device info
        NSURL *devicePlistURL = [url URLByAppendingPathComponent:@"device.plist"];
        NSData *deviceData = [NSData dataWithContentsOfURL:devicePlistURL];
        NSDictionary *deviceInfo = [NSPropertyListSerialization propertyListWithData:deviceData options:NSPropertyListImmutable format:nil error:nil];
        NSString *deviceName = deviceInfo[@"name"];
        NSString *osVersion = [[[deviceInfo[@"runtime"] componentsSeparatedByString:@"."].lastObject stringByReplacingOccurrencesOfString:@"iOS-" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        NSString *deviceWithOs = [deviceName stringByAppendingFormat:@" (%@)",osVersion];
        
        //Device user apps
        NSURL *launchMapInfoURL = [url URLByAppendingPathComponent: @"data/Library/MobileInstallation/LastLaunchServicesMap.plist"];
        if (launchMapInfoURL != nil && [fileManager fileExistsAtPath: [launchMapInfoURL path]])
        {
            NSData *plistData = [NSData dataWithContentsOfURL: launchMapInfoURL];
            NSDictionary *launchInfo = [NSPropertyListSerialization propertyListWithData: plistData options: NSPropertyListImmutable format: nil error: nil];
            NSDictionary *userInfo = launchInfo[@"User"];
            
            for (NSString *bundleID in userInfo.allKeys)
            {
                NSDictionary *appInfo = userInfo[bundleID];
                if ([tempAppsDic objectForKey:bundleID])
                {
                    AppInfo *app = [tempAppsDic objectForKey:bundleID];
                    [app.sandboxPaths setObject:appInfo[@"Container"] forKey:deviceWithOs];
                    [app.bundlePaths setObject:appInfo[@"BundleContainer"] forKey:deviceWithOs];
                }
                else
                {
                    AppInfo *app = [AppInfo new];
                    app.bundleID = bundleID;
                    [app getInfoPlistInfo:[NSURL URLWithString:appInfo[@"BundleContainer"]]];
                    if (app.appName.length>0)
                    {
                        [app.sandboxPaths setObject:appInfo[@"Container"] forKey:deviceWithOs];
                        [app.bundlePaths setObject:appInfo[@"BundleContainer"] forKey:deviceWithOs];
                        
                        [tempAppsDic setObject:app forKey:bundleID];
                        [appArray addObject:app];
                    }
                    
                }
            }
        }
    }
    
    return appArray;
}

@end
