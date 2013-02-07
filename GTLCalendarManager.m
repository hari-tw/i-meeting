#import "GTLCalendarManager.h"

@implementation GTLCalendarManager

+ (GTLQueryCalendar *)getCalendarQueryWithCalendars:(NSArray *)calendars timeMin:(GTLDateTime *)timeMin timeMax:(GTLDateTime *)timeMax
{
    GTLQueryCalendar *query = [GTLQueryCalendar queryForFreebusyQuery];
    query.fields = @"calendars";
    query.items = calendars;
    query.timeMin = timeMin;
    query.timeMax = timeMax;

    return query;
}

@end
