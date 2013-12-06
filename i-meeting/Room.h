//
// Created by Hari B on 05/12/13.
// Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Room : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, retain) NSNumber *minorValue;
@property(nonatomic, retain) NSNumber *majorValue;

+ (Room *)mayoHall;
+ (Room *)majestic;
+ (Room *)cubbonPark;
@end