#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RootViewController : UIViewController <ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (UIViewController *)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;
- (IBAction)signOut:(id)sender;

@end

