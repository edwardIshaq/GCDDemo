//
//  MasterViewController.h
//  GCDDemo
//
//  Created by Edward Ashak on 6/27/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
