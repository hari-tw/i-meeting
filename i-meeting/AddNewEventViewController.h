#import "SignInHandler.h"
#import "CalendarEvent.h"

@interface AddNewEventViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *meetingRoomId;
@property (strong, nonatomic) NSString *meetingRoomName;
@property (strong, nonatomic) NSString *meetingRoomLocation;
@property (strong, nonatomic) IBOutlet UILabel *roomName;
@property (strong, nonatomic) NSString *calendarId;
@property (strong, nonatomic) id event;
@property (strong, nonatomic) GTLCalendarEvent *newEvent;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


- (IBAction)bookButton:(id)sender;
- (IBAction)datePicked:(UIDatePicker *)sender;
-(IBAction)textFieldReturn:(id)sender;
-(NSString *)validateEventTitle:(NSString *)title Description:(NSString *)description StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
@end
