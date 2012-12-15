#import <AudioToolbox/AudioToolbox.h>
#import "Phone.h"

@implementation Phone

- (void)turnVibrationOn
{
   AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); 
}

@end
