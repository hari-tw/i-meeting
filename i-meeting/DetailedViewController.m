#import "DetailedViewController.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLCalendarEvents.h"
#import "GTLCalendarEventAttendee.h"
#import "GTLCalendarEvent.h"



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
    
    NSLog(@"%@", self.event);
    
    [self getMeetingDetails];
}


-(void) getMeetingDetails
{
    NSString *eventName = ((GTLCalendarEvent *)self.event).summary;
    
    NSString *dateTime= [self gettingTheDateAndTimeOfEvent];
    
    NSString *location= [self gettingLocation];
    
    NSString *organiserName = ((GTLCalendarEvent *)self.event).organizer.displayName;
    
    NSString *detailsForDisplaying = [NSString new];
    
    detailsForDisplaying = [NSString stringWithFormat:@"<html >"
                            "<body bg color=black>"
                            "<font size=3 color=white>"
                            " <font size=5 color=#FE642E><b> <Center><I><U>%@</b></I></U></center></font>"
                            "%@%@"
                            "<hr>"
                            "<font size=4 color=#FE642E><b>Invitation From : </b></font></h3>%@ "
                            "<hr>"
                            "</html>", eventName, location, dateTime,organiserName];
    
    [self gettingAcceptedAndNoReplyGuestsList:&detailsForDisplaying];
    
    [self gettingTheDescriptionOfEvent:&detailsForDisplaying];
    
    [self.detailsText setValue:detailsForDisplaying forKey:@"contentToHTMLString"];
    
}



- (NSString *)gettingLocation
{
    NSString *location=((GTLCalendarEvent *)self.event).location;
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@".,"];
    NSArray *myArray = [location componentsSeparatedByCharactersInSet:characterSet];
    NSString *formattedLocation = [NSString new];
    formattedLocation = @"";
    for (int i=0; i<myArray.count; i++)
    {
        formattedLocation = [formattedLocation stringByAppendingString:myArray[i]];
        formattedLocation = [formattedLocation stringByAppendingString:@".<br/>"];
    }
    return formattedLocation;
}


- (void)gettingAcceptedAndNoReplyGuestsList:(NSString **)detailsForDisplaying
{
    NSArray *attendees =  ((GTLCalendarEvent *)self.event).attendees;
    NSString *attendeesStatusAccepted = [NSString new];
    NSString *attendeesStatusNoReply = [NSString new];
    
    for (int i=0; i<attendees.count; i++)
    {
        NSString *name = [attendees[i] valueForKey:@"displayName"];
        NSString *responseStatus = [attendees[i] valueForKey:@"responseStatus"];
        if([responseStatus isEqualToString:@"accepted"])
        {
            attendeesStatusAccepted = [attendeesStatusAccepted stringByAppendingString:name];
            attendeesStatusAccepted = [attendeesStatusAccepted stringByAppendingString:@"<br/>"];
        }
        else{
            attendeesStatusNoReply = [attendeesStatusNoReply stringByAppendingString:name];
            attendeesStatusNoReply = [attendeesStatusNoReply stringByAppendingString:@"<br/>"];
        }
        
    }

    if (attendeesStatusAccepted.length != 0)
    {
        NSString *tempstring = [NSString stringWithFormat: @"<font size=4 color=#FE642E><b>Accepted : </b></font> <br/>%@<br/>",attendeesStatusAccepted];
        
        *detailsForDisplaying = [*detailsForDisplaying stringByAppendingString:tempstring];
        
    }
    if (attendeesStatusNoReply.length != 0)
    {
        NSString *tempstring = [NSString stringWithFormat: @"<font size=4 color=#FE642E><b>No Reply : </b></font><br/>%@",attendeesStatusNoReply];
        
        *detailsForDisplaying = [*detailsForDisplaying stringByAppendingString:tempstring];
        
    }
}



- (void)gettingTheDescriptionOfEvent:(NSString **)detailsForDisplaying
{
    NSString *description = ((GTLCalendarEvent *)self.event).descriptionProperty;
    if(description == nil)
    {
        description =@"No Description Available";
    }
    
    NSString *tempString = [NSString stringWithFormat:@"<hr><font size=4 color=#FE642E><b>Notes : </b></font>%@",description];
    *detailsForDisplaying = [*detailsForDisplaying stringByAppendingString:tempString];
}



- (NSString *)gettingTheDateAndTimeOfEvent
{
    NSDate *eventStart = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"start"]).dateTime.date;
    NSDate *eventEnd = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"end"]).dateTime.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,   dd-MM-yyyy,   HH:mm"];
    NSString *start =[dateFormatter stringFromDate:eventEnd];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *end =[dateFormatter stringFromDate:eventStart];
    NSString *dateTime = [NSString stringWithFormat:@"%@ - %@",start , end];
    return dateTime;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end