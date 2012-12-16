#import "SignInHandler.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface SignInHandler()

@property (nonatomic) BOOL isSignedIn;
@property (nonatomic) GTMOAuth2Authentication *authToken;

@end

@implementation SignInHandler

@synthesize isSignedIn = _isSignedIn;
@synthesize authToken = _authToken;

static NSString *kKeychainItemName = @"OAuth2 i-meeting";
static NSString *kMyClientID = @"918644537696.apps.googleusercontent.com";
static NSString *kMyClientSecret = @"OH0beWXoas6VOKqWq6_SvM5i";
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

- (NSString *)userEmail
{
    return self.authToken.userEmail;
}

- (void)authorizeUser:(UIViewController *)parentController
{
    self.authToken = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                           clientID:kMyClientID
                                                                       clientSecret:kMyClientSecret];
    self.isSignedIn = [self.authToken canAuthorize];
    NSLog(@"Can Authorize: %@", self.isSignedIn ? @"YES" : @"NO");
    
    if (self.isSignedIn) {
        self.calendarService.authorizer = self.authToken;
        NSLog(@"%@", self.authToken.userEmail);
        return;
    }
    
    [self presentAuthScreen:parentController];
}

- (void)presentAuthScreen:(UIViewController *)parentController
{
    NSString *scope = @"https://www.googleapis.com/auth/calendar";
    
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc]
                                                    initWithScope:scope
                                                    clientID:kMyClientID
                                                    clientSecret:kMyClientSecret
                                                    keychainItemName:kKeychainItemName
                                                    completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"Authentication failed");
                                                        } else {
                                                            NSLog(@"Authentication succeeded");
                                                            self.calendarService.authorizer = auth;
                                                        }
                                                    }];
    
    [parentController.navigationController pushViewController:viewController animated:YES];

}

@end
