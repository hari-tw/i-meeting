#import <UIKit/UIKit.h>
#import "SignInHandler.h"
#import "SignInViewController.h"
#import "CalendarCell.h"

@interface CalendarViewController : UITableViewController <reloadView>
{
    NSMutableArray *dataArray;
    NSMutableArray *sectionHeaders;
    NSMutableArray *eventsForToday;
    NSMutableArray *eventsForTomorrow;
    NSMutableArray *eventsForDayAfterTomorrow;
    id event;
    UILabel *label;
}

@property (nonatomic) NSArray *eventsSummaries;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) NSString *viewTitle;
@property (strong, nonatomic) NSString *calendarId;

-(void) createAddEventButtonDynamically;
- (void)viewWillAppear:(BOOL)animated;
- (IBAction)signOut:(id)sender;


@end
