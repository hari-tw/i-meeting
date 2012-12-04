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

- (IBAction)bookButton:(id)sender;
- (IBAction)datePicked:(UIDatePicker *)sender;
-(IBAction)textFieldReturn:(id)sender;
@end
