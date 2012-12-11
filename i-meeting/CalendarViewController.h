//
//  NewCalendarViewController.h
//  i-meeting
//
//  Created by Sanchit Bahal on 24/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UITableViewController

{
       NSMutableArray *dataArray;

}
@property (nonatomic) NSArray *events2;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) NSString *viewTitle;
@property (strong, nonatomic) NSString *calendarId;
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
- (IBAction)animate:(id)sender;
@end
