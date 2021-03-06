#import "SignInViewController.h"
#import "SignInHandler.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface SignInViewController ()

@property (nonatomic) BOOL isSignedIn;
@property (nonatomic) GTMOAuth2Authentication *authToken;

@end

@implementation SignInViewController

@synthesize isSignedIn = _isSignedIn;
@synthesize authToken = _authToken;

static NSString *kMyClientID = @"471799291546-hudka7jkgjsgtub7jnniblqe3lnoggcn.apps.googleusercontent.com";
static NSString *kMyClientSecret = @"zeAwF9BC1_BeokXZWxPZMpZK";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self authorizeUser];
}

- (void)authorizeUser
{
    self.authToken = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[SignInHandler instance].keychainName
                                                                           clientID:kMyClientID
                                                                       clientSecret:kMyClientSecret];
    self.isSignedIn = [self.authToken canAuthorize];
    NSLog(@"Can Authorize: %@", self.isSignedIn ? @"YES" : @"NO");
    
    if (self.isSignedIn)
        [self proceedToTheApp];
    else
        [self presentAuthScreen];
}

- (void)presentAuthScreen
{
    NSString *scope = @"https://www.googleapis.com/auth/calendar";
    
    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc]
                                                    initWithScope:scope
                                                    clientID:kMyClientID
                                                    clientSecret:kMyClientSecret
                                                    keychainItemName:[SignInHandler instance].keychainName
                                                    completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                                        if (error) {
                                                            UIAlertView *alertErrorInQuery = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Authentication failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                            [alertErrorInQuery show];
                                                            NSLog(@"Authentication failed");
                                                        } else {
                                                            NSLog(@"Authentication succeeded");
                                                            self.authToken = auth;
                                                            self.isSignedIn = YES;
                                                            [self proceedToTheApp];
                                                        }
                                                    }];
    viewController.navigationItem.hidesBackButton = YES;
    viewController.title = @"iMeeting";
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)proceedToTheApp
{
    [SignInHandler instance].calendarService.authorizer = self.authToken;
    [SignInHandler instance].userEmail = self.authToken.userEmail;
    self.navigationController.navigationBarHidden = YES;
    [self performSegueWithIdentifier:@"appWorkflowSegue" sender:self];
    
}

@end
