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
#import "RootViewController.h"
#import "DateTimeUtility.h"
#import "SignInHandler.h"

@interface AddNewEventViewController ()

@property (nonatomic, strong) SignInHandler *signInHandler;

@end

@implementation AddNewEventViewController

@synthesize signInHandler = _signInHandler;

- (SignInHandler *)signInHandler
{
    if (!_signInHandler) _signInHandler = [SignInHandler new];
    return _signInHandler;
}

- (void)awakeFromNib
{
    [self.signInHandler authorizeUser];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
        cell.detailTextLabel.text = [DateTimeUtility stringFromDate:self.datePicker.date];
    
    if (indexPath.row == 3)
        cell.detailTextLabel.text = [DateTimeUtility stringFromDate:[self.datePicker.date dateByAddingTimeInterval:30 * 60]];
}

- (void)datePicked:(UIDatePicker *)sender
{
    UITableViewCell *startDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITableViewCell *endDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (startDateTimeCell.selected)
        startDateTimeCell.detailTextLabel.text = [DateTimeUtility stringFromDate:self.datePicker.date];
    if (endDateTimeCell.selected)
        endDateTimeCell.detailTextLabel.text = [DateTimeUtility stringFromDate:self.datePicker.date];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.datePicker.date = [DateTimeUtility dateFromString:cell.detailTextLabel.text];
}

- (IBAction)bookButton:(id)sender {
    GTLCalendarEvent *newEvent = [GTLCalendarEvent new];
    
    UITableViewCell *startDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UITableViewCell *endDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *startDateString = startDateTimeCell.detailTextLabel.text;
    NSString *endDateString = endDateTimeCell.detailTextLabel.text;
    
    newEvent.summary = self.subjectField.text;
    newEvent.descriptionProperty = self.descriptionField.text;
    newEvent.location = self.location;
    
    NSDate *sDate = [DateTimeUtility dateFromString:startDateString];
    
    NSDate *eDate = [DateTimeUtility dateFromString:endDateString];

    GTLDateTime *endTime = [GTLDateTime dateTimeWithDate: eDate timeZone: [NSTimeZone systemTimeZone]];
    GTLDateTime *startTime = [GTLDateTime dateTimeWithDate: sDate timeZone: [NSTimeZone systemTimeZone]];

    newEvent.start = [GTLCalendarEventDateTime new];
    newEvent.start.dateTime = startTime;

    newEvent.end = [GTLCalendarEventDateTime new];
    newEvent.end.dateTime = endTime;
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:newEvent
                                                                    calendarId:@"renuahla@thoughtworks.com"];
    
    [self.signInHandler.calendarService executeQuery:query
                                   completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                                       // Callback
                                       if (error == nil) {
                                           GTLCalendarEvent *event = object;
                                       }
                                   }];
    
}

- (void)viewDidUnload {
    [self setSubjectField:nil];
    [self setDescriptionField:nil];
    [super viewDidUnload];
}
@end
