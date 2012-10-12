//
//  QRCodeManager.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

+ (BOOL)isMeetingRoomQrCode:(NSString *)qrCode
{
    NSArray *meetingRooms = [NSArray arrayWithObjects:@"Chandni Chowk", @"Jantar Mantar", nil];
    return [meetingRooms containsObject:qrCode];
}

@end
