//
// Created by Hari B on 05/12/13.
// Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//


#import "Room.h"

@implementation Room {
}

+ (Room *)mayoHall {
    //green
    Room *room = [[Room alloc]init];
    room.id=@"thoughtworks.com_31343831353539382d353539@resource.calendar.google.com";
    room.name=@"Mayo Hall";
    room.minorValue= [[NSNumber alloc] initWithInt:52603];
    room.majorValue=[[NSNumber alloc]initWithInt:16946];
    return room;
}

+ (Room *)majestic {
    //purple
    Room *room = [[Room alloc]init];
    room.id=@"thoughtworks.com_39313337343335312d393037@resource.calendar.google.com";
    room.name=@"Majestic";
    room.minorValue= [[NSNumber alloc]initWithInt:507];
    room.majorValue=[[NSNumber alloc]initWithInt:60389];
    return room;
}

+ (Room *)cubbonPark {
    //sky blue
    Room *room = [[Room alloc]init];
    room.id=@"thoughtworks.com_2d323331363930382d3630@resource.calendar.google.com";
    room.name=@"Cubbon Park";
    room.minorValue= [[NSNumber alloc]initWithInt:56924];
    room.majorValue=[[NSNumber alloc]initWithInt:10890];
    return room;
}

@end