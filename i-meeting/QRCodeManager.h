#import <Foundation/Foundation.h>

@interface QRCodeManager : NSObject
+ (QRCodeManager *)instance;
-(BOOL)validateQRCode:(NSString *)qrCode;


@end
