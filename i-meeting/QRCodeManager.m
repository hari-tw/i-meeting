#import "QRCodeManager.h"

@interface QRCodeManager()

@property (readonly, strong) NSMutableDictionary *meetingRooms;

@end

@implementation QRCodeManager


static QRCodeManager *_instance = nil;

+ (QRCodeManager *)instance
{
    if (!_instance) _instance = [QRCodeManager new];
    return _instance;
}

-(BOOL)validateQRCode:(NSString *)qrCode
{
    NSRange abc = [qrCode rangeOfString:@"i-meeting"];
    return abc.location == NSNotFound;
}

@end
