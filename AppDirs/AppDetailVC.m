//
//  AppDetailVC.m
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import "AppDetailVC.h"

@implementation AppDetailVC 

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.appInfo.sandboxPaths.allKeys.count;
}

-(id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"cell" owner:self];
    
    NSString *key = [self.appInfo.sandboxPaths.allKeys objectAtIndex:row];
    
    cellView.textField.stringValue = key;
    return cellView;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
    NSString *key = [self.appInfo.sandboxPaths.allKeys objectAtIndex:self.tableView.selectedRow];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[self.appInfo.sandboxPaths objectForKey:key]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]];
    
    [self.popOver close];
}

@end
