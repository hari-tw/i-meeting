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
    GHAssertTrue([QRCodeManager isMeetingRoomQrCode:@"Chandni Chowk"], @"Assertion failed");
    GHAssertFalse([QRCodeManager isMeetingRoomQrCode:@"foo"], @"Assertion failed");
}

@end
