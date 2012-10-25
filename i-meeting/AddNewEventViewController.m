//
//  AddNewEventViewController.m
//  i-meeting
//
//  Created by Richa on 10/16/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "AddNewEventViewController.h"
#import "GTLCalendarEvent.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLServiceCalendar.h"
#import "GTLQueryCalendar.h"

@interface AddNewEventViewController ()

@end

@implementation AddNewEventViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
//    self.subjectField.delegate = self;
//    self.descriptionField.delegate = self;
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


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
        [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setSubjectField:nil];
    [self setDescriptionField:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (IBAction)bookButton:(id)sender {
    GTLCalendarEvent *newEvent = [GTLCalendarEvent new];
    newEvent.summary = self.subjectField.text;
    newEvent.descriptionProperty = self.descriptionField.text;
    
    GTLDateTime *startDate = [GTLDateTime dateTimeWithDate: self.datePicker.date timeZone:[NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime new];
    newEvent.start.dateTime = startDate;
    
    GTLServiceCalendar *service = [GTLServiceCalendar new];
    
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:newEvent
                                                                    calendarId:@"ishatrip@thoughtworks.com"];
    
    
    [service executeQuery:query
                               completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                                   // Callback
                                   if (error == nil) {
                                       GTLCalendarEvent *event = object;
                                   }
                                }];

}
@end
