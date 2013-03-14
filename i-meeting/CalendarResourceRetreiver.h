//
//  CalendarResourceRetreiver.h
//  i-meeting
//
//  Created by Rohit Garg on 14/03/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"

@interface CalendarResourceRetreiver : NSObject
+ (NSArray *) getCalendarResourcesFor:(NSString *) username withPassword:(NSString *)password;
@end
