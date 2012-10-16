//
//  AddNewEventViewController.m
//  i-meeting
//
//  Created by Richa on 10/16/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "AddNewEventViewController.h"

@interface AddNewEventViewController ()

@end

@implementation AddNewEventViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidUnload {
    [self setSubjectField:nil];
    [self setDescriptionField:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (IBAction)bookButton:(id)sender {
    
    
//    
//    eventStore=[[EKEventStore alloc] init];
//    EKEvent *addEvent=[EKEvent eventWithEventStore:eventStore];
//    addEvent.title=@"hello";
//    addEvent.startDate=messageDate;
//    addEvent.endDate=[addEvent.startDate dateByAddingTimeInterval:600];
//    [addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
//    addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:addEvent.startDate]];
//    [eventStore saveEvent:addEvent span:EKSpanThisEvent error:nil];
}
@end
