#import <Foundation/Foundation.h>
#import "ZBarSDK.h"

@interface Phone : NSObject <ZBarReaderDelegate>

- (void)turnVibrationOn;

@end
