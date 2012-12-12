#import "MyMeetingViewController.h"

@interface MyMeetingViewController ()
@end

@implementation MyMeetingViewController


- (void)awakeFromNib
{
    [self.signInHandler authorizeUser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinner startAnimating];
    [self.spinner hidesWhenStopped];
    [self performSegueWithIdentifier:@"myCalendarSeague" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"myCalendarSeague"]) {
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.viewTitle = @"My Meetings";
        NSString* userEmail = [self.signInHandler userEmail];
        calendarViewController.calendarId = userEmail;
        [calendarViewController.signInHandler signInUser:@selector(displayCalendar:) withCalendarId:calendarViewController.calendarId withParentController:calendarViewController];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end