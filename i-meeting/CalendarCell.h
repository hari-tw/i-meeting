#import <UIKit/UIKit.h>

@class CalendarCell;
@protocol reloadView
 -(void)reloadTableView: (CalendarCell *) sender;
@end

@interface CalendarCell : UITableViewCell {
    NSString *eventId;
}

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizerLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property NSString *eventID;
@property (nonatomic, weak) IBOutlet id <reloadView> delegate;
- (IBAction)deleteBooking:(id)sender;
@end
