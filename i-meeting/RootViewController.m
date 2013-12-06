#import "RootViewController.h"
#import "CalendarViewController.h"
#import "ESTBeaconManager.h"
#import "Rooms.h"

@interface RootViewController ()   <ESTBeaconManagerDelegate> {
    NSMutableArray *roomsNearMe;
    Rooms *rooms;
}

@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic, strong) NSArray *eventsSummariesForTomorrow;
@property (nonatomic) BOOL isSignedIn;
@property (nonatomic) NSString *calendarId;
@property (nonatomic, strong) NSString *meetingRoomName;

@end

@implementation RootViewController

@synthesize eventsSummaries = _eventsSummaries;
@synthesize eventsSummariesForTomorrow = _eventsSummariesForTomorrow;
@synthesize isSignedIn = _isSignedIn;
@synthesize calendarId = _calendarUrl;
@synthesize meetingRoomName = _meetingRoomName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupEstimote];
    roomsNearMe = [[NSMutableArray alloc]init];
    rooms = [[Rooms alloc]init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.viewTitle = self.meetingRoomName;
        calendarViewController.room = self.meetingRoomName;
        calendarViewController.calendarId = self.calendarId;
        [calendarViewController createAddEventButtonDynamically];
    }
}

- (IBAction)signOut:(id)sender {
    [[SignInHandler instance] signOut];
    [self performSegueWithIdentifier:@"signOut" sender:self];
}

- (void)setupEstimote {
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;

    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initRegionWithIdentifier:@"TWI - Bangalore Rooms"];
    [self.beaconManager startRangingBeaconsInRegion:region];
}


- (void)beaconManager:(ESTBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ESTBeaconRegion *)region {
//    NSLog(@"beacons count = %lu", (unsigned long) [beacons count]);

    NSMutableArray *roomBeacons = [[NSMutableArray alloc]init];
    for (ESTBeacon *cBeacon in beacons) {
//        NSLog(@"beacon : %@", cBeacon);
//        NSLog(@"beacons major : %@ , minor : %@",cBeacon.ibeacon.major, cBeacon.ibeacon.minor);
        Room *room = [rooms get:cBeacon];
        if(room != nil && ![roomBeacons containsObject:room])
            [roomBeacons addObject:room];
    }

    if(! [roomBeacons isEqualToArray:roomsNearMe]) {
        roomsNearMe = [[NSMutableArray alloc] initWithArray:roomBeacons];
        [self.roomsTableView reloadData];
    }
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Room *room = [roomsNearMe objectAtIndex:indexPath.row];
    self.meetingRoomName = room.name;
    self.calendarId = room.id;
    [self performSegueWithIdentifier:@"calendarSegue" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section = %u", roomsNearMe.count);
    return roomsNearMe.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RoomsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell  alloc] init];
    }

    Room *room = [roomsNearMe objectAtIndex:indexPath.row];
    cell.textLabel.text = room.name;
    [self freeBusyQuery:room.id roomName:room.name];
    return cell;
}

-(void)freeBusyQuery:(NSString *)meetingRoomId roomName:(NSString *)roomName
{

    NSLog(@"freebusy meetingRoomId = %@", meetingRoomId);
    GTLCalendarFreeBusyRequestItem *requestItem = [GTLCalendarFreeBusyRequestItem object];
    requestItem.identifier = meetingRoomId;
    GTLQueryCalendar *query1 = [GTLQueryCalendar queryForFreebusyQuery];
    query1.items = [NSArray arrayWithObject:requestItem];
    NSDate *now = [NSDate date];
    query1.timeMax = [GTLDateTime dateTimeWithDate:[now dateByAddingTimeInterval:60*60] timeZone:[NSTimeZone localTimeZone]];
    query1.timeMin =[GTLDateTime dateTimeWithDate:now timeZone:[NSTimeZone localTimeZone]];

    [[SignInHandler instance].calendarService executeQuery:query1 completionHandler:^(GTLServiceTicket *busyFreeTicket, id busyFreeObject, NSError *busyFreeError) {
        if (busyFreeError != nil){
            NSLog(@"%@",busyFreeError);
        }

        NSLog(@"got free busy response");
        if (busyFreeError == nil) {
            GTLCalendarFreeBusyResponse *response = busyFreeObject;
            GTLCalendarFreeBusyResponseCalendars *responseCals = response.calendars;
            NSDictionary *props = responseCals.additionalProperties;

            if(props == nil)
            {
                NSDictionary *availableRoom = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:meetingRoomId,roomName, nil] forKeys:[NSArray arrayWithObjects:@"id",@"name", nil]];
                NSLog(@"availableRoom = %@", availableRoom);
            }
        }

    }];

}

@end
