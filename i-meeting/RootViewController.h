//
//  ViewController.h
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RootViewController : UIViewController <ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)btnCalendar:(id)sender;
- (UIViewController *)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;

@end

