#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject

- (BOOL)isMeetingRoomQrCode:(NSArray *)qrCode;
+ (QRCodeManager *)instance;
-(BOOL)validateQRCode:(NSString *)qrCode;


@end
