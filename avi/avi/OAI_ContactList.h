//
//  OAI_ContactList.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/13/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"

@interface OAI_ContactList : UIView <UITableViewDataSource, UITableViewDelegate>{
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    UITableView* tblContacts;
    NSString* strContactName;
    
}

@property (nonatomic, retain) NSMutableArray* arrContactNames;
@property (nonatomic, retain) NSDictionary* dictContacts;
@property (nonatomic, retain) NSString* strProjectNumber;

- (void) sendNotice : (UIButton*) myButton;

- (void) displayContacts;

- (void) deleteContact;





@end
