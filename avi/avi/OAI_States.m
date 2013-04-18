//
//  OAI_States.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/21/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_States.h"

@implementation OAI_States

- (NSArray* ) getStates {
    
    states = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"American Samoa", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
    return states;
    
}

- (NSDictionary* ) getStatesAndAbbreviations {
    
    statesAndAbbrevs = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"Alabama", @"AL",
                        @"Alaska", @"AK",
                        @"Arizona", @"AZ",
                        @"Arkansas", @"AR",
                        @"California", @"CA",
                        @"Colorado", @"CO",
                        @"Connecticut", @"CT",
                        @"Delaware", @"DE",
                        @"Florida", @"FL",
                        @"Georgia", @"GA",
                        @"Hawaii", @"HI",
                        @"Idaho", @"ID",
                        @"Illinois", @"IL",
                        @"Indiana", @"IN",
                        @"Iowa", @"IA",
                        @"Kansas", @"KS",
                        @"Kentucky", @"KY",
                        @"Louisiana", @"LA",
                        @"Maine", @"ME",
                        @"Maryland", @"MD",
                        @"Massachusetts", @"MA",
                        @"Michigan", @"MI",
                        @"Minnesota", @"MN",
                        @"Mississippi", @"MS",
                        @"Missouri", @"MO",
                        @"Montana", @"MT",
                        @"Nebraska", @"NE",
                        @"Nevada", @"NV",
                        @"New Hampshire", @"NH",
                        @"New Jersey", @"NJ",
                        @"New York", @"NY",
                        @"North Carolina", @"NC",
                        @"North Dakota", @"ND",
                        @"Ohio", @"OH",
                        @"Oklahoma", @"OK",
                        @"Oregon", @"OR",
                        @"Pennsylvania", @"PA",
                        @"Rhode Island", @"RI",
                        @"South Carolina", @"SC",
                        @"South Dakota", @"SD",
                        @"Tennessee", @"TN",
                        @"Texas", @"TX",
                        @"Utah", @"UT",
                        @"Vermont", @"VT",
                        @"Virginia", @"VA",
                        @"Washington", @"WA",
                        @"West Virginia", @"WV",
                        @"Wisconsin", @"WI",
                        @"Wyoming", @"WY",
                        nil];
    
    return statesAndAbbrevs;
}


@end
