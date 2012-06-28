//
//  Defenitions.h
//  GCDDemo
//
//  Created by Edward Ashak on 6/28/12.
//  Copyright (c) 2012 PointAbout. All rights reserved.
//

#ifndef GCDDemo_Defenitions_h
#define GCDDemo_Defenitions_h

typedef enum {
    QueueStateNone,
    QueueStateSerial,
    QueueStateConcurrent
} QueueState;

typedef enum { 
    BlockStatusNotStarted,
    BlockStatusStarted,
    BlockStatusFinished
} BlockStatus;

#endif
