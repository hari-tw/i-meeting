//
//  DetailedViewController.h
//  i-meeting
//
//  Created by Akriti Ayushi on 12/26/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController <UIScrollViewDelegate>
{
    UILabel *dynamicLabel;
    CGSize previousLabelSize;
    NSArray *titleFontDetails;
    NSArray *subTitleFontDetails;
    NSArray *textFontDetails;
    NSMutableArray *attendeesStatusAccepted;
    NSMutableArray *attendeesStatusTentative;
    NSMutableArray *attendeesStatusDeclined;
    NSMutableArray *attendeesStatusNoReply;
}

-(void)initializeFontSettings;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) id event;
@end