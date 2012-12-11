//
//  NewCalendarViewController.m
//  i-meeting
//
//  Created by Sanchit Bahal on 24/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import  "GTLCalendarEventDateTime.h"
#import "AddNewEventViewController.h"
#import "Foundation/Foundation.h"
#import "SignInHandler.h"
#import "DateTimeUtility.h"



@interface CalendarViewController ()
@property (nonatomic, strong) SignInHandler *signInHandler;
@end

@implementation CalendarViewController
@synthesize signInHandler = _signInHandler;
@synthesize events2;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (SignInHandler *)signInHandler
{
    if (!_signInHandler) _signInHandler = [SignInHandler new];
    return _signInHandler;
}
- (void)awakeFromNib
{
    [self.signInHandler authorizeUser];
 
}

- (void)ForGettingEventsForEachSection
{
    NSMutableArray *todayDateEvents = [NSMutableArray new];
    NSMutableArray *tommorrowDateEvents = [NSMutableArray new];
    
    
    [self savingEventsInArray:tommorrowDateEvents todayDateEvents:todayDateEvents];
    dataArray = [[NSMutableArray alloc] init];
    
    NSArray *firstSectionArray = todayDateEvents;
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstSectionArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    
    NSArray *secondSectionArray = tommorrowDateEvents;
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondSectionArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];
}

- (void)viewDidLoad
{
    [self.signInHandler signInUser:@selector(displayCalendar) withParentController:self];

    [super viewDidLoad];
    [self.spinner startAnimating];
    self.title = self.viewTitle;
    
   
}

- (void)displayCalendar
{
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate new];
   
    NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:self.calendarId];
     NSLog(@"^^^^^ %d ^^^^^^", [components hour]);
    // query.showDeleted= FALSE;
    query.timeMin = [DateTimeUtility dateTimeForYear:[components year] month:[components month] day:[components day] atHour:[components hour] minute:[components minute] second:[components second]];
    query.timeMax = [DateTimeUtility dateTimeForYear:[components year] month:[components month] day:([components day]+1) atHour:23 minute:59 second:59];
    query.timeZone = @"Asia/Calcutta";
    [self.signInHandler.calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}



- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    GTLCalendarEvents *events = (GTLCalendarEvents *)object;
    self.events2 = events.items;
    [self sortingTheEventsAccordingToTime];
    [self ForGettingEventsForEachSection];
    [self.tableView reloadData];
    [self.spinner stopAnimating];

    
}


- (void)sortingTheEventsAccordingToTime
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start.dateTime.dateComponents.year" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"start.dateTime.dateComponents.month" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"start.dateTime.dateComponents.day" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"start.dateTime.dateComponents.hour" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"start.dateTime.dateComponents.minute" ascending:YES];
    self.events2 = [self.events2 sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,sortDescriptor1, sortDescriptor2,sortDescriptor3,sortDescriptor4, nil]];
}


- (void)savingEventsInArray:(NSMutableArray *)tommorrowDateEvents todayDateEvents:(NSMutableArray *)todayDateEvents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
   NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    
    NSLog (@" %%%% %@ %%%%%%", now);
    for (int i=0; i<self.events2.count; i++) {
      
        NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[self.events2[i] valueForKey:@"start"]).dateTime.dateComponents;
  //     NSString *status = [self.events2[i] valueForKey:@"status"];
//        if ([status isEqualToString:@"confirmed"]) {
                  if (dateComps.day == eventStart.day)
            {
                [todayDateEvents addObject:self.events2[i]];
               
            }
            else if ((dateComps.day+1)== eventStart.day){
                [tommorrowDateEvents addObject:self.events2[i]];
            }
        }
}



- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [calendar setTimeZone:timeZone];
   
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];

    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingOneDay:(NSInteger)numberOfDays toDate:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:numberOfDays];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];}
   
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    	    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (NSString *)durationOfMeeting:(NSDateComponents *)eventStart eventEnd:(NSDateComponents *)eventEnd
{
    NSString *durationString;
    int startTimeInMinute = ((eventStart.hour)*60)+eventStart.minute;
    int endTimeInMinute = (eventEnd.hour*60)+eventEnd.minute;
    int duration = endTimeInMinute-startTimeInMinute;
    if (duration < 60) {
        durationString = [NSString stringWithFormat:@"%d minutes", duration];}
    else {
        int hour = duration/60;
        int minutes = duration%60;
        if (minutes == 0) {
            durationString = [NSString stringWithFormat:@"%d hour", hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%d hour %d minutes", hour,minutes];
        }
        
    }
    return durationString;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *now = [NSDate date];
    NSDate *startDate = [self dateAtBeginningOfDayForDate:now];
    NSDate *endDate = [self dateByAddingOneDay:1 toDate:startDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    NSString *dateString1 = [dateFormatter stringFromDate:endDate];
    
    NSMutableArray *myArray = [NSMutableArray array];
    [myArray addObject:dateString];
    [myArray addObject:dateString1];
    
    return ( [myArray objectAtIndex:section]);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString *durationString = @"";
    static NSString *cellIdentifier = @"Cell";
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

     NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    
    NSArray *array = [dictionary objectForKey:@"data"];
   
    id event = [array objectAtIndex:indexPath.row];
  
  NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[event valueForKey:@"start"]).dateTime.dateComponents;
  NSDateComponents *eventEnd = ((GTLCalendarEventDateTime *)[event valueForKey:@"end"]).dateTime.dateComponents;
  NSString *eventStartTime = [NSString stringWithFormat:@"%02d:%02d", eventStart.hour, eventStart.minute];
  NSString *eventEndTime = [NSString stringWithFormat:@"%02d:%02d", eventEnd.hour, eventEnd.minute];

  durationString = [self durationOfMeeting:eventStart eventEnd:eventEnd];
    
        cell.titleLabel.text = [event valueForKey:@"summary"];
        cell.timingsLabel.text = [NSString stringWithFormat:@"%@", eventStartTime];
        cell.durationLabel.text = [NSString stringWithFormat: @"-%@  Duration: %@", eventEndTime, durationString];
    
    NSLog(@"%@", event);
 
return cell;

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addEvent"]) {
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        addNewEventViewController.meetingRoomId = self.calendarId;
        addNewEventViewController.meetingRoomName = self.viewTitle;
    }
   
        }
 



- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCurrentDateLabel:nil];
    [self setCurrentDate:nil];
    [super viewDidUnload];
}
@end

