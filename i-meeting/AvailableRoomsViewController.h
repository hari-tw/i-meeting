//
//  AvailableRoomsViewController.h
//  i-meeting
//
//  Created by Renu Ahlawat on 3/11/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvailableRoomsViewController : UITableViewController
@property (strong, nonatomic) NSString *meetingRoomLocation;
@property (nonatomic, strong) GTLCalendarEvent *newEventToBeCreated;
@property (nonatomic, strong) NSMutableArray *freeRooms;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic) NSInteger queryCount;
@property (nonatomic) NSInteger iterator;
@property (weak, nonatomic) IBOutlet UILabel *freeRoomMessage;
- (void)getAllRooms;
-(NSString *)keyForTheMeetingRoom;
-(void)freeBusyQuery:(NSString *)meetingRoomId roomName:(NSString *)roomName;

@end
