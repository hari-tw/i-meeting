//
//  QRCodeManager.h
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject

+ (BOOL)isMeetingRoomQrCode:(NSString *)qrCode;

@end
