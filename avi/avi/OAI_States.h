//
//  OAI_States.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/21/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_States : NSObject {
    
    NSArray* states;
    NSDictionary* statesAndAbbrevs;
    
}

- (NSArray* ) getStates;

- (NSDictionary* ) getStatesAndAbbreviations;

@end
