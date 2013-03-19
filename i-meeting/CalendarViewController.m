#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "GTLCalendarEventDateTime.h"
#import "AddNewEventViewController.h"
#import "DetailedViewController.h"
#import "Foundation/Foundation.h"
#import "DateTimeUtility.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@interface CalendarViewController ()
@property (strong, nonatomic) CalendarEvent *calendarEvent;

@end


@implementation CalendarViewController
@synthesize calendarEvent = _calendarEvent;

- (CalendarEvent *) calendarEvent {
    if(_calendarEvent == nil) _calendarEvent = [[CalendarEvent alloc] init];
    return _calendarEvent;
}
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
    [self displayCalendar];
}

- (void)showNoEventsLabel
{
    [self.tableView reloadData];
    [label setHidden:FALSE];
    label.textColor = [UIColor redColor];
    label.frame = CGRectMake(5, 10, 320, 100);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = @"No scheduled meeting for next 48 hours.";
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0];
    [self.view addSubview:label];
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
    if([dataArray count] == 0) {
        [self showNoEventsLabel];
    } else {
        [label setHidden:TRUE];
    }
}

- (void)populateTableViewWithData:(NSMutableArray *)calendarEvents andSectionHeader:(NSString *)sectionHeader
{
    if (calendarEvents.count <= 0) return;
    
    [dataArray addObject:[NSDictionary dictionaryWithObject:calendarEvents forKey:@"data"]];
    [sectionHeaders addObject:sectionHeader];
}

- (void)displayCalendar
{
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate new];
    NSDate *endDate = [now dateByAddingTimeInterval:60*60*48];
    
    NSDateComponents* startDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    NSDateComponents* endDateComponents = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:endDate];

    NSString *gmailId = self.calendarId ? self.calendarId : [SignInHandler instance].userEmail;
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:gmailId];

    
    query.timeMin = [DateTimeUtility dateTimeForYear:[startDateComponents year] month:[startDateComponents month] day:[startDateComponents day] atHour:[startDateComponents hour] minute:[startDateComponents minute] second:[startDateComponents second]];
    query.timeMax = [DateTimeUtility dateTimeForYear:[endDateComponents year] month:[endDateComponents month] day:[endDateComponents day] atHour:[endDateComponents hour] minute:[endDateComponents minute] second:[endDateComponents second]];
    query.timeZone = @"Asia/Calcutta";
    query.fields = @"description,items(attendees(displayName,email,organizer,resource,responseStatus),created,creator,description,end,endTimeUnspecified,htmlLink,id,location,organizer,originalStartTime,start,status,summary),kind,nextPageToken,summary,timeZone";
    query.singleEvents = TRUE;
    query.orderBy = @"startTime";
    
    [[SignInHandler instance].calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}

- (void)prepareQuickBookActionSheet:(double)interval
{
    NSString * quickBookText = @"This room is available. Quick Book?";
    NSMutableArray * quickBookOptions = [[NSMutableArray alloc] initWithCapacity:2];
    if (interval >= 1800) {
        [quickBookOptions addObject:@"Half Hour"];
    }
    
    if (interval > 3600) {
        [quickBookOptions addObject:@"One Hour"];
    }
    if (quickBookOptions.count > 0) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:quickBookText delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles: nil];
        for (NSString * title in quickBookOptions) {
            [actionSheet addButtonWithTitle:title];
        }
        
        [actionSheet showInView:self.view];
    }
}

- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    double interval;
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.spinner stopAnimating];
        [self.spinner setHidden:YES];
        NSLog(@"%@", error);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    events = (GTLCalendarEvents *)object;
    self.eventsSummaries = events.items;
    
    if(self.eventsSummaries.count == 0)
    {
        interval = 48*3600;
        [dataArray removeAllObjects];
        [self showNoEventsLabel];
    }
    else
    {
        [self getEventsForEachSection];
        NSDate *eventStart = ((GTLCalendarEventDateTime *)[[self.eventsSummaries objectAtIndex:0] valueForKey:@"start"]).dateTime.date;
        interval = [eventStart timeIntervalSinceNow];
    }
    
    [self.spinner stopAnimating];
    [self.tableView reloadData];
    
    if (self.room) [self prepareQuickBookActionSheet:interval];
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
        NSString *gmailId = self.calendarId ? self.calendarId : [SignInHandler instance].userEmail;
        if ([emailOfOrganiser isEqualToString:gmailId]) {
            [self saveEventsInArray:i eventStart:eventStart];
            
            continue;
        }
        
        for(int j=0; j<attendees.count; j++){
            
            email = [attendees[j] valueForKey:@"email"];
            
            if ([email isEqualToString:gmailId] ){
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
    cell.delegate = self;
    [cell.deleteBtn setHidden:TRUE];
  
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    
    NSArray *array = [dictionary objectForKey:@"data"];
    
    event = [array objectAtIndex:indexPath.row];
    
    NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[event valueForKey:@"start"]).dateTime.dateComponents;
    NSDateComponents *eventEnd = ((GTLCalendarEventDateTime *)[event valueForKey:@"end"]).dateTime.dateComponents;
    NSString *eventStartTime = [NSString stringWithFormat:@"%02d:%02d", eventStart.hour, eventStart.minute];
    NSString *eventEndTime = [NSString stringWithFormat:@"%02d:%02d", eventEnd.hour, eventEnd.minute];
    cell.eventID = [event valueForKey:@"identifier"];
    cell.titleLabel.text = [event valueForKey:@"summary"];
    cell.timingsLabel.text = [NSString stringWithFormat:@"%@ - %@", eventStartTime, eventEndTime];
    NSArray *organiser = [event valueForKey:@"organizer"];
    cell.organizerLabel.text = [@"Organizer: " stringByAppendingString:[organiser valueForKey:@"displayName"]];
    NSString *emailOfOrganiser = [organiser valueForKey:@"email"];
    NSString *gmailId = self.calendarId ? self.calendarId : [SignInHandler instance].userEmail;
    if ([emailOfOrganiser isEqualToString:gmailId]) {
        [cell.deleteBtn.layer setCornerRadius:5.0f];
        [cell.deleteBtn setHidden:FALSE];
    }

    NSLog(@"%@", event);
    
    return cell;
}

-(void)reloadTableView: (CalendarCell *) sender
{
    [self displayCalendar];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return indexPath;
 }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addEvent"]) {
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        addNewEventViewController.meetingRoomId = self.calendarId;
        addNewEventViewController.meetingRoomName = self.viewTitle;
        addNewEventViewController.meetingRoomLocation = events.summary;
    }
    if ([segue.identifier isEqualToString:@"detailedView"]) {
        DetailedViewController *detailedViewController = segue.destinationViewController;
        detailedViewController.event = event;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        return;
    GTLCalendarEvent *newEvent = [GTLCalendarEvent new];
    int interval = buttonIndex * 1800;
    newEvent.summary = @"Quick booking this room";
    newEvent.descriptionProperty = @"Booked using my iPhone";
    newEvent.location = self.room;
    GTLCalendarEventAttendee *attendee = [GTLCalendarEventAttendee new];
    GTLCalendarEventAttendee *attendee1 = [GTLCalendarEventAttendee new];
    attendee.email = self.calendarId;
    attendee1.email = [[SignInHandler instance] userEmail];
    attendee1.responseStatus = @"accepted";
    newEvent.attendees = [NSArray arrayWithObjects:attendee,attendee1, nil];
    GTLDateTime *endTime = [GTLDateTime dateTimeWithDate: [NSDate dateWithTimeIntervalSinceNow:interval] timeZone: [NSTimeZone systemTimeZone]];
    GTLDateTime *startTime = [GTLDateTime dateTimeWithDate: [NSDate date] timeZone: [NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime new];
    newEvent.start.dateTime = startTime;
    
    newEvent.end = [GTLCalendarEventDateTime new];
    newEvent.end.dateTime = endTime;
    [self.spinner setHidden:FALSE];
    [self.spinner startAnimating];
    [self.spinner hidesWhenStopped];
    [self.calendarEvent busyFreeQuery:newEvent withController:self withMeetingRoom:self.calendarId withCompletionHandler:^(GTLServiceTicket *ticket, id eventId, NSError *error) {
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
            [self displayCalendar];
            [self.tableView reloadData];
        }
    }];

}

@end

