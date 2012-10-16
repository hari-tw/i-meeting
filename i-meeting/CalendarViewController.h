//
//  CalendarViewController.h
//  i-meeting
//
//  Created by Sanchit Bahal on 13/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)addNew:(id)sender;

@end
