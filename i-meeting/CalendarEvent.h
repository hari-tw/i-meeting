#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SignInHandler.h"

@interface CalendarEvent : NSObject<UIAlertViewDelegate>
- (void)busyFreeQuery:(GTLCalendarEvent *)event withController:(id)controller withMeetingRoom:(NSString *)meetingRoomId withCompletionHandler:(id)completionHandler;
+(void)saveEvent:(GTLCalendarEvent *)event withCompletionHandler:(id)completionHandler;


@end
