#import "RootViewController.h"
#import "DateTimeUtility.h"
#import "CalendarViewController.h"
#import "QRCodeManager.h"

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
    
    UIViewController *reader = [self prepareQrCodeReader];
    [self addChildViewController:reader];
    [self.containerView addSubview:reader.view];
    [reader didMoveToParentViewController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.viewTitle = self.meetingRoomName;
        calendarViewController.calendarId = self.calendarId;
        [calendarViewController createAddEventButtonDynamically];
    }
}

- (UIViewController *)prepareQrCodeReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    reader.showsZBarControls = NO;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    return reader;
}

- (NSString *)getScannedCode:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    return symbol.data;
}

- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *scannedCode = [self getScannedCode:info];
    NSArray *arr = [scannedCode componentsSeparatedByString: @"="];
    
    self.meetingRoomName = arr[0];
    self.calendarId = arr[1];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"calendarSegue" sender:self];
}

@end
