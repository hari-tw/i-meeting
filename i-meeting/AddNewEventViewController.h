//
//  AddNewEventViewController.h
//  i-meeting
//
//  Created by Richa on 10/16/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewEventViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *meetingRoomId;
@property (strong, nonatomic) NSString *meetingRoomName;

- (IBAction)bookButton:(id)sender;
- (IBAction)datePicked:(UIDatePicker *)sender;
-(IBAction)textFieldReturn:(id)sender;
-(NSString *)validateEventTitle:(NSString *)title Description:(NSString *)description StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
@end
