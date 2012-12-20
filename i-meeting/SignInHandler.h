#import <Foundation/Foundation.h>
#import "GTLCalendar.h"

@interface SignInHandler : NSObject

@property (nonatomic) GTLServiceCalendar *calendarService;
@property (nonatomic) NSString *userEmail;
@property (nonatomic, readonly) NSString *keychainName;

+ (SignInHandler *)instance;
- (void)signOut;

@end
