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
#import "DateTimeUtility.h"

@interface CalendarViewController ()
@end

@implementation CalendarViewController
@synthesize eventsSummaries;

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
//    if([self.calendarId length] != 0)
//    {
//        [self.signInHandler signInUser:@selector(displayCalendar) withParentController:self];
//
//    }
 
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([self.calendarId length] != 0)
    {
        [self.signInHandler signInUser:@selector(displayCalendar) withParentController:self];
        
    }
    
}

- (void)ForGettingEventsForEachSection
{
    NSMutableArray *todayDateEvents = [NSMutableArray new];
    NSMutableArray *tommorrowDateEvents = [NSMutableArray new];
    NSMutableArray *dayAfterTommorrowDateEvents = [NSMutableArray new];
    
    
    [self savingEventsInArray:tommorrowDateEvents todayDateEvents:todayDateEvents dayAfterTommorrowDateEvents:dayAfterTommorrowDateEvents];
    dataArray = [[NSMutableArray alloc] init];
    
    if(todayDateEvents.count > 0){
        NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:todayDateEvents forKey:@"data"];
        [dataArray addObject:firstItemsArrayDict];
    }
    
    if(tommorrowDateEvents.count > 0){
        NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:tommorrowDateEvents forKey:@"data"];
        [dataArray addObject:secondItemsArrayDict];
    }
    
    if(dayAfterTommorrowDateEvents.count > 0){
        NSDictionary *thirdItemsArrayDict = [NSDictionary dictionaryWithObject:dayAfterTommorrowDateEvents forKey:@"data"];
        [dataArray addObject:thirdItemsArrayDict];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.spinner startAnimating];
    self.title = self.viewTitle;
     [self.spinner hidesWhenStopped];
}

- (void)displayCalendar
{
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate new];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*48];
    
    
    NSDateComponents* startDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    NSDateComponents* endDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:endDate];
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:self.calendarId];
    
    
    query.timeMin = [DateTimeUtility dateTimeForYear:[startDateComponents year] month:[startDateComponents month] day:[startDateComponents day] atHour:[startDateComponents hour] minute:[startDateComponents minute] second:[startDateComponents second]];
    query.timeMax = [DateTimeUtility dateTimeForYear:[endDateComponents year] month:[endDateComponents month] day:[endDateComponents day] atHour:[endDateComponents hour] minute:[endDateComponents minute] second:[endDateComponents second]];
    query.timeZone = @"Asia/Calcutta";
    query.singleEvents = TRUE;
    query.orderBy = @"startTime";
    
    [self.signInHandler.calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}



- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    GTLCalendarEvents *events = (GTLCalendarEvents *)object;
    self.eventsSummaries = events.items;
    [self ForGettingEventsForEachSection];
    [self.spinner stopAnimating];
  
    [self.tableView reloadData];
   
    
}


- (void)savingEventsInArray:(NSMutableArray *)tommorrowDateEvents todayDateEvents:(NSMutableArray *)todayDateEvents dayAfterTommorrowDateEvents:(NSMutableArray *)dayAfterTommorrowDateEvents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *tommorrow = [self dateByAddingOneDay:1 toDate:now];
    NSDate *dayAfterTommorrow = [self dateByAddingOneDay:1 toDate:tommorrow];
    
    NSDateComponents *dateCompsofToday= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    NSDateComponents *dateCompsTommorrow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:tommorrow];
    NSDateComponents *dateCompsdayAfterTommorrow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:dayAfterTommorrow];
    
    for (int i=0; i<self.eventsSummaries.count; i++) {
        NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[self.eventsSummaries[i] valueForKey:@"start"]).dateTime.dateComponents;
        
        NSArray *attendees = [eventsSummaries[i] valueForKey:@"attendees"];
        NSString *email = [NSString new];
        NSString *attendeesResponseStatus = [NSString new];
        
        for(int i=0; i<attendees.count; i++){
        attendeesResponseStatus = [attendees[i] valueForKey:@"responseStatus"];
            email = [attendees[i] valueForKey:@"email"];
          
            if ([email isEqualToString:self.calendarId] && [attendeesResponseStatus isEqualToString:@"accepted"]){
               
                attendeesResponseStatus = @"accepted";
                 break;
            }
             attendeesResponseStatus = @"declined";
        }
        
    if ([attendeesResponseStatus isEqualToString:@"accepted"]){

        if (dateCompsofToday.day == eventStart.day)
        {
            [todayDateEvents addObject:self.eventsSummaries[i]];
            
        }
        else if ((dateCompsTommorrow.day)== eventStart.day){
            [tommorrowDateEvents addObject:self.eventsSummaries[i]];
        }
        else if ((dateCompsdayAfterTommorrow.day)== eventStart.day){
            [dayAfterTommorrowDateEvents addObject:self.eventsSummaries[i]];
        }
       } 
    }
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
  
    NSDate *endDate = [self dateByAddingOneDay:1 toDate:now];
    NSDate *dayAfterTommorrow = [self dateByAddingOneDay:2 toDate:now];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSString *dateString1 = [dateFormatter stringFromDate:endDate];
    NSString *dateString2 = [dateFormatter stringFromDate:dayAfterTommorrow];
    
    NSMutableArray *myArray = [NSMutableArray array];
    [myArray addObject:dateString];
    [myArray addObject:dateString1];
    [myArray addObject:dateString2];
    
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

-(void)createAddEventButtonDynamically
{
    UIBarButtonItem * addEventButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addEventButton;
}

-(IBAction)addEvent:(id)sender
{
    [self performSegueWithIdentifier:@"addEvent" sender:self];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCurrentDateLabel:nil];
    [self setCurrentDate:nil];
    [super viewDidUnload];
}
@end

