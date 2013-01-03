#import "CalendarCell.h"
#import "SignInHandler.h"
#import "CalendarViewController.h"

@implementation CalendarCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteBooking:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Warning"];
	[alert setMessage:@"Are you sure you want to delete the event?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsDeleteWithCalendarId:[SignInHandler instance].userEmail  eventId:self.eventID];
        query.sendNotifications = TRUE;
        [[SignInHandler instance].calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id eventId, NSError *error){
            if (error != nil)
            {
                UIAlertView *alertErrorInQuery = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem in deleting the event in the calander." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertErrorInQuery show];
                NSLog(@"%@", error.description);
            }
            else
            {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Well Done" message:@"Event deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                [self.delegate reloadTableView:self];
            }
        }];

	}
	else if (buttonIndex == 1)
	{
	}
}
@end
