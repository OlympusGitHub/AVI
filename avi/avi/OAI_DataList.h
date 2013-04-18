//
//  OAI_DataList.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/18/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"
#import "OAI_DataManager.h"

@interface OAI_DataList : UIView <UITableViewDataSource, UITableViewDelegate> {
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    OAI_DataManager* dataManager;
    
    NSString* strDataListName;
    UITableView* tblDataList;
}

@property (nonatomic, retain) NSMutableArray* arrDataList;
@property (nonatomic, retain) NSString* projectNumber;


- (void) sendNotice : (UIButton*) myButton;

- (void) showData;

- (void) clearTableData;

- (void) deleteProject;

- (void) loadData : (UIButton*) myButton;

@end
