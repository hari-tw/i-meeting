//
//  CalendarResourceRetreiver.m
//  i-meeting
//
//  Created by Rohit Garg on 14/03/13.
//  Copyright (c) 2013 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "CalendarResourceRetreiver.h"
#import "GTLClientLoginAuthentication.h"
@implementation CalendarResourceRetreiver

+ (NSArray *) getCalendarResourcesFor:(NSString *)username withPassword:(NSString *)password
{
    NSMutableArray *dataArray = [NSMutableArray new];
    GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://apps-apis.google.com/a/feeds/calendar/resource/2.0/thoughtworks.com" ]]];
    GTLClientLoginAuthentication *auth = [GTLClientLoginAuthentication authenticationForService:@"apps" source:@"HOSTED_OR_GOOGLE"];
    [auth setUserEmail:username];
    [auth setPassword:password];
    [myFetcher setAuthorizer:auth];
    [myFetcher beginFetchWithCompletionHandler:^(NSData *retrievedData, NSError *error) {
        if (error != nil) {
            // status code or network error
        } else {
            // succeeded
        }
    }];
    return dataArray;
}

@end