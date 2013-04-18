//
//  OAI_LocationList.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_FileManager.h"

@interface OAI_LocationList : UIView <UITableViewDataSource, UITableViewDelegate> {
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    NSString* strLocationListName;
    UITableView* tblLocationList;
}

@property (nonatomic, retain) NSArray* arrLocationList;
@property (nonatomic, retain) NSString* projectNumber;
@property (nonatomic, retain) NSDictionary* dictLocationData;
@property (nonatomic, retain) NSString* strORID;

- (void) showData;

- (void) deleteLocation;

- (void) loadLocation : (UIButton*) myButton;

- (void) confirmDelete : (UIButton*) myButton;

@end
