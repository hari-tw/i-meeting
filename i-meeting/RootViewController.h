//
//  ViewController.h
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "GTLServiceCalendar.h"

@interface RootViewController : UIViewController <UIAlertViewDelegate,ZBarReaderDelegate>

- (IBAction)btnScan:(UIButton *)sender;
- (IBAction)btnCalendar:(id)sender;
- (void)setCalendarUrl:(NSString *)calendarUrl;
- (void)signInUser:(SEL)signInDoneSelector;
- (UIViewController *)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;
+ (GTLServiceCalendar *) getService;

@end

