#import <UIKit/UIKit.h>

@class ESTBeaconManager;

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) ESTBeaconManager *beaconManager;

@property(nonatomic, strong) IBOutlet UITableView *roomsTableView;

- (IBAction)signOut:(id)sender;
@end

