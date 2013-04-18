//
//  OAI_ORList.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"


@interface OAI_ORList : UIView  <UITableViewDataSource, UITableViewDelegate> {
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    NSString* strORListName;
    UITableView* tblORList;
}

@property (nonatomic, retain) NSArray* arrORList;
@property (nonatomic, retain) NSString* projectNumber;
@property (nonatomic, retain) NSDictionary* dictORData;

- (void) sendNotice : (UIButton*) myButton;

- (void) showData;

- (void) deleteRoom;

- (void) loadRoom : (UIButton*) myButton;

- (void) resetFormTabs;


@end
