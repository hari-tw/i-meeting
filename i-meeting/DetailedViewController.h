#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController <UIScrollViewDelegate>
{
    UILabel *dynamicLabel;
    CGSize previousLabelSize;
    NSArray *titleFontDetails;
    NSArray *eventVenueFontDetails;
    NSArray *subTitleFontDetails;
    NSArray *textFontDetails;
    NSMutableArray *attendeesStatusAccepted;
    NSMutableArray *attendeesStatusTentative;
    NSMutableArray *attendeesStatusDeclined;
    NSMutableArray *attendeesStatusNoReply;
}

-(void)initializeFontSettings;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) id event;
@end