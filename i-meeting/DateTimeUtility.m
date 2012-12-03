//
//  DateTimeUtility.m
//  i-meeting
//
//  Created by Sanchit Bahal on 24/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "DateTimeUtility.h"

@implementation DateTimeUtility

+ (GTLDateTime *)dateTimeForTodayAtHour:(int)hour
                                 minute:(int)minute
                                 second:(int)second
{
    
    return [self dateTimeForDate:[NSDate date] atHour:hour minute:minute second:second];
}

+ (GTLDateTime *)dateTimeForDate:(NSDate *)date atHour:(int)hour minute:(int)minute second:(int)second
{
    int const kComponentBits = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [cal components:kComponentBits fromDate:date];
    
    return [self dateTimeForYear:[dateComponents year] month:[dateComponents month] day:[dateComponents day] atHour:[dateComponents hour] minute:[dateComponents minute] second:[dateComponents second]];
}

+ (GTLDateTime *)dateTimeForYear:(int)year
                           month:(int)month
                             day:(int)day
                          atHour:(int)hour
                          minute:(int)minute
                          second:(int)second
{
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    [dateComponents setTimeZone:[NSTimeZone systemTimeZone]];
    
    GTLDateTime *dateTime = [GTLDateTime dateTimeWithDateComponents:dateComponents];
    return dateTime;
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)date
{
    return [[self dateFormatter] dateFromString:date];
}

@end
