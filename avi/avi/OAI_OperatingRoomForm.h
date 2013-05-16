//
//  OAI_OperatingRoomForm.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/13/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_ScrollView.h"
#import "OAI_TextField.h"
#import "OAI_SimpleCheckbox.h"
#import "OAI_Checkbox.h"
#import "OAI_Switch.h"
#import "OAI_FileManager.h"
#import "OAI_AlertScreen.h"
#import "OAI_ScrollView.h"

#import "OAI_ORList.h"
#import "OAI_LocationList.h"


@interface OAI_OperatingRoomForm : UIView  <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    
    BOOL isExistingRoom;
    BOOL loadingData; 
    
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    OAI_AlertScreen* alertManager;
    OAI_ORList* listManager;
    OAI_LocationList* locationManager;
    OAI_ScrollView* svNav;
    
    OAI_ScrollView* svFormViews;
    CGPoint myScrollViewOrigiOffSet;
    
    NSMutableArray* arrORList;
    NSMutableArray* arrExisitingRooms;
    
    NSMutableDictionary* dictRoomData;
    
    UISegmentedControl* scCeilingOptions;
    UISegmentedControl* scFormOptions;
    
    NSMutableArray* arrImages;
    NSArray* arrLocationData;
    NSArray* arrLocationElementNames;
    NSMutableArray* arrLocationElements;
    NSMutableArray* arrORElements;
    NSArray* arrORLabels;
    
    OAI_TextField* txtProjectNumber;
    OAI_TextField* txtOperatingRoomID;
    
    BOOL overwriteData;
    NSMutableDictionary* saveORData;
    NSDictionary* dictSavedRoomData;
    NSMutableDictionary* parsedORData;
    NSString* strThisORID;
    NSString* strThisLocationID;
    
    UIView* vAddAMonitor;
    NSString* strMonitorType;
    NSMutableArray* arrMonitors;
    UITableView* tblMonitors;
    NSString* strSelectedMonitor;

    
}

@property (nonatomic, retain) NSString* projectNumber;
@property (nonatomic, retain) NSString* strRoomID;
@property (nonatomic, retain) NSMutableArray* arrThumbnails;
@property (nonatomic, retain) NSMutableArray* arrImages;
@property (nonatomic, retain) NSDictionary* dictThisLocation;
@property (nonatomic, retain) NSMutableDictionary* dictRoomData;
@property (nonatomic, retain) UIView* vMyParent;
@property (nonatomic, retain) NSDictionary* dictSavedORData;
@property (nonatomic, retain) NSDictionary* dictSavedLocation;


- (void) sendNotice : (UIButton*) myButton;

- (void) scrollByButton : (UIButton*) myButton;

- (void) saveRoomData : (UIButton*) myButton;

- (void) saveProcedureRoomData;

- (void) loadProcedureRoomData;

- (void) saveLocationData : (UIButton*) myButton;

- (void) saveLocationRoomData;

- (NSMutableDictionary*) parseORData : (NSMutableDictionary* ) dictORData : (NSString*) parseWhat;

- (void) showAlert : (NSString* ) alertTitle : (NSString*) alertMsg : (NSArray*) alertButtons : (BOOL) cancelButtonNil;

- (void) clearForm;

- (void) resetLocationData;

- (void) getLocationData : (UIButton*) myButton;

- (void) loadLocationData : (NSString*) resetWhat;

- (void) setParent : (UIView*) parentView;

- (void) toggleElements;

- (void) checkForProjectNumber;

- (void) checkForORID;

- (void) showMonitorModal : (UIButton*) myButton;

- (void) closeMonitor : (UIButton*) myButton;

- (void) deleteMonitorCheck : (UIButton*) myButton;

- (void) deleteMonitor;


@end
