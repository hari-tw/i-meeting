//
// Created by Hari B on 05/12/13.
// Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//


#import "Rooms.h"

@implementation Rooms {
    NSMutableArray *rooms;
}

-(id)init {
    if ( self = [super init] ) {
        rooms = [[NSMutableArray  alloc]init];
        [rooms addObject:[Room mayoHall]];
        [rooms addObject:[Room majestic]];
        [rooms addObject:[Room cubbonPark]];

    }
    return self;
}
- (Room *)get:(ESTBeacon *)beacon {

    for (Room *room in rooms) {
        if ([room.majorValue unsignedShortValue]   == [beacon.ibeacon.major integerValue] &&
                [room.minorValue unsignedShortValue] == [beacon.ibeacon.minor unsignedShortValue]) {
             return room;
        }
    }
    return nil;
}
@end