#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject

- (BOOL)isMeetingRoomQrCode:(NSArray *)qrCode;
+ (QRCodeManager *)instance;


@end
