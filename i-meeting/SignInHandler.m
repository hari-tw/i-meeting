//
//  SignInHandler.m
//  i-meeting
//
//  Created by Sanchit Bahal on 01/12/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

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

- (GTLServiceCalendar *)calendarService
{
    if (!_calendarService) _calendarService = [GTLServiceCalendar new];
    return _calendarService;
}

- (NSString *)userEmail
{
    return self.authToken.userEmail;
}

- (void)authorizeUser
{
    self.authToken = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                           clientID:kMyClientID
                                                                       clientSecret:kMyClientSecret];
    self.isSignedIn = [self.authToken canAuthorize];
    NSLog(@"Can Authorize: %@", self.isSignedIn ? @"YES" : @"NO");
    
    if (self.isSignedIn) {
        self.calendarService.authorizer = self.authToken;
        NSLog(@"%@", self.authToken.userEmail);
    }
}

- (void)signInUser:(SEL)signInDoneSelector withParentController:(UIViewController *)parentController
{
    if (self.isSignedIn) {
        [parentController performSelector:signInDoneSelector];
        return;
    }
    
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
                                                            [parentController performSelector:signInDoneSelector];
                                                        }
                                                    }];
    
    [parentController.navigationController pushViewController:viewController animated:YES];
}

@end
