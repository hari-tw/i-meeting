#import "DetailedViewController.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLCalendarEvents.h"
#import "GTLCalendarEventAttendee.h"
//#import "NSGraphics.h"
//#import "NSImage.h"
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

- (NSString *)formattingTheString:(NSString *)location
{
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

-(void) getMeetingDetails
{
    NSString *eventName = ((GTLCalendarEvent *)self.event).summary;
    NSDate *eventStart = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"start"]).dateTime.date;
    NSDate *eventEnd = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"end"]).dateTime.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,   dd-MM-yyyy,   HH:mm"];
    NSString *start =[dateFormatter stringFromDate:eventEnd];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *end =[dateFormatter stringFromDate:eventStart];
    NSString *dateTime = [NSString stringWithFormat:@"%@ - %@",start , end];
    
    NSString *location=[self formattingTheString:((GTLCalendarEvent *)self.event).location];
    NSString *organiserName = ((GTLCalendarEvent *)self.event).organizer.displayName;
    NSString *description = ((GTLCalendarEvent *)self.event).descriptionProperty;
    
    NSArray *attendees =  ((GTLCalendarEvent *)self.event).attendees;
    NSString *attendeesStatusAccepted = [NSString new];
    NSString *attendeesStatusNoReply = [NSString new];
    //   NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    //    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    //    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //
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
    
    if(description == nil)
    {
        description =@"No Description Available";
    }
    
    NSString *details = [NSString new];
  
        details = [NSString stringWithFormat:@"<html >"
               "<body bgcolor=#000000>"
               "<font size=3 color=white>"
               "<h3>  <font color=#FE642E>%@</font> </h3>"
               "%@%@"
               "<hr>"
               "<h3><font color=#FE642E>Invitation From : </font></h3>%@ "
               "<hr>"
               "</html>", eventName, location, dateTime,organiserName];
    
    if (attendeesStatusAccepted.length != 0)
    {
        NSString *tempstring = [NSString stringWithFormat: @"<h3><font color=#FE642E>Accepted : </font></h3> %@",attendeesStatusAccepted];

        details = [details stringByAppendingString:tempstring];
       
    }
    if (attendeesStatusNoReply.length != 0)
    {
        NSString *tempstring = [NSString stringWithFormat: @"<h3><font color=#FE642E>No Reply : </font></h3> %@",attendeesStatusNoReply];
        
        details = [details stringByAppendingString:tempstring];
        
    }
    NSString *tempString = [NSString stringWithFormat:@"<hr><h3><font color=#FE642E>Notes : </font></h3>%@",description];
    details = [details stringByAppendingString:tempString];
    
    

        

    [self.detailsText loadHTMLString:details baseURL:nil];
    //     [NSURL URLWithString:
    //      [NSString stringWithFormat:@"file:/%@//",imagePath]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end