#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RootViewController : UIViewController

- (void)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;
- (IBAction)signOut:(id)sender;

@end

