//
//  CalendarCell.h
//  i-meeting
//
//  Created by Sanchit Bahal on 30/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
