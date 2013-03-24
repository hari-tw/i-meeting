#import "CalendarEvent.h"
#import "AvailableRoomsViewController.h"
#import "CalendarViewController.h"
#import "AppDelegate.h"

@interface AvailableRoomsViewController ()

@end

@implementation AvailableRoomsViewController
@synthesize newEventToBeCreated = _newEventToBeCreated;
@synthesize freeRooms = _freeRooms;
@synthesize spinner;
@synthesize queryCount;
@synthesize iterator;
@synthesize freeRoomMessage;

-(GTLCalendarEvent *)newEventToBeCreated
{
    return _newEventToBeCreated;
}

-(NSMutableArray *)freeRooms
{
    if(!_freeRooms)
    {
        _freeRooms = [[NSMutableArray alloc] init];
    }
    return _freeRooms;
}
- (void)viewDidLoad
{
    self.queryCount = 0;
    self.iterator = 0;
    [self getAllRooms];
    [super viewDidLoad];
    [self.spinner startAnimating];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.freeRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = [[self.freeRooms objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newEventToBeCreated.location = [[self.freeRooms objectAtIndex:indexPath.row] objectForKey:@"name"];
    GTLCalendarEventAttendee *attendee = [GTLCalendarEventAttendee new];
    GTLCalendarEventAttendee *attendee1 = [GTLCalendarEventAttendee new];
    attendee.email = [[self.freeRooms objectAtIndex:indexPath.row] objectForKey:@"id"];
    attendee1.email = [[SignInHandler instance] userEmail];
    attendee1.responseStatus = @"accepted";
    self.newEventToBeCreated.attendees = [NSArray arrayWithObjects:attendee,attendee1, nil];
    [CalendarEvent saveEvent:self.newEventToBeCreated withCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        // Callback
        if (error != nil)
            NSLog(@"%@", error.description);
        if (error == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Event saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

-(void)getAllRooms
{
    NSString *key = [self keyForTheMeetingRoom];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rooms" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
   
    if (myData) {
        NSLog(@"Data is there");
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:myData options:kNilOptions error:nil];
        NSArray *rooms = [dictionary objectForKey:key];
        queryCount = rooms.count;
        for (NSDictionary *room in rooms)
        {
            NSString *roomId = [room objectForKey:@"id"];
            NSString *roomName = [room objectForKey:@"name"];
            [self freeBusyQuery:roomId roomName:roomName];
        }
    }
}

-(NSString *)keyForTheMeetingRoom
{
    NSArray *listItems = [self.meetingRoomLocation componentsSeparatedByString:@"Capacity"];
    NSRange range = [listItems[0] rangeOfString:@"-" options:NSBackwardsSearch];
    NSString *temp = [listItems[0] substringToIndex:range.location-1];
    range = [temp rangeOfString:@"-" options:NSBackwardsSearch];
    temp = [temp substringToIndex:range.location-1];
    temp =  [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return temp;
}

-(void)freeBusyQuery:(NSString *)meetingRoomId roomName:(NSString *)roomName
{
    self.newEventToBeCreated.location = roomName;
    GTLCalendarFreeBusyRequestItem *requestItem = [GTLCalendarFreeBusyRequestItem object];
    requestItem.identifier = meetingRoomId;
    GTLQueryCalendar *query1 = [GTLQueryCalendar queryForFreebusyQuery];
    query1.items = [NSArray arrayWithObject:requestItem];
    query1.timeMax = self.newEventToBeCreated.end.dateTime;
    query1.timeMin = self.newEventToBeCreated.start.dateTime;
    query1.fields = @"calendars";
    
    [[SignInHandler instance].calendarService executeQuery:query1 completionHandler:^(GTLServiceTicket *busyFreeTicket, id busyFreeObject, NSError *busyFreeError) {
        iterator += 1;
        if (busyFreeError != nil){
            NSLog(@"%@",busyFreeError);
        }
        
        if (busyFreeError == nil) {
            GTLCalendarFreeBusyResponse *response = busyFreeObject;
            GTLCalendarFreeBusyResponseCalendars *responseCals = response.calendars;
            NSDictionary *props = responseCals.additionalProperties;
            
            if(props == nil)
            {
                NSDictionary *availableRoom = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:meetingRoomId,roomName, nil] forKeys:[NSArray arrayWithObjects:@"id",@"name", nil]];
                [self.freeRooms addObject:availableRoom];
                self.freeRoomMessage.text = @"Please select a room";
                [self.tableView reloadData];
                NSLog(@"Hello");
            }
        }
        if (iterator == queryCount ) {
            [self.spinner stopAnimating];
            [self.spinner setHidden:TRUE];
            [self.spinner hidesWhenStopped];
            if (self.freeRooms.count == 0)
                self.freeRoomMessage.text = @"No room is available for this time slot";
        }
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UINavigationController *navController = self.navigationController;
    UITabBarController *tabController = self.tabBarController;
	if (buttonIndex == 0)
	{
        NSLog(@"%@", [navController viewControllers]);
        [navController popToRootViewControllerAnimated:NO];
        [tabController setSelectedIndex:1];
    }
}

@end
