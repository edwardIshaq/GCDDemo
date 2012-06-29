//
//  DetailViewController.m
//  GCDDemo
//
//  Created by Edward Ashak on 6/27/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#import "DetailViewController.h"
#import "Defenitions.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize blockLabels = _blockLabels;
@synthesize runButtons = _runButtons;

@synthesize detailItem = _detailItem;
@synthesize DemoLabel = _DemoLabel;
@synthesize logLabel = _logLabel;
@synthesize explainLabel = _explainLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize gcdMaster;


- (void)dealloc
{
    [_detailItem release];
    [_masterPopoverController release];
    [_DemoLabel release];
    [_logLabel release];
    [_explainLabel release];
    [_blockLabels release];
    [_runButtons release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)resetBlockLabels {
    [self.blockLabels makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:[UIColor yellowColor]];
}
- (void)configureView
{
    // Update the user interface for the detail item.
    [self resetBlockLabels];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.gcdMaster = [[GCDMaster new] autorelease];
    self.gcdMaster.delegate = self;
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDemoLabel:nil];
    [self setLogLabel:nil];
    [self setExplainLabel:nil];
    [self setBlockLabels:nil];
    [self setRunButtons:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (UIColor*)colorForStatus:(BlockStatus)blockStatus {
    if (blockStatus == BlockStatusNotStarted) {
        return [UIColor yellowColor];
    }
    else if (blockStatus == BlockStatusStarted) {
        return [UIColor greenColor];
    }
    else if (blockStatus == BlockStatusFinished) {
        return [UIColor redColor];
    }
    return [UIColor grayColor];
}

- (void)setButtonsEnabled:(BOOL)state {
    for (UIButton *btn in self.runButtons) {
        btn.enabled = state;
    }
}

#pragma mark -
#pragma mark Queue calls
- (void)runSerialQueue {
    [self setButtonsEnabled:NO];
    
    [self resetBlockLabels];
    self.DemoLabel.text = @"Running Serial Queue Demo";
    self.explainLabel.text = @"This will execute 4 blocks in a serial manner, each block will iterate for a differnet number of times.\nNotice that each the blocks are executed one after the other";
    self.logLabel.text = @"";
    [gcdMaster serialQueueDemo];
}
- (void)runConcurrentQueue {
    [self setButtonsEnabled:NO];[self resetBlockLabels];
    self.DemoLabel.text = @"Running Concurrent Queue Demo";
    self.explainLabel.text = @"This will execute 4 blocks in a concurrent manner, each block will iterate for a differnet number of times.\nNotice that the messages come from different blocks and how they interlace";
    self.logLabel.text = @"";
    [gcdMaster concurrentQueueDemo];
}

- (IBAction)runBlockDemo:(id)sender {
    [self setButtonsEnabled:NO];[self resetBlockLabels];
    self.DemoLabel.text = @"Running Block Demo";
    self.explainLabel.text = @"This will demo the use of a block as a method argument";
    self.logLabel.text = @"";
    [gcdMaster blockDemo];
}

- (void)GCDMaster:(GCDMaster *)gcdMaster finishedWithString:(NSString *)result {
    [self setButtonsEnabled:YES];
    self.logLabel.text = result;
}
- (void)GCDMaster:(GCDMaster *)gcdMaster blockNumber:(NSUInteger)blockNumber changedStatus:(BlockStatus)status{
    UIColor *statusColor = [self colorForStatus:status];
    UILabel *blockLabel = [self.blockLabels objectAtIndex:blockNumber];
    [blockLabel setBackgroundColor:statusColor];
}
@end
