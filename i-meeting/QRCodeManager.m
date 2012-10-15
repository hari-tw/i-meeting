//
//  QRCodeManager.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "QRCodeManager.h"

@interface QRCodeManager()

@property (readonly, strong) NSArray *meetingRooms;

@end

@implementation QRCodeManager

@synthesize meetingRooms = _meetingRooms;

- (NSArray *)meetingRooms {
    if (!_meetingRooms) {
        _meetingRooms = [NSArray arrayWithObjects:@"Parliament", @"Chandni Chowk", @"Jantar Mantar", nil];
    }
    
    return _meetingRooms;
}

- (BOOL)isMeetingRoomQrCode:(NSString *)qrCode
{
    return [self.meetingRooms containsObject:qrCode];
}

@end
