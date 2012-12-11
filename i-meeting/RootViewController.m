//
//  ViewController.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "DateTimeUtility.h"
#import "CalendarViewController.h"
#import "QRCodeManager.h"
#import "Phone.h"
#import "SignInHandler.h"
#import "Foundation/NSCalendar.h"


@interface RootViewController ()

@property (readonly, strong) Phone *phone;
@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic, strong) NSArray *eventsSummariesForTomorrow;
@property (nonatomic) BOOL isSignedIn;
@property (nonatomic) NSString *calendarId;
@property (nonatomic, strong) NSString *meetingRoomName;
@property (nonatomic, strong) SignInHandler *signInHandler;

@end

@implementation RootViewController
@synthesize phone = _phone;
@synthesize eventsSummaries = _eventsSummaries;
@synthesize eventsSummariesForTomorrow = _eventsSummariesForTomorrow;
@synthesize isSignedIn = _isSignedIn;
@synthesize calendarId = _calendarUrl;
@synthesize meetingRoomName = _meetingRoomName;
@synthesize signInHandler = _signInHandler;

- (Phone *)phone {
    if (!_phone) _phone = [Phone new];
    return _phone;
}

- (void)viewDidAppear:(BOOL)animated
{
    // URL to generate QR Code
    // https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20World
    NSLog(@"Scan button tapped.");
    
    UIViewController *reader = [self prepareQrCodeReader];
    [self addChildViewController:reader];
    [self.containerView addSubview:reader.view];
    [reader didMoveToParentViewController:self];
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



- (NSString *)dateToString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    NSDate *date1 = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date1];
    return dateString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.viewTitle = self.meetingRoomName;
        calendarViewController.calendarId = self.calendarId;
        NSString *dateString;
        dateString = [self dateToString];
        calendarViewController.currentDate = [NSString stringWithFormat:@"%@",dateString];

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *scannedCode = [self getScannedCode:info];
    NSArray *arr = [scannedCode componentsSeparatedByString: @"="];
    
    self.meetingRoomName = arr[0];
    self.calendarId = arr[1];
    [self performSegueWithIdentifier:@"calendarSegue" sender:self];

    
}

- (void)viewDidUnload {
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end
