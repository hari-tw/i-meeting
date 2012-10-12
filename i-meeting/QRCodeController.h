//
//  QRCodeController.h
//  meWorks
//
//  Created by Sanchit on 17/08/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBarSDK.h"

@interface QRCodeController : NSObject <ZBarReaderDelegate>

- (UIViewController *)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;

@end
