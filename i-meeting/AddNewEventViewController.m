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

@interface AddNewEventViewController ()

@end

@implementation AddNewEventViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setSubjectField:nil];
    [self setDescriptionField:nil];
    [self setDatePicker:nil];
    [self setCalendarView:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
    else
        cell.textLabel.text = self.datePicker.date.description;
}

- (void)datePicked:(UIDatePicker *)sender
{
    UITableViewCell *startDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITableViewCell *endDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (startDateTimeCell.selected)
        startDateTimeCell.textLabel.text = self.datePicker.date.description;
    if (endDateTimeCell.selected)
        endDateTimeCell.textLabel.text = self.datePicker.date.description;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSLog(@"%@", [dateFormatter dateFromString:cell.textLabel.text]);
    
    self.datePicker.date = [dateFormatter dateFromString:cell.textLabel.text];
}

- (IBAction)bookButton:(id)sender {
    GTLCalendarEvent *newEvent = [GTLCalendarEvent new];
    
    newEvent.summary = self.subjectField.text;
    newEvent.descriptionProperty = self.descriptionField.text;
    
    GTLDateTime *startDate = [GTLDateTime dateTimeWithDate: self.datePicker.date timeZone:[NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime new];
    newEvent.start.dateTime = startDate;
    
    newEvent.end = [GTLCalendarEventDateTime new];
    newEvent.end.dateTime = startDate;
    
    
    GTLServiceCalendar *service = [RootViewController getService];
    
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:newEvent
                                                                    calendarId:@"tejinds@thoughtworks.com"];
    
    
    [service executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            // Callback
            if (error == nil) {
                GTLCalendarEvent *event = object;
            }
        }];
    
}

@end
