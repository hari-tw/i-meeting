//
//  CalendarEvent.m
//  i-meeting
//
//  Created by Anuj Jamwal on 07/02/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "CalendarEvent.h"

@implementation CalendarEvent

+ (void)saveEvent:(GTLCalendarEvent *)event withCompletionHandler:(id)completionHandler
{
    NSString *userName = [[SignInHandler instance] userEmail];
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event
                                                                    calendarId:userName];
    
    [[SignInHandler instance].calendarService executeQuery:query
                                         completionHandler:completionHandler];
    
}


+ (void)busyFreeQuery:(GTLCalendarEvent *)event withMeetingRoom:(NSString *)meetingRoomId withCompletionHandler:(id)completionHandler
{
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This time slot is already booked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }];
}


@end
