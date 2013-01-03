#import "SignInHandler.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface SignInHandler()

@end

@implementation SignInHandler

@synthesize keychainName = _keychainName;

static SignInHandler *_instance = nil;

+ (SignInHandler *)instance
{
    if (!_instance) _instance = [SignInHandler new];
    return _instance;
}

- (NSString *)keychainName
{
    return @"imeetingauth";
}

- (GTLServiceCalendar *)calendarService
{
    if (!_calendarService) _calendarService = [GTLServiceCalendar new];
    return _calendarService;
}

- (void)signOut
{
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:self.keychainName];

    NSMutableURLRequest *logoutRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://cas.thoughtworks.com/cas/logout"]];
    NSHTTPURLResponse *response;
    NSError *err;
    [NSURLConnection sendSynchronousRequest:logoutRequest returningResponse:&response error:&err];
    [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.calendarService.authorizer];
    _instance = Nil;
}

@end
