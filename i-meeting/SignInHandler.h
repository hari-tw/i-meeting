//
//  SignInHandler.h
//  i-meeting
//
//  Created by Sanchit Bahal on 01/12/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLCalendar.h"

@interface SignInHandler : NSObject

@property (nonatomic) GTLServiceCalendar *calendarService;

- (void)authorizeUser;
- (void)signInUser:(SEL)signInDoneSelector withParentController:(UIViewController *)parentController;

@end
