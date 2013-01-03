#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "GTLCalendarEventDateTime.h"
#import "AddNewEventViewController.h"
#import "Foundation/Foundation.h"
#import "DateTimeUtility.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface CalendarViewController ()
@end

@implementation CalendarViewController

@synthesize eventsSummaries;

- (void)viewDidLoad
{
    [super viewDidLoad];
    label =  [[UILabel alloc] init];
    [self.spinner startAnimating];
    self.title = self.viewTitle ? self.viewTitle : @"My Meetings";
    [self.spinner hidesWhenStopped];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(self.calendarId == nil) {
        self.calendarId = [SignInHandler instance].userEmail;
    }
    
    if([self.calendarId length] != 0)
    {
        [self displayCalendar];
    }
}

- (void)getEventsForEachSection
{
    eventsForToday = [NSMutableArray new];
    eventsForTomorrow = [NSMutableArray new];
    eventsForDayAfterTomorrow = [NSMutableArray new];
    
    [self populateEventsForTheNext48Hours];
    dataArray = [NSMutableArray new];
    sectionHeaders = [NSMutableArray new];
    
    NSDate *now = [NSDate date];
    NSDate *tomorrow = [now dateByAddingTimeInterval:60*60*24];
    NSDate *dayAfterTomorrow = [tomorrow dateByAddingTimeInterval:60*60*24];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd MMM yyyy"];
    
    [self populateTableViewWithData:eventsForToday andSectionHeader:[dateFormatter stringFromDate:now]];
    [self populateTableViewWithData:eventsForTomorrow andSectionHeader:[dateFormatter stringFromDate:tomorrow]];
    [self populateTableViewWithData:eventsForDayAfterTomorrow andSectionHeader:[dateFormatter stringFromDate:dayAfterTomorrow]];
}

- (void)populateTableViewWithData:(NSMutableArray *)events andSectionHeader:(NSString *)sectionHeader
{
    if (events.count <= 0) return;
    
    [dataArray addObject:[NSDictionary dictionaryWithObject:events forKey:@"data"]];
    [sectionHeaders addObject:sectionHeader];
}

- (void)displayCalendar
{
    dataArray = nil;
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate new];
    NSDate *endDate = [now dateByAddingTimeInterval:60*60*48];
    
    NSDateComponents* startDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    NSDateComponents* endDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:endDate];
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:self.calendarId];
    
    query.timeMin = [DateTimeUtility dateTimeForYear:[startDateComponents year] month:[startDateComponents month] day:[startDateComponents day] atHour:[startDateComponents hour] minute:[startDateComponents minute] second:[startDateComponents second]];
    query.timeMax = [DateTimeUtility dateTimeForYear:[endDateComponents year] month:[endDateComponents month] day:[endDateComponents day] atHour:[endDateComponents hour] minute:[endDateComponents minute] second:[endDateComponents second]];
    query.timeZone = @"Asia/Calcutta";
    query.fields = @"description,items(attendees(email,responseStatus),created,creator,description,end,endTimeUnspecified,htmlLink,id,location,organizer,originalStartTime,start,status,summary),kind,nextPageToken,summary,timeZone";
    query.singleEvents = TRUE;
    query.orderBy = @"startTime";
    
    [[SignInHandler instance].calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}

- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.spinner stopAnimating];
        [self.spinner setHidden:YES];
        NSLog(@"%@", error);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        GTLCalendarEvents *events = (GTLCalendarEvents *)object;
        self.eventsSummaries = events.items;
       
        if(self.eventsSummaries.count == 0){
            [label setHidden:FALSE];
            label.textColor = [UIColor redColor];
            label.frame = CGRectMake(5, 10, 320, 100);
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.text = @"No scheduled meeting for next 48 hours.";
            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0];
            [self.view addSubview:label];
            
        }else
        {
            [label setHidden:TRUE];
            [self getEventsForEachSection];
        }
        [self.spinner stopAnimating];
    }
    [self.tableView reloadData];
}

- (NSDateComponents *)calculateDateComponents:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCompsofToday= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit fromDate:date];
    return dateCompsofToday;
}

- (void)saveEventsInArray:(int)i eventStart:(NSDateComponents *)eventStart
{
    NSDate *now = [NSDate date];
    NSDate *tommorrow = [now dateByAddingTimeInterval:60*60*24];
    
    NSDate *dayAfterTommorrow = [tommorrow dateByAddingTimeInterval:60*60*24];
    
    NSDateComponents *dateCompsofToday = [self calculateDateComponents:now];
    NSDateComponents *dateCompsTommorrow = [self calculateDateComponents:tommorrow];
    NSDateComponents *dateCompsdayAfterTommorrow = [self calculateDateComponents:dayAfterTommorrow];
    
    if (dateCompsofToday.day == eventStart.day)
    {
        [eventsForToday addObject:self.eventsSummaries[i]];
    }
    else if ((dateCompsTommorrow.day)== eventStart.day)
    {
        [eventsForTomorrow addObject:self.eventsSummaries[i]];
    }
    else if ((dateCompsdayAfterTommorrow.day)== eventStart.day)
    {
        [eventsForDayAfterTomorrow addObject:self.eventsSummaries[i]];
    }
}

- (void)populateEventsForTheNext48Hours
{
    for (int i=0; i<self.eventsSummaries.count; i++) {
        
        NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[self.eventsSummaries[i] valueForKey:@"start"]).dateTime.dateComponents;
        
        NSArray *attendees = [eventsSummaries[i] valueForKey:@"attendees"];
        NSString *email = [NSString new];
        NSString *attendeesResponseStatus = [NSString new];
        attendeesResponseStatus = @"declined";
        
        NSArray *organiser = [eventsSummaries[i] valueForKey:@"organizer"];
        NSString *emailOfOrganiser = [organiser valueForKey:@"email"];
        if ([emailOfOrganiser isEqualToString:self.calendarId]) {
            [self saveEventsInArray:i eventStart:eventStart];
            
            continue;
        }
        
        for(int j=0; j<attendees.count; j++){
            
            email = [attendees[j] valueForKey:@"email"];
            
            if ([email isEqualToString:self.calendarId] ){
                attendeesResponseStatus = [attendees[j] valueForKey:@"responseStatus"];
                
                if (![attendeesResponseStatus isEqualToString:@"declined"]){
                    [self saveEventsInArray:i eventStart:eventStart];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] init];
    header.frame = CGRectMake(0, 0, 320, 23);
    header.textColor = [UIColor blackColor];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont boldSystemFontOfSize:18.0];
    header.text = [sectionHeaders objectAtIndex:section];
    header.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,96 )];
    [view addSubview:header];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    
    NSArray *array = [dictionary objectForKey:@"data"];
    
    id event = [array objectAtIndex:indexPath.row];
    
    NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[event valueForKey:@"start"]).dateTime.dateComponents;
    NSDateComponents *eventEnd = ((GTLCalendarEventDateTime *)[event valueForKey:@"end"]).dateTime.dateComponents;
    NSString *eventStartTime = [NSString stringWithFormat:@"%02d:%02d", eventStart.hour, eventStart.minute];
    NSString *eventEndTime = [NSString stringWithFormat:@"%02d:%02d", eventEnd.hour, eventEnd.minute];
    
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

- (void)addEvent:(id)sender
{
    [self performSegueWithIdentifier:@"addEvent" sender:self];
}

- (IBAction)signOut:(id)sender {
    [[SignInHandler instance] signOut];
    [self performSegueWithIdentifier:@"signOut" sender:self];
}

@end

