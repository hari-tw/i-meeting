#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RootViewController : ZBarReaderViewController <ZBarReaderDelegate>

- (void)prepareQrCodeReader;
- (NSString *)getScannedCode:(NSDictionary *)info;
- (IBAction)signOut:(id)sender;

@end

