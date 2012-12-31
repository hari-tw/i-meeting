#import "QRCodeManager.h"

@interface QRCodeManager()

@property (readonly, strong) NSMutableDictionary *meetingRooms;

@end

@implementation QRCodeManager

@synthesize meetingRooms = _meetingRooms;

static QRCodeManager *_instance = nil;

+ (QRCodeManager *)instance
{
    if (!_instance) _instance = [QRCodeManager new];
    return _instance;
}


- (NSMutableDictionary *)meetingRooms {
    if (!_meetingRooms) {
        _meetingRooms = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         @"thoughtworks.com_373331393031332d343232@resource.calendar.google.com", @"Chandni Chowk", @" thoughtworks.com_39343834363831383531@resource.calendar.google.com", @"Qutub Minar",@"thoughtworks.com_39393735383835392d353936@resource.calendar.google.com",@"Counaught Place",@"thoughtworks.com_32323938303735302d313432@resource.calendar.google.com",@"Feroz Shah Kotla",@"thoughtworks.com_3134383934373439343132@resource.calendar.google.com",@"India Gate",@"thoughtworks.com_3132313934343231343931@resource.calendar.google.com",@"Jantar Mantar",
                         @"thoughtworks.com_2d3431333333353339333834@resource.calendar.google.com",@"Lal Quila",@"thoughtworks.com_383736383938353235@resource.calendar.google.com",@"Parliament",@"thoughtworks.com_2d31383832323635332d333830@resource.calendar.google.com",@"Pragati Maidan",nil];
    }
    
    return _meetingRooms;
}

- (BOOL)isMeetingRoomQrCode:(NSArray *)qrCode
{
    NSString *object = [self.meetingRooms objectForKey:qrCode[0]];
    return [qrCode[1] isEqualToString:object];
}

//arrayWithObjects:@"Chandni Chowk", @"Counaught Place", @"Feroz Shah Kotla", @"India Gate", @"Jantar Mantar", @"Lal Quila", @"Parliament", @"Pragati Maidan", @"Qutub Minar", nil

@end
