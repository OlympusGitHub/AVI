//
//  OAI_DataManager.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/17/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAI_FileManager.h"

#import "OAI_Table.h"
#import "OAI_TextField.h"
#import "OAI_Switch.h"
#import "OAI_SimpleCheckbox.h"
#import "OAI_Checkbox.h"
#import "OAI_States.h"
#import "OAI_TextView.h"


@interface OAI_DataManager : NSObject <UIAlertViewDelegate> {
 
    OAI_FileManager* fileManager;
    NSArray* arrStates;
    BOOL contactDataSaved;
    BOOL overwriteData;
    NSDictionary* dictMyContactData;
    
}

@property (nonatomic, retain) NSMutableDictionary* projectData;
@property (nonatomic, retain) NSMutableArray* arrRequiredElements;
@property (nonatomic, retain) NSMutableArray* arrAllElements;
@property (nonatomic, retain) NSString* strProjectNumber;
@property (nonatomic, retain) UIView* vMyParent;

+(OAI_DataManager* )sharedDataManager;

- (NSMutableDictionary*) getData : (NSString*) strProjectID : (NSString*) strDataToGet;

- (NSMutableArray*) buildData : (NSArray*) arrSections;

- (BOOL) saveData : (NSString*) projectNumber;

- (BOOL) checkContactData : (NSDictionary*) dictContactData : (NSString*) strProjectID;

- (BOOL) saveContactData : (NSDictionary*) dictContactData : (NSString*) strProjectID : (BOOL) canOverwrite;

- (BOOL) deleteContact : (NSString*) strContactName;

- (NSString*) getDocsDirectory;


@end
