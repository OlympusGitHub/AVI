//
//  OAI_MailManger.h
//  avi
//
//  Created by Steve Suranie on 4/17/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAI_MailManager : NSObject

@property (nonatomic, retain) NSDictionary* dictProjectData;
@property (nonatomic, retain) NSMutableArray* arrAllElements;
@property (nonatomic, retain) NSString* strProjectNumber;

+(OAI_MailManager* )sharedMailManager;

- (NSMutableString*) composeMailBody;

@end
