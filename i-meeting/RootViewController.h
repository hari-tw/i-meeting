#import <UIKit/UIKit.h>

@class ESTBeaconManager;

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) ESTBeaconManager *beaconManager;

- (IBAction)signOut:(id)sender;
@end

