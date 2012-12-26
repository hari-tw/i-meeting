//
//  DetailedViewController.h
//  i-meeting
//
//  Created by Akriti Ayushi on 12/26/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController
{
}


@property (nonatomic) id event;
@property (weak, nonatomic) IBOutlet UIWebView *detailsText;

@end