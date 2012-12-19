#import "SignInHandler.h"

@interface SignInHandler()

@end

@implementation SignInHandler

static SignInHandler *_instance = nil;

+ (SignInHandler *)instance
{
    if (!_instance) _instance = [SignInHandler new];
    return _instance;
}

- (GTLServiceCalendar *)calendarService
{
    if (!_calendarService) _calendarService = [GTLServiceCalendar new];
    return _calendarService;
}

@end
