#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "GTLCalendarEventDateTime.h"
#import "AddNewEventViewController.h"
#import "Foundation/Foundation.h"
#import "DateTimeUtility.h"

@interface CalendarViewController ()
@end

@implementation CalendarViewController
@synthesize eventsSummaries;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([self.calendarId length] != 0)
    {
        [self displayCalendar];
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
    self.title = self.viewTitle ? self.viewTitle : @"My Meetings";
    self.calendarId = self.calendarId ? self.calendarId : [SignInHandler instance].userEmail;
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
    
    [[SignInHandler instance].calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
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


- (NSDateComponents *)calculateDateComponents:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCompsofToday= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    return dateCompsofToday;
}

- (void)savingEventsInArray:(NSMutableArray *)tommorrowDateEvents todayDateEvents:(NSMutableArray *)todayDateEvents dayAfterTommorrowDateEvents:(NSMutableArray *)dayAfterTommorrowDateEvents
{
    NSDate *now = [NSDate date];
    NSDate *tommorrow = [now dateByAddingTimeInterval:60*60*24];
    NSDate *dayAfterTommorrow = [tommorrow dateByAddingTimeInterval:60*60*24];
    
    NSDateComponents *dateCompsofToday = [self calculateDateComponents:now];
    NSDateComponents *dateCompsTommorrow = [self calculateDateComponents:tommorrow];
    NSDateComponents *dateCompsdayAfterTommorrow = [self calculateDateComponents:dayAfterTommorrow];
    for (int i=0; i<self.eventsSummaries.count; i++) {
        NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[self.eventsSummaries[i] valueForKey:@"start"]).dateTime.dateComponents;
        
        NSArray *attendees = [eventsSummaries[i] valueForKey:@"attendees"];
        NSString *email = [NSString new];
        NSString *attendeesResponseStatus = [NSString new];
        attendeesResponseStatus = @"declined";
        
        for(int j=0; j<attendees.count; j++){
            
            email = [attendees[j] valueForKey:@"email"];
            
            if ([email isEqualToString:self.calendarId] ){
                attendeesResponseStatus = [attendees[j] valueForKey:@"responseStatus"];
            
           if (![attendeesResponseStatus isEqualToString:@"declined"]){
            if (dateCompsofToday.day == eventStart.day)
            {
                [todayDateEvents addObject:self.eventsSummaries[i]];
            }
            else if ((dateCompsTommorrow.day)== eventStart.day)
            {
                [tommorrowDateEvents addObject:self.eventsSummaries[i]];
            }
            else if ((dateCompsdayAfterTommorrow.day)== eventStart.day)
            {
                [dayAfterTommorrowDateEvents addObject:self.eventsSummaries[i]];
            }
        }
            break;
        
            }
        }
    }
}


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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = [calendar dateFromComponents:eventStart];
    NSDate *endDate = [calendar dateFromComponents:eventEnd];
    NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
    int durationInMinute = (int) duration / 60;
    if (durationInMinute < 60) {
        durationString = [NSString stringWithFormat:@"%d minutes", durationInMinute];}
    else {
        int hour = durationInMinute/60;
        int minutes = durationInMinute%60;
        if (minutes == 0) {
            durationString = [NSString stringWithFormat:@"%d hour", hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%d hour %d minutes", hour,minutes];
        }
        
    }
    return durationString;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate *now = [NSDate date];
    
    NSDate *tommorrow = [now dateByAddingTimeInterval:60*60*24];
    NSDate *dayAfterTommorrow = [tommorrow dateByAddingTimeInterval:60*60*24];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd MMM yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSString *dateString1 = [dateFormatter stringFromDate:tommorrow];
    NSString *dateString2 = [dateFormatter stringFromDate:dayAfterTommorrow];
    
    NSMutableArray *myArray = [NSMutableArray arrayWithObjects:dateString , dateString1, dateString2, nil ];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 320, 23);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"System Bold" size:20.0];
    label.text = [myArray objectAtIndex:section];
    label.backgroundColor = [UIColor lightGrayColor];
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,96 )];
    [view addSubview:label];
    
    
    return (view);
    
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
    cell.timingsLabel.text = [NSString stringWithFormat:@"%@ - %@", eventStartTime, eventEndTime];
    NSArray *organiser = [event valueForKey:@"organizer"];
    cell.organizerLabel.text = [@"Organizer: " stringByAppendingString:[organiser valueForKey:@"displayName"]];
    
    
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

- (void)createAddEventButtonDynamically
{
    UIBarButtonItem * addEventButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addEventButton;
}

- (IBAction)addEvent:(id)sender
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

