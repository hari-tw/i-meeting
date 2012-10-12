//
//  Phone.m
//  meWorks
//
//  Created by Sanchit on 17/08/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Phone.h"

@implementation Phone

- (void)turnVibrationOn
{
   AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); 
}

@end
