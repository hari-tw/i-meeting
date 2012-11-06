//
//  MyMeetingViewController.m
//  i-meeting
//
//  Created by Manan on 11/6/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "MyMeetingViewController.h"
#import "GTLCalendar.h"
#import "DateTimeUtility.h"
#import "CalendarCell.h"
#import  "GTLCalendarEventDateTime.h"
#import "RootViewController.h"

@interface MyMeetingViewController ()

@property (nonatomic, strong) GTLServiceCalendar *calendarService;
@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic) BOOL isSignedIn;

@end

@implementation MyMeetingViewController
@synthesize eventsSummaries = _eventsSummaries;
@synthesize calendarService = _calendarService;
@synthesize isSignedIn = _isSignedIn;

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
    [self displayCalendar];
    [super viewDidLoad];
}

- (void)displayCalendar
{
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"mananbh@thoughtworks.com"];
    query.timeMin = [DateTimeUtility dateTimeForYear:2012 month:10 day:24 atHour:0 minute:0 second:0];
    query.timeMax = [DateTimeUtility dateTimeForYear:2012 month:10 day:25 atHour:24 minute:0 second:0];
    [RootViewController.getService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}

- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    GTLCalendarEvents *events = (GTLCalendarEvents *)object;
    self.events = events.items;
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
