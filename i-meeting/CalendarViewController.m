//
//  NewCalendarViewController.m
//  i-meeting
//
//  Created by Sanchit Bahal on 24/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import  "GTLCalendarEventDateTime.h"
#import "AddNewEventViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.viewTitle;
    self.currentDateLabel.text = self.currentDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.events.count;
}

- (NSString *)durationOfMeeting:(NSDateComponents *)eventStart eventEnd:(NSDateComponents *)eventEnd
{
    NSString *durationString;
    int startTimeInMinute = ((eventStart.hour)*60)+eventStart.minute;
    int endTimeInMinute = (eventEnd.hour*60)+eventEnd.minute;
    int duration = endTimeInMinute-startTimeInMinute;
    if (duration < 60) {
        durationString = [NSString stringWithFormat:@"%d minutes", duration];}
    else {
        int hour = duration/60;
        int minutes = duration%60;
        if (minutes == 0) {
            durationString = [NSString stringWithFormat:@"%d hour", hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%d hour %d minutes", hour,minutes];
        }
    }
    return durationString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *durationString = @"";
    static NSString *cellIdentifier = @"Cell";
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    id event = [self.events objectAtIndex:indexPath.row];
    NSDateComponents *eventStart = ((GTLCalendarEventDateTime *)[event valueForKey:@"start"]).dateTime.dateComponents;
    NSDateComponents *eventEnd = ((GTLCalendarEventDateTime *)[event valueForKey:@"end"]).dateTime.dateComponents;
    
    durationString = [self durationOfMeeting:eventStart eventEnd:eventEnd];
    
    NSString *eventStartTime = [NSString stringWithFormat:@"%02d:%02d", eventStart.hour, eventStart.minute];
    NSString *eventEndTime = [NSString stringWithFormat:@"%02d:%02d", eventEnd.hour, eventEnd.minute];
    
    cell.titleLabel.text = [event valueForKey:@"summary"];
    cell.timingsLabel.text = [NSString stringWithFormat:@"%@-%@", eventStartTime, eventEndTime];
    cell.durationLabel.text = [NSString stringWithFormat: @"%@", durationString];
    
    NSLog(@"%@", event);
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addEvent"]) {
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        addNewEventViewController.meetingRoomId = self.calendarId;
        addNewEventViewController.meetingRoomName = self.viewTitle;

    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCurrentDateLabel:nil];
    [super viewDidUnload];
}
@end
