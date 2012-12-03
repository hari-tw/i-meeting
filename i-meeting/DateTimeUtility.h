//
//  DateTimeUtility.h
//  i-meeting
//
//  Created by Sanchit Bahal on 24/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLDateTime.h"

@interface DateTimeUtility : NSObject

+ (GTLDateTime *)dateTimeForTodayAtHour:(int)hour
                                 minute:(int)minute
                                 second:(int)second;


+ (GTLDateTime *)dateTimeForDate:(NSDate *)date
                          atHour:(int)hour
                          minute:(int)minute
                          second:(int)second;

+ (GTLDateTime *)dateTimeForYear:(int)year
                           month:(int)month
                             day:(int)day
                          atHour:(int)hour
                          minute:(int)minute
                          second:(int)second;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)date;

@end
