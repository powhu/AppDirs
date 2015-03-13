//
//  ViewController.h
//  AppDirs
//
//  Created by Yang on 2015/03/13.
//  Copyright (c) 2015年 Yang PowHu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSCollectionViewDelegate,NSPopoverDelegate>

@property (strong) IBOutlet NSCollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *appArray;
@property (strong) IBOutlet NSArrayController *arrayController;

@end

