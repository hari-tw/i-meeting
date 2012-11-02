//
//  ViewController.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "GTLCalendar.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "DateTimeUtility.h"
#import "NewCalendarViewController.h"
#import "QRCodeManager.h"
#import "Phone.h"

@interface RootViewController ()

@property (readonly, strong) Phone *phone;
@property (nonatomic, strong) GTLServiceCalendar *calendarService;
@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic) BOOL isSignedIn;
@property (nonatomic) NSString *calendarUrl;

@end

@implementation RootViewController
@synthesize phone = _phone;
@synthesize calendarService = _calendarService;
@synthesize eventsSummaries = _eventsSummaries;
@synthesize isSignedIn = _isSignedIn;
@synthesize calendarUrl = _calendarUrl;


static NSString *kKeychainItemName = @"OAuth2 i-meeting";
static NSString *kMyClientID = @"471799291546-hudka7jkgjsgtub7jnniblqe3lnoggcn.apps.googleusercontent.com";
static NSString *kMyClientSecret = @"zeAwF9BC1_BeokXZWxPZMpZK";

- (Phone *)phone {
    if (!_phone) _phone = [Phone new];
    return _phone;
}

- (void)awakeFromNib
{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                          clientID:kMyClientID
                                                                                      clientSecret:kMyClientSecret];
    
    NSLog(@"Can Authorize: %@", [auth canAuthorize] ? @"YES" : @"NO");

    self.isSignedIn = [auth canAuthorize];
    if (self.isSignedIn) {
        self.calendarService.authorizer = auth;
    }
}


- (GTLServiceCalendar *)calendarService
{
    if (!_calendarService) _calendarService = [GTLServiceCalendar new];
    return _calendarService;
}

- (IBAction)btnScan:(UIButton *)sender
{
    // URL to generate QR Code
    // https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20World
    NSLog(@"Scan button tapped.");
    
    UIViewController *reader = [self prepareQrCodeReader];
    [self presentModalViewController:reader animated:YES];
}

- (IBAction)btnCalendar:(UIButton *)sender
{
[self signInUser:@selector(displayCalendar)];
}

- (void)signInUser:(SEL)signInDoneSelector
{
    if (self.isSignedIn) {
        [self performSelector:signInDoneSelector];
        return;
    }
    
    NSString *scope = @"https://www.googleapis.com/auth/calendar";
    
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc]
                                                    initWithScope:scope
                                                    clientID:kMyClientID
                                                    clientSecret:kMyClientSecret
                                                    keychainItemName:kKeychainItemName
                                                    completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"Authentication failed");
                                                        } else {
                                                            NSLog(@"Authentication succeeded");
                                                            self.calendarService.authorizer = auth;
                                                            [self performSelector:signInDoneSelector];
                                                        }
                                                    }];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)displayCalendar
{
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:self.calendarUrl];
    query.timeMin = [DateTimeUtility dateTimeForYear:2012 month:10 day:24 atHour:0 minute:0 second:0];
    query.timeMax = [DateTimeUtility dateTimeForYear:2012 month:10 day:25 atHour:24 minute:0 second:0];
    [self.calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}

- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    GTLCalendarEvents *events = (GTLCalendarEvents *)object;
    self.eventsSummaries = [events.items valueForKey:@"summary"];
    
    [self performSegueWithIdentifier:@"calendarSegue" sender:self];
}

-(void) setCalendarUrl:(NSString *)calendarUrl{
    self.calendarUrl = calendarUrl;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        [segue.destinationViewController setEvents:self.eventsSummaries];
    }
}

- (UIViewController *)prepareQrCodeReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    
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
    BOOL isMeetingRoomQrCode = [[QRCodeManager new] isMeetingRoomQrCode:arr[0]];
    //scannedImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [picker dismissModalViewControllerAnimated:YES];
    
    if (isMeetingRoomQrCode)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:arr[0] message:@"Turn vibration ON?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    _calendarUrl = arr[1];
    
[self signInUser:@selector(displayCalendar)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"Button YES pressed.");
        [self.phone turnVibrationOn];
    }
}

@end
