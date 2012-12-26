//
//  DetailedViewController.m
//  i-meeting
//
//  Created by Akriti Ayushi on 12/24/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLCalendarEvents.h"
#import "GTLCalendarEventAttendee.h"

#import "GTLCalendarEvent.h"



@interface DetailViewController ()

@end

@implementation DetailViewController

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
    
    self.viewTitle =  ((GTLCalendarEvent *)self.event).summary;
    
    self.title = self.viewTitle;
    NSLog(@"%@", self.event);
    
    [self getMeetingDetails];
}

- (NSString *)formattingTheString:(NSString *)location
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@".,"];
    NSArray *myArray = [location componentsSeparatedByCharactersInSet:characterSet];
    NSString *formattedLocation = [NSString new];
    formattedLocation = @"";
    for (int i=0; i<myArray.count; i++)
    {
        formattedLocation = [formattedLocation stringByAppendingString:myArray[i]];
        formattedLocation = [formattedLocation stringByAppendingString:@".\n"];
    }
    return formattedLocation;
}




-(void) getMeetingDetails
{
    NSDate *eventStart = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"start"]).dateTime.date;
    NSDate *eventEnd = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"end"]).dateTime.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,   dd-MM-yyyy,   HH:mm"];
    NSString *start =[dateFormatter stringFromDate:eventEnd];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *end =[dateFormatter stringFromDate:eventStart];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",start , end];
    
    // NSString *location = ((GTLCalendarEvent *)self.event).location;
    NSString *location=[self formattingTheString:((GTLCalendarEvent *)self.event).location];
    NSString *organiserName = ((GTLCalendarEvent *)self.event).organizer.displayName;
    NSString *organiserCalendar = ((GTLCalendarEvent *)self.event).organizer.email;
    NSString *description = ((GTLCalendarEvent *)self.event).descriptionProperty;
    
    NSArray *attendees =  ((GTLCalendarEvent *)self.event).attendees;
    NSString *attendeesStatus = [NSString new];
    
    for (int i=0; i<attendees.count; i++){
        NSString *name = [attendees[i] valueForKey:@"displayName"];
        NSString *responseStatus = [attendees[i] valueForKey:@"responseStatus"];
        attendeesStatus = [attendeesStatus stringByAppendingString:name];
        attendeesStatus = [attendeesStatus stringByAppendingString:@"  "];
        attendeesStatus = [attendeesStatus stringByAppendingString:responseStatus];
        
        attendeesStatus = [attendeesStatus stringByAppendingString:@"\n"];
        
    }
    
    
    NSString *details = [NSString stringWithFormat:@"Where : %@ \n\nOrganiser : %@ \n\nCalendar : %@ \n\nDescription : %@ \n\n%@", location, organiserName, organiserCalendar, description, attendeesStatus];
    self.detailsText = (UITableView *)details;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
