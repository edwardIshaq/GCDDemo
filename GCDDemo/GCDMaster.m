//
//  GCDMaster.m
//  GCDDemo
//
//  Created by Edward Ashak on 6/27/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#import "GCDMaster.h"

@implementation GCDMaster

@synthesize delegate;
@synthesize log;
@synthesize blockCounter;

static dispatch_queue_t serialQueue = NULL;
static dispatch_queue_t concurrentQueue = NULL;

+ (void)initialize {
    //create a serial Block
    serialQueue = dispatch_queue_create("com.3Pillar.SerialQueue", NULL);
    //Create a concurrent Block
    concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

    //make sure queues are suspended, they will be resumed later
    dispatch_suspend(serialQueue);
    dispatch_suspend(concurrentQueue);
}
- (id)init {
    self = [super init];
    if (self) {
        self.log = [[NSMutableString new] autorelease];
        queueState = QueueStateNone;
    }
    return self;
}

- (void)blockDemo {
    queueState = QueueStateNone;
    [self.log setString:@""];
    
    NSArray *inputArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",[NSObject new],@"a",@"b", nil];
    __block GCDMaster *gcdMaster = self;
    
    [self.log appendFormat:@"\nIterating on array:\n%@",inputArray];
    
    [inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSMutableString *msgs = gcdMaster.log;
        
        if (![obj isKindOfClass:[NSString class]]) {
            [msgs appendFormat:@"\nfound the first different Object: %@",obj];
            *stop = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [gcdMaster updateDelegate];
            });
        }
        else {
            [msgs appendFormat:@"\n%@ at index:%d", obj, idx];
        }
        
        return;
    }];
}

- (void)updateDelegate {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(GCDMasterDelegate)]) {
        [self.delegate GCDMaster:self finishedWithString:[NSString stringWithString:self.log]];
    }
}

- (void)updateUI {
    if (queueState == QueueStateSerial) {
        dispatch_suspend(serialQueue);
    }
    else if (queueState == QueueStateConcurrent){
        dispatch_suspend(concurrentQueue);
    }
    queueState = QueueStateNone;
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(GCDMasterDelegate)]) {
        [self.delegate GCDMaster:self finishedWithString:[NSString stringWithString:self.log]];
    }
}

static void (^counterBlock)(int,char, NSUInteger , GCDMaster*) = ^(int count, char letter, NSUInteger blockNumber, GCDMaster *delegate){
    NSString *blockName = [NSString stringWithFormat:@"Block #%d", blockNumber];
    [delegate.log appendString:[NSString stringWithFormat:@"\n=========== Start %@=============\n start from %c do %d iterations",blockName,letter, count]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate.delegate GCDMaster:delegate blockNumber:blockNumber changedStatus:BlockStatusStarted];
    });
    
    NSMutableString *msg = [NSMutableString new];
    for(int i=0; i<count; i++){
        //Do some work here
        [msg appendString:[NSString stringWithFormat:@"\nRunning %@: iteration %d - asci: %c",blockName,i, letter]];
        letter++;
    }
    [msg release];
    @synchronized(delegate){
        [delegate.log appendString:[NSString stringWithFormat:@"\n=========== END %@=============\n", blockName]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate.delegate GCDMaster:delegate blockNumber:blockNumber changedStatus:BlockStatusFinished];
        if (++delegate.blockCounter == 4) [delegate updateUI];
    });
};


- (void)serialQueueDemo {
    blockCounter = 0;
    
    if (queueState == QueueStateConcurrent) 
    {
        dispatch_suspend(concurrentQueue);
    }
    dispatch_resume(serialQueue);
    queueState = QueueStateSerial;
 
    [self.log setString:@""];
    dispatch_async(serialQueue, ^{counterBlock(20000  ,'a'    ,0  ,self);});
    dispatch_async(serialQueue, ^{counterBlock(1000   ,'A'    ,1  ,self);});
    dispatch_async(serialQueue, ^{counterBlock(20000  ,'0'    ,2  ,self);});
    dispatch_async(serialQueue, ^{counterBlock(2000   ,'Z'    ,3  ,self);});
 
}

- (void)concurrentQueueDemo {
    blockCounter = 0;
    if (queueState == QueueStateSerial) {
        dispatch_suspend(serialQueue);
    }
    dispatch_resume(concurrentQueue);
    queueState = QueueStateConcurrent;
    
    [self.log setString:@""];
    dispatch_async(concurrentQueue, ^{counterBlock(20000  ,'a'    ,0  ,self);});
    dispatch_async(concurrentQueue, ^{counterBlock(1000   ,'A'    ,1  ,self);});
    dispatch_async(concurrentQueue, ^{counterBlock(20000  ,'0'    ,2  ,self);});
    dispatch_async(concurrentQueue, ^{counterBlock(2000   ,'Z'    ,3  ,self);});

}
@end
