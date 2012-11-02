//
//  CalendarViewController.m
//  i-meeting
//
//  Created by Sanchit Bahal on 13/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

- (void)loadCalendar;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadCalendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCalendar {
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:urlRequest];
    if (self.isViewLoaded  && self.view.window){
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewView)];
        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.rightBarButtonItem.title = @"Add New";
    }

}

- (void)insertNewView{
    
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)addNew:(id)sender {
    
}
@end
