#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "SignInHandler.h"

@interface MyMeetingViewController : CalendarViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SignInHandler *signInHandler;

@end
