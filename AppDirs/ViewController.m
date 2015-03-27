//
//  ViewController.m
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import "ViewController.h"
#import "AppInfo.h"
#import "AppDetailVC.h"

@implementation MyWindowController

- (IBAction)reload:(id)sender
{
    ViewController *vc = (ViewController*)self.window.contentViewController;
    [vc getApps];
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSCollectionViewItem *cell = [self.storyboard instantiateControllerWithIdentifier:@"cell"];
    self.collectionView.itemPrototype = cell;
    
    [self getApps];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"appName" ascending:1 selector:@selector(caseInsensitiveCompare:)];
    [self.arrayController setSortDescriptors:@[sort]];
    
    [self.arrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)getApps
{
    NSMutableArray *temp = @[].mutableCopy;
    for (AppInfo *app in [AppInfo allAppInfo])
        [temp addObject:app];
    self.appArray = temp;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.arrayController.selectionIndexes.count)
    {
        NSPopover *popOver = [[NSPopover alloc] init];
        AppDetailVC *vc = [self.storyboard instantiateControllerWithIdentifier:@"AppDetailVC"];
        vc.popOver = popOver;
        vc.appInfo = [self.arrayController.arrangedObjects objectAtIndex:self.arrayController.selectionIndex];
        popOver.contentViewController = vc;
        popOver.behavior = NSPopoverBehaviorTransient;
        popOver.delegate = self;
        
        [popOver showRelativeToRect:[self.collectionView frameForItemAtIndex:self.arrayController.selectionIndex] ofView:_collectionView preferredEdge:10];
    }
}

-(void)popoverDidClose:(NSNotification *)notification
{
    self.arrayController.selectionIndexes = [NSIndexSet indexSet];
}

@end
