//
//  GCDMaster.h
//  GCDDemo
//
//  Created by Edward Ashak on 6/27/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defenitions.h"
@protocol GCDMasterDelegate;


@interface GCDMaster : NSObject {
    QueueState queueState;
    short blockCounter;
}

@property (assign) id <GCDMasterDelegate> delegate;
@property (nonatomic, retain) NSMutableString *log;

- (void)blockDemo;
- (void)serialQueueDemo;
- (void)concurrentQueueDemo;

@end


@protocol GCDMasterDelegate <NSObject>

- (void)GCDMaster:(GCDMaster*)gcdMaster finishedWithString:(NSString*)result;
- (void)GCDMaster:(GCDMaster*)gcdMaster blockNumber:(NSUInteger)blockNumber changedStatus:(BlockStatus)status;
@end