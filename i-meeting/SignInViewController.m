//
//  SignInViewController.m
//  i-meeting
//
//  Created by Sanchit Bahal on 19/12/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInHandler.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [[SignInHandler instance] authorizeUser:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self performSegueWithIdentifier:@"appWorkflowSegue" sender:self];
}

@end
