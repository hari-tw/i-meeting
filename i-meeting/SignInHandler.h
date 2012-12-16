#import <Foundation/Foundation.h>
#import "GTLCalendar.h"

@interface SignInHandler : NSObject

@property (nonatomic) GTLServiceCalendar *calendarService;

- (void)authorizeUser:(UIViewController *)parentController;
- (NSString *)userEmail;
+ (SignInHandler *)instance;

@end
