//
//  PopSegue.m
//  i-meeting
//
//  Created by Renu Ahlawat on 12/13/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "PopSegue.h"

@implementation PopSegue
-(void)perform
{

    UIViewController *src = (UIViewController *)self.sourceViewController;
    
    [src.navigationController popViewControllerAnimated:NO];
    // Custom animation code here
}

@end
