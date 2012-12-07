//
//  MyMeetingViewController.m
//  i-meeting
//
//  Created by Manan on 11/6/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "MyMeetingViewController.h"
#import "GTLCalendar.h"
#import "DateTimeUtility.h"
#import "CalendarCell.h"
#import  "GTLCalendarEventDateTime.h"
#import "RootViewController.h"
#import "SignInHandler.h"

@interface MyMeetingViewController ()

@property (nonatomic, strong) GTLServiceCalendar *calendarService;
@property (nonatomic, strong) NSArray *eventsSummaries;
@property (nonatomic) BOOL isSignedIn;
@property (nonatomic, strong) SignInHandler *signInHandler;

@end

@implementation MyMeetingViewController

@synthesize eventsSummaries = _eventsSummaries;
@synthesize calendarService = _calendarService;
@synthesize isSignedIn = _isSignedIn;
@synthesize signInHandler = _signInHandler;

- (void)viewDidLoad
{
    [self displayCalendar];
    [super viewDidLoad];
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *userNameToViewCalendar = [userPreferences stringForKey:@"userNameToViewCalendar"];
    if(userNameToViewCalendar == nil){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!"
                                                         message:@"Please enter the username whose calendar you want to view:"
                                                         delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"Enter User Name";
        [alert show];
    }
}

  -  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setObject:[[alertView textFieldAtIndex:0] text] forKey:@"userNameToViewCalendar"];
        [userPreferences synchronize];
  }

- (SignInHandler *)signInHandler
{
    if (!_signInHandler) _signInHandler = [SignInHandler new];
    return _signInHandler;
}

- (void)displayCalendar
    { NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *userNameToViewCalendar = [userPreferences stringForKey:@"userNameToViewCalendar"];
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:userNameToViewCalendar];
    query.timeMin =  [DateTimeUtility dateTimeForYear:2012 month:12 day:06 atHour:0 minute:0 second:0];
    query.timeMax = [DateTimeUtility dateTimeForYear:2012 month:12 day:07 atHour:24 minute:0 second:0];
    [self.signInHandler.calendarService executeQuery:query delegate:self didFinishSelector:@selector(didFinishQueryCalendar:finishedWithObject:error:)];
}

- (void)didFinishQueryCalendar:(GTLServiceTicket *)ticket finishedWithObject:(GTLObject *)object error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    GTLCalendarEvents *events = (GTLCalendarEvents *)object;
    self.events = events.items;
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
