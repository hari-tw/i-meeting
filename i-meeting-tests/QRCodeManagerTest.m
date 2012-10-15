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
    
    GHAssertTrue([manager isMeetingRoomQrCode:@"Parliament"], @"Assertion failed");
    GHAssertTrue([manager isMeetingRoomQrCode:@"Chandni Chowk"], @"Assertion failed");
    GHAssertTrue([manager isMeetingRoomQrCode:@"Jantar Mantar"], @"Assertion failed");
    
    GHAssertFalse([manager isMeetingRoomQrCode:@"foo"], @"Assertion failed");
}

@end
