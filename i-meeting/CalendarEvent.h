//
//  CalendarEvent.h
//  i-meeting
//
//  Created by Anuj Jamwal on 07/02/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SignInHandler.h"

@interface CalendarEvent : NSObject<UIAlertViewDelegate>
- (void)busyFreeQuery:(GTLCalendarEvent *)event withController:(id)controller withMeetingRoom:(NSString *)meetingRoomId withCompletionHandler:(id)completionHandler;
+(void)saveEvent:(GTLCalendarEvent *)event withCompletionHandler:(id)completionHandler;


@end
