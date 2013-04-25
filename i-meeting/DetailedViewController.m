#import "DetailedViewController.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLCalendarEvents.h"
#import "GTLCalendarEventAttendee.h"
#import "GTLCalendarEvent.h"

@interface DetailedViewController ()

@end

@implementation DetailedViewController
@synthesize scrollView = _scrollView;
@synthesize event;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.event);
    previousLabelSize = CGSizeMake(290, 80);
    
    [self initializeFontSettings];
    [self getMeetingDetails];
    [[self view] addSubview:self.scrollView];

}

-(void)initializeFontSettings
{
 
    titleFontDetails = [NSArray arrayWithObjects:@"Helvetica-Bold",[NSNumber numberWithFloat:20.0],[UIColor colorWithRed:1.0 green:0.36 blue:0.2 alpha:1.0], nil];
    eventVenueFontDetails = [NSArray arrayWithObjects:@"Helvetica",[NSNumber numberWithFloat:15.0],[UIColor lightGrayColor], nil];
    subTitleFontDetails = [NSArray arrayWithObjects:@"Helvetica-Bold",[NSNumber numberWithFloat:17.0],[UIColor colorWithRed:1.0 green:0.36 blue:0.2 alpha:1.0], nil];
    textFontDetails = [NSArray arrayWithObjects:@"Helvetica-Bold",[NSNumber numberWithFloat:13.0],[UIColor whiteColor], nil];
}

-(void) getMeetingDetails
{
    NSString *eventName = ((GTLCalendarEvent *)self.event).summary;
    NSString *dateTime= [self getDateAndTimeOfEvent];
    NSString *location= ((GTLCalendarEvent *)self.event).location;
    NSString *organiserName = ((GTLCalendarEvent *)self.event).organizer.displayName;
    organiserName = organiserName ? organiserName : ((GTLCalendarEvent *)self.event).organizer.email;
    NSString *description = [self getDescriptionOfEvent];

    [self createLabel:eventName withFontDetails:titleFontDetails];
    [self createLabel:location withFontDetails:eventVenueFontDetails];
    [self createLabel:dateTime withFontDetails:textFontDetails];
    [self createLine];
    
    [self createLabel:@"Invitation from" withFontDetails:subTitleFontDetails];
    [self createLabel:organiserName withFontDetails:textFontDetails];
    [self createLine];
    
    [self createAttendeesList];
    
    [self createLabel:@"Notes" withFontDetails:subTitleFontDetails];
    [self createLabel:description withFontDetails:textFontDetails];
    
    self.scrollView.contentSize = CGSizeMake(previousLabelSize.width,previousLabelSize.height);
    
}


- (NSString *)getDateAndTimeOfEvent
{
    NSDate *eventStart = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"start"]).dateTime.date;
    NSDate *eventEnd = ((GTLCalendarEventDateTime *)[self.event valueForKey:@"end"]).dateTime.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    NSString *day =[dateFormatter stringFromDate:eventStart];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *start =[dateFormatter stringFromDate:eventStart];
    NSString *end =[dateFormatter stringFromDate:eventEnd];
    NSString *dateTime = [NSString stringWithFormat:@"%@\nFrom %@ to %@", day, start, end];
    return dateTime;
}

- (NSString *)getDescriptionOfEvent
{
    NSString *description = ((GTLCalendarEvent *)self.event).descriptionProperty;
    if(description == nil)
    {
        description =@"No Description Available";
    }
    return description;
}

- (void)createLabel:(NSString *)textContent withFontDetails:(NSArray *)fontSettings
{
    dynamicLabel = [[UILabel alloc]init];
    dynamicLabel.backgroundColor = [UIColor blackColor];
    dynamicLabel.numberOfLines = 0;
    dynamicLabel.font = [UIFont fontWithName:fontSettings[0] size:[fontSettings[1] floatValue]];
    dynamicLabel.textColor = fontSettings[2];
       
    dynamicLabel.frame = CGRectMake(0, previousLabelSize.height, previousLabelSize.width, (previousLabelSize.height + 400));
    [dynamicLabel setText:textContent];
    [dynamicLabel sizeToFit];
    previousLabelSize.height = previousLabelSize.height + dynamicLabel.frame.size.height + 5;
   
    [self.scrollView addSubview:dynamicLabel];    
}

-(void)createLine
{
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, previousLabelSize.height, previousLabelSize.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:line];
    previousLabelSize.height += 1;
}


- (void) createAttendeesList
{
    NSArray *attendees =  ((GTLCalendarEvent *)self.event).attendees;
    attendeesStatusAccepted = [NSMutableArray new];
    attendeesStatusTentative = [NSMutableArray new];
    attendeesStatusDeclined = [NSMutableArray new];
    attendeesStatusNoReply = [NSMutableArray new];
    
    
    for (int i=0; i<attendees.count; i++)
    {
        NSString *name = [attendees[i] valueForKey:@"displayName"];
        name = name? name : [attendees[i] valueForKey:@"email"];
        NSString *responseStatus = [attendees[i] valueForKey:@"responseStatus"];
        NSString *organizer = [attendees[i] valueForKey:@"organizer"];
        NSString *resource = [attendees[i] valueForKey:@"resource"];
        
        if( organizer == nil && resource == nil)
        {
            if([responseStatus isEqualToString:@"accepted"])
            {
                [attendeesStatusAccepted addObject:name];
            }
            else if ([responseStatus isEqualToString:@"tentative"]) {
                [attendeesStatusTentative addObject:name];
            }
            else if ([responseStatus isEqualToString:@"declined"]) {
                [attendeesStatusDeclined addObject:name];
            }
            else if ([responseStatus isEqualToString:@"needsAction"]) {
                [attendeesStatusNoReply addObject:name];
            }
        }
    }
    
    [self displayAttendeesListFor:attendeesStatusAccepted withStatus:@"Accepted"];
    [self displayAttendeesListFor:attendeesStatusTentative withStatus:@"Maybe"];
    [self displayAttendeesListFor:attendeesStatusDeclined withStatus:@"Declined"];
    [self displayAttendeesListFor:attendeesStatusNoReply withStatus:@"No Reply"];
    
}

- (void)displayAttendeesListFor:(NSArray*) attendeesStatus withStatus: (NSString*) statusString
{
    if (attendeesStatus.count > 0)
    {
        [self createLabel:statusString withFontDetails:subTitleFontDetails];
        NSString *convertedList = [self convertArrayToString:attendeesStatus];
        [self createLabel:convertedList withFontDetails:textFontDetails];
        [self createLine];        
        
    }
}


-(NSString *) convertArrayToString:(NSArray *)sample
{
    NSString *convertedString = [NSString new];
    for (int i=0; i<sample.count; i++)
    {
        convertedString = [convertedString stringByAppendingString:sample[i]];
        convertedString = [convertedString stringByAppendingString:@", "];
        
    }
    convertedString = [convertedString substringToIndex:[convertedString length] - 2];
    return convertedString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end