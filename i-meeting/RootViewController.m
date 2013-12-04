#import "RootViewController.h"
#import "DateTimeUtility.h"
#import "CalendarViewController.h"
#import "QRCodeManager.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface RootViewController ()

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
    // URL to generate QR Code
    // https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20World
    [super viewDidLoad];
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

@end
