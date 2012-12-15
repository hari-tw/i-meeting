#import "QRCodeManager.h"

@interface QRCodeManager()

@property (readonly, strong) NSArray *meetingRooms;

@end

@implementation QRCodeManager

@synthesize meetingRooms = _meetingRooms;

- (NSArray *)meetingRooms {
    if (!_meetingRooms) {
        _meetingRooms = [NSArray arrayWithObjects:@"Chandni Chowk", @"Counaught Place", @"Feroz Shah Kotla", @"India Gate", @"Jantar Mantar", @"Lal Quila", @"Parliament", @"Pragati Maidan", @"Qutub Minar", nil];
    }
    
    return _meetingRooms;
}

- (BOOL)isMeetingRoomQrCode:(NSString *)qrCode
{
    return [self.meetingRooms containsObject:qrCode];
}

@end
