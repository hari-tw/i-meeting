#import "AddNewEventViewController.h"
#import "GTLCalendarEvent.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLServiceCalendar.h"
#import "GTLQueryCalendar.h"
#import "RootViewController.h"
#import "DateTimeUtility.h"
#import "CalendarViewController.h"
#import "GTLCalendarManager.h"

@implementation AddNewEventViewController

- (void)viewDidLoad
{
    NSDate *minDate = [NSDate date];
    NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*48];
    
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
    [super viewDidLoad];
    
    [self.spinner setHidden:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
        cell.detailTextLabel.text = [DateTimeUtility stringFromDate:[self.datePicker.date dateByAddingTimeInterval:5 * 60]];
    
    if (indexPath.row == 3)
        cell.detailTextLabel.text = [DateTimeUtility stringFromDate:[self.datePicker.date dateByAddingTimeInterval:30 * 60]];
}

- (void)datePicked:(UIDatePicker *)sender
{
    UITableViewCell *startDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITableViewCell *endDateTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (startDateTimeCell.selected){
        startDateTimeCell.detailTextLabel.text = [DateTimeUtility stringFromDate:self.datePicker.date];
        endDateTimeCell.detailTextLabel.text =[DateTimeUtility stringFromDate:[self.datePicker.date dateByAddingTimeInterval:30 * 60]];
    }
    if (endDateTimeCell.selected)
        endDateTimeCell.detailTextLabel.text = [DateTimeUtility stringFromDate:self.datePicker.date];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.datePicker.date = [DateTimeUtility dateFromString:cell.detailTextLabel.text];
    [self.descriptionField resignFirstResponder];
    [self.subjectField resignFirstResponder];
}

- (IBAction)bookButton:(id)sender
{
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
        GTLCalendarEventAttendee *attendee1 = [GTLCalendarEventAttendee new];
        attendee.email = self.meetingRoomId;
        attendee1.email = [[SignInHandler instance] userEmail];
        attendee1.responseStatus = @"accepted";
        newEvent.attendees = [NSArray arrayWithObjects:attendee,attendee1, nil];
        GTLDateTime *endTime = [GTLDateTime dateTimeWithDate: eDate timeZone: [NSTimeZone systemTimeZone]];
        GTLDateTime *startTime = [GTLDateTime dateTimeWithDate: sDate timeZone: [NSTimeZone systemTimeZone]];
        
        newEvent.start = [GTLCalendarEventDateTime new];
        newEvent.start.dateTime = startTime;
        
        newEvent.end = [GTLCalendarEventDateTime new];
        newEvent.end.dateTime = endTime;
        [self busyFreeQuery:newEvent];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:validation delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }    
}

-(void)busyFreeQuery:(GTLCalendarEvent *)event
{
    [self.spinner setHidden:FALSE];
    [self.spinner startAnimating];
    [self.spinner hidesWhenStopped];
    
    GTLCalendarFreeBusyRequestItem *requestItem = [GTLCalendarFreeBusyRequestItem object];
    requestItem.identifier = self.meetingRoomId;
    GTLQueryCalendar *query = [GTLCalendarManager getCalendarQueryWithCalendars:[NSArray arrayWithObject:requestItem] timeMin:event.start.dateTime timeMax:event.end.dateTime];
    
    [[SignInHandler instance].calendarService executeQuery:query completionHandler:^(GTLServiceTicket *busyFreeTicket, id busyFreeObject, NSError *busyFreeError) {
        // Callback
        if (busyFreeError != nil){
            UIAlertView *alertErrorInQuery = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem in executing FreeBusyQuery." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertErrorInQuery show];}

        if (busyFreeError == nil) {
            GTLCalendarFreeBusyResponse *response = busyFreeObject;
            GTLCalendarFreeBusyResponseCalendars *responseCals = response.calendars;
            NSDictionary *props = responseCals.additionalProperties;
            
            if(props == nil)
            {
                [self saveEvent:event];
            }
            else
            {
                [self.spinner stopAnimating];
                [self.spinner setHidden:TRUE];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This time slot is already booked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }];
}

-(void)saveEvent:(GTLCalendarEvent *)event
{
    NSString *userName = [[SignInHandler instance] userEmail];
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event
                                                                    calendarId:userName];
    
    [[SignInHandler instance].calendarService executeQuery:query
                                         completionHandler:^(GTLServiceTicket *ticket, id eventId, NSError *error) {
                                             // Callback
                                             if (error != nil)
                                             {
                                                 UIAlertView *alertErrorInQuery = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem in saving the event in the calander." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                 [alertErrorInQuery show];
                                                 NSLog(@"%@", error.description);
                                             }
                                             if (error == nil) {
                                                 [self.spinner stopAnimating];
                                                 [self.spinner setHidden:TRUE];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }
                                         }];
    
}

-(NSString *)validateEventTitle:(NSString *)title Description:(NSString *)description StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate
{
   NSString *error = @"";
     if([title isEqualToString: @""])
     {
         error = [error stringByAppendingString:@"Enter Title"];
     }
     NSDate *currentTime = [NSDate date];
    if(([startDate compare:currentTime] != NSOrderedDescending) || ([endDate compare:startDate] != NSOrderedDescending) || ([endDate compare:startDate] == NSOrderedSame))
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
