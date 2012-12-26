//
//  DetailedViewController.h
//  i-meeting
//
//  Created by Akriti Ayushi on 12/24/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) id event;
@property (weak, nonatomic) IBOutlet UITableView *detailsText;
//@property (weak, nonatomic) IBOutlet UITextView *detailsText;
@property (strong, nonatomic) NSString *viewTitle;
@end
