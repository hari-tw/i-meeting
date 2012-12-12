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
#import "CalendarViewController.h"

@interface AddNewEventViewController ()

@end

@implementation AddNewEventViewController

- (SignInHandler *)signInHandler
{
    if (!_signInHandler) _signInHandler = [SignInHandler new];
    return _signInHandler;
}

- (void)viewDidLoad
{
    NSDate *minDate = [NSDate date];
    NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*48];
    
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
    [super viewDidLoad];
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
    
  
    
    UITableViewCell *startDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UITableViewCell *endDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *startDateString = startDateTimeCell.detailTextLabel.text;
    NSString *endDateString = endDateTimeCell.detailTextLabel.text;
       
    NSDate *sDate = [DateTimeUtility dateFromString:startDateString];
    
    NSDate *eDate = [DateTimeUtility dateFromString:endDateString];
    NSString *validation = @"";
    
    validation =[self validateEventTitle:self.subjectField.text Description:self.descriptionField.text StartDate:sDate EndDate:eDate];
 
    if([validation isEqualToString:@""])
    {
    
      GTLCalendarEvent *newEvent = [GTLCalendarEvent new];
    
    newEvent.summary = self.subjectField.text;
    newEvent.descriptionProperty = self.descriptionField.text;
    newEvent.location = self.meetingRoomName;
    GTLCalendarEventAttendee *attendee = [GTLCalendarEventAttendee new];
    attendee.email = self.meetingRoomId;
    newEvent.attendees = [NSArray arrayWithObject:attendee];

    GTLDateTime *endTime = [GTLDateTime dateTimeWithDate: eDate timeZone: [NSTimeZone systemTimeZone]];
    GTLDateTime *startTime = [GTLDateTime dateTimeWithDate: sDate timeZone: [NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime new];
    newEvent.start.dateTime = startTime;
    
    newEvent.end = [GTLCalendarEventDateTime new];
    newEvent.end.dateTime = endTime;
        NSString *userName = [self.signInHandler userEmail];
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:newEvent
                                                                    calendarId:userName];
    
    [self.signInHandler.calendarService executeQuery:query
                                   completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                                       // Callback
                                       if (error != nil)
                                           NSLog(@"%@", error.description);
                                       if (error == nil) {
                                          // GTLCalendarEvent *event = object;
                                           [self performSegueWithIdentifier:@"NewEventCreated" sender:self];

                                           
//                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Event Saved Successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                                           [alert show];
                                       }
                                   }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid" message:validation delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewEventCreated"]) {
        CalendarViewController *calendarViewController = segue.destinationViewController;
        
        calendarViewController.viewTitle = self.meetingRoomName;
        calendarViewController.calendarId = self.meetingRoomId;
        [calendarViewController.signInHandler signInUser:@selector(displayCalendar:) withCalendarId:calendarViewController.calendarId withParentController:calendarViewController];
        NSString *dateString;
        dateString = [self dateToString];
        calendarViewController.currentDate = [NSString stringWithFormat:@"%@",dateString];
        
    }
}

- (NSString *)dateToString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    NSDate *date1 = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date1];
    return dateString;
}



-(NSString *)validateEventTitle:(NSString *)title Description:(NSString *)description StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate
{
   NSString *error = @"";
     if([title isEqualToString: @""] && [description isEqualToString: @""])
     {
         error = [error stringByAppendingString:@"Enter Title/Description."];
     }
     NSDate *currentTime = [NSDate date];
    if(([startDate compare:currentTime] != NSOrderedDescending)&&([endDate compare:startDate] != NSOrderedDescending)&&([endDate compare:startDate] == NSOrderedSame))
    {
        error = [error stringByAppendingString:@"Invalid event time."];
    }
    return error;
}

- (void)viewDidUnload {
    [self setSubjectField:nil];
    [self setDescriptionField:nil];
    [super viewDidUnload];
}
@end
