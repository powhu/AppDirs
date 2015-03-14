//
//  AppInfo.h
//  iOSDirs
//
//  Created by Yang on 2015/03/12.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property (nonatomic, strong) NSString *bundleID;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appShortVersion;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSImage *appIcon;

@property (nonatomic, strong) NSMutableDictionary *bundlePaths;
@property (nonatomic, strong) NSMutableDictionary *sandboxPaths;

+(NSArray*)allAppInfo;

@end
