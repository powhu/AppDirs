//
//  AppDetailVC.h
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppInfo.h"

@interface AppDetailVC : NSViewController <NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic,strong) AppInfo *appInfo;
@property (nonatomic,weak) NSPopover *popOver;
@property (strong) IBOutlet NSTableView *tableView;

@end
