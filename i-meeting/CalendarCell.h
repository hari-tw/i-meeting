#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizerLabel;

@end
