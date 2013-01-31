#import <Foundation/Foundation.h>
#import "GTLQueryCalendar.h"

@interface GTLCalendarManager : NSObject

+ (GTLQueryCalendar *)getCalendarQueryWithCalendars:(NSArray *)calendars timeMin:(GTLDateTime *)timeMin timeMax:(GTLDateTime *)timeMax;

@end
