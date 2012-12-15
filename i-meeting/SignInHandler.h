#import <Foundation/Foundation.h>
#import "GTLCalendar.h"

@interface SignInHandler : NSObject

@property (nonatomic) GTLServiceCalendar *calendarService;

- (void)authorizeUser;
- (void)signInUser:(SEL)signInDoneSelector withParentController:(UIViewController *)parentController;
- (NSString *)userEmail;

@end
