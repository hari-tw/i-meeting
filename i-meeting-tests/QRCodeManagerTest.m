//
//  QRCodeControllerTest.m
//  meWorks
//
//  Created by Sanchit on 21/08/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "QRCodeManagerTest.h"
#import "QRCodeManager.h"

@implementation QRCodeManagerTest

- (void)testForAValidMeetingRoom
{
    QRCodeManager *manager = [QRCodeManager new];
    
    NSMutableArray *meetingRoomArray = [NSMutableArray new];
    [meetingRoomArray addObject:@"Parliament"];
    [meetingRoomArray addObject:@"thoughtworks.com_383736383938353235@resource.calendar.google.com"];
    
    GHAssertTrue([manager isMeetingRoomQrCode:meetingRoomArray], @"Assertion failed");
    
    [meetingRoomArray removeLastObject];
    [meetingRoomArray addObject:@""];
    GHAssertFalse([manager isMeetingRoomQrCode:meetingRoomArray], @"Assertion failed");
}

@end
