//
// Created by Hari B on 05/12/13.
// Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Room.h"
#import "ESTBeacon.h"


@interface Rooms : NSObject

- (Room *)get:(ESTBeacon *)beacon;
@end