//
//  DetailedViewController.h
//  i-meeting
//
//  Created by Akriti Ayushi on 12/9/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController

 @property (strong, nonatomic) id selected;
@property (weak, nonatomic) IBOutlet UILabel *Sample;

@end