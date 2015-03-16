//
//  AppDetailVC.m
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//
#import "ViewController.h"
#import "AppDetailVC.h"

@implementation AppDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
}

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

- (IBAction)deleteApp:(id)sender
{
    for (NSString *key in self.appInfo.bundlePaths.allKeys)
    {
        NSString *path = [self.appInfo.bundlePaths objectForKey:key];
        NSURL *url = [NSURL fileURLWithPath:path];
        [[NSFileManager defaultManager] trashItemAtURL:url resultingItemURL:nil error:nil];
    }
    
    for (NSString *key in self.appInfo.sandboxPaths.allKeys)
    {
        NSString *path = [self.appInfo.sandboxPaths objectForKey:key];
        NSURL *url = [NSURL fileURLWithPath:path];
        [[NSFileManager defaultManager] trashItemAtURL:url resultingItemURL:nil error:nil];
    }
    
    ViewController *vc = (ViewController*)self.popOver.delegate;
    [vc.arrayController removeObject:self.appInfo];
    [self.popOver close];
}

@end
