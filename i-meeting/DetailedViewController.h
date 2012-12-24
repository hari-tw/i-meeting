//
//  DetailedViewController.h
//  i-meeting
//
//  Created by Akriti Ayushi on 12/24/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController
{
 
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) id event;

@property (weak, nonatomic) IBOutlet UILabel *calendarIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *organiserLabel;
@property (weak, nonatomic) IBOutlet UITextView *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (strong, nonatomic) NSString *viewTitle;
@end
