//
//  OAI_SetTabOrder.h
//  avi
//
//  Created by Steve Suranie on 4/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAI_TextField.h"

@interface OAI_SetTabOrder : NSObject

@property (nonatomic, retain) NSArray* arrAllElements;

- (NSMutableArray*) setTabOrder; 

@end
