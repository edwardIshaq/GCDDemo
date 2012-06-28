//
//  DetailViewController.h
//  GCDDemo
//
//  Created by Edward Ashak on 6/27/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "GCDMaster.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, GCDMasterDelegate>

@property (nonatomic, retain) GCDMaster *gcdMaster;
@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) IBOutlet UILabel *DemoLabel;
@property (retain, nonatomic) IBOutlet UITextView *logLabel;
@property (retain, nonatomic) IBOutlet UILabel *explainLabel;

- (IBAction)runSerialQueue;
- (IBAction)runConcurrentQueue;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *blockLabels;

@end
