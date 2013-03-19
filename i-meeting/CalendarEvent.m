#import "CalendarEvent.h"

@implementation CalendarEvent
id controller_id = nil;

+ (void)saveEvent:(GTLCalendarEvent *)event withCompletionHandler:(id)completionHandler
{
    NSString *userName = [[SignInHandler instance] userEmail];
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event
                                                                    calendarId:userName];
    
    [[SignInHandler instance].calendarService executeQuery:query
                                         completionHandler:completionHandler];
    
}


- (void)busyFreeQuery:(GTLCalendarEvent *)event withController:(id)controller withMeetingRoom:(NSString *)meetingRoomId withCompletionHandler:(id)completionHandler 
{
    controller_id = controller;
    GTLCalendarFreeBusyRequestItem *requestItem = [GTLCalendarFreeBusyRequestItem object];
    requestItem.identifier = meetingRoomId;
    GTLQueryCalendar *query1 = [GTLQueryCalendar queryForFreebusyQuery];
    query1.items = [NSArray arrayWithObject:requestItem];
    query1.timeMax = event.end.dateTime;
    query1.timeMin = event.start.dateTime;
    query1.fields = @"calendars";
    
    [[SignInHandler instance].calendarService executeQuery:query1 completionHandler:^(GTLServiceTicket *busyFreeTicket, id busyFreeObject, NSError *busyFreeError) {
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
                [CalendarEvent saveEvent:event withCompletionHandler:completionHandler];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] init];
                [alert setTitle:@"Message"];
                [alert setMessage:@"This time slot is already booked. Would you like to book another room?"];
                [alert setDelegate:self];
                [alert addButtonWithTitle:@"Yes"];
                [alert addButtonWithTitle:@"No"];
                [alert show];
            }
            
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        [controller_id performSegueWithIdentifier:@"availableRooms" sender:controller_id];
    }
	else if (buttonIndex == 1)
	{
        NSLog(@"This is a test log for the alert view");

	}
}


@end
