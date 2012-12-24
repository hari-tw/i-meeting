//
//  DetailedViewController.m
//  i-meeting
//
//  Created by Akriti Ayushi on 12/24/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "DetailedViewController.h"
#import "GTLCalendarEventDateTime.h"



@interface DetailedViewController ()

@end

@implementation DetailedViewController

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
    self.viewTitle = [self.event valueForKey:@"summary"];
      
    self.title = self.viewTitle;
     NSLog(@"%@", self.event);
    [self getDateInFormattedForm];
    [self getTheLocation];
    [self getTheOrganiserAndTheCalendar];
    [self getTheDescription];
    
  
	// Do any additional setup after loading the view.
}

-(void) getDateInFormattedForm
{
    NSDate *eventStart = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"start"]).dateTime.date;
    NSDate *eventEnd = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"end"]).dateTime.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,   dd-MM-yyyy,   HH:mm"];
    NSString *start =[dateFormatter stringFromDate:eventEnd];
     [dateFormatter setDateFormat:@"HH:mm"];
     NSString *end =[dateFormatter stringFromDate:eventStart];
    NSString *dateLbl = [NSString stringWithFormat:@"%@ - %@",start , end];
    self.dateLabel.text = dateLbl;
}

-(void) getTheLocation
{
    NSString *location = [self.event valueForKey:@"location"];
    self.locationLabel.text = [NSString stringWithFormat:@"Where : %@",location];
}

-(void) getTheOrganiserAndTheCalendar
{
    NSArray *organiser = [self.event valueForKey:@"organizer"];
    self.organiserLabel.text = [@"Organizer: " stringByAppendingString:[organiser valueForKey:@"displayName"]];
     self.calendarIdLabel.text = [@"Calendar: " stringByAppendingString:[organiser valueForKey:@"email"]];
}

-(void) getTheDescription
{
     NSDictionary *description = [self.event valueForKey:@"description"];
//    NSRange range = NSMakeRange(0, 27);
//    NSString *desc = [[description valueForKeyPath:@"description"] stringByReplacingCharactersInRange:range withString:@""];
//    NSError *error;
//    NSDictionary *details = [NSJSONSerialization JSONObjectWithData:[desc dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:true] options:nil error:&error];
    self.descriptionLabel.text = [@"Description: " stringByAppendingString:[description valueForKey:@"description"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
