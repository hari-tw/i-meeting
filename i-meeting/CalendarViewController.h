#import <UIKit/UIKit.h>
#import "SignInHandler.h"

@interface CalendarViewController : UITableViewController
{
    NSMutableArray *dataArray;
}

@property (nonatomic) NSArray *eventsSummaries;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) NSString *viewTitle;
@property (strong, nonatomic) NSString *calendarId;
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
-(void) createAddEventButtonDynamically;

@end
