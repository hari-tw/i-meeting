//
//  ViewController.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "QRCodeController.h"
#import "GTLCalendar.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "DateTimeUtility.h"
#import "NewCalendarViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) QRCodeController *qrCodeController;
@property (nonatomic, strong) GTLServiceCalendar *calendarService;
@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic) BOOL isSignedIn;

@end

@implementation RootViewController

@synthesize qrCodeController = _qrCodeController;
@synthesize calendarService = _calendarService;
@synthesize eventsSummaries = _eventsSummaries;
@synthesize isSignedIn = _isSignedIn;

static NSString *kKeychainItemName = @"OAuth2 i-meeting";
static NSString *kMyClientID = @"my client id";
static NSString *kMyClientSecret = @"my client secret";

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

- (QRCodeController *)qrCodeController
{
    if (!_qrCodeController) _qrCodeController = [QRCodeController new];
    return _qrCodeController;
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
    
    UIViewController *reader = [self.qrCodeController prepareQrCodeReader];
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
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"sbahal@thoughtworks.com"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calendarSegue"]) {
        [segue.destinationViewController setEvents:self.eventsSummaries];
    }
}

@end
