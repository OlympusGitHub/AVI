//
//  OAI_Table.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/21/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OAI_ColorManager.h"


@interface OAI_Table : UITableView <UITableViewDataSource, UITableViewDelegate>{
    
    OAI_ColorManager* colorManager;

}

@property (nonatomic, retain) NSArray* tableDataSource;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) NSString* selectedValue;
@property (nonatomic, retain) NSString* elementID;


- (void) buildTable;

@end
