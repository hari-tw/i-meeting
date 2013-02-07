//
//  CalendarEvent.h
//  i-meeting
//
//  Created by Anuj Jamwal on 07/02/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignInHandler.h"

@interface CalendarEvent : NSObject
+(void)busyFreeQuery:(GTLCalendarEvent *)event withMeetingRoom:(NSString *)meetingRoomId withCompletionHandler:(id)completionHandler;

@end
