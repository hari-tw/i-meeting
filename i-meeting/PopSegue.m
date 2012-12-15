#import "PopSegue.h"

@implementation PopSegue
-(void)perform
{

    UIViewController *src = (UIViewController *)self.sourceViewController;
    
    [src.navigationController popViewControllerAnimated:NO];
    // Custom animation code here
}

@end
