//
//  OAI_ModalDisplay.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/12/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"
#import "OAI_NewContactForm.h"
#import "OAI_OperatingRoomForm.h"
#import "OAI_ContactList.h"
#import "OAI_DataList.h"

#import "OAI_TextField.h"

@interface OAI_ModalDisplay : UIView {
    
    OAI_ColorManager* colorManager;
    UIColor* clrOlympusYellow;
    UILabel* lblModalLabel;
    UIView* vModalBar;
    
    OAI_DataList* savedProjects;
    OAI_OperatingRoomForm* addProcedureRoom;
    OAI_ContactList* contactList;
    OAI_NewContactForm* addContact;
    
    
}

@property (nonatomic, retain) NSString* strModalTitle;
@property (nonatomic, retain) NSString* strModalTitleBarImage;
@property (nonatomic, retain) NSDictionary* modalFormData;
@property (nonatomic, retain) NSMutableArray* arrModalTableData;
@property (nonatomic, retain) NSString* strProjectNumber;
@property (nonatomic, retain) UIView* vMyParent;
@property (nonatomic, retain) NSDictionary* dictSavedORData;
@property (nonatomic, retain) NSDictionary* dictSavedLocation;


- (void) buildModal;

- (void) reloadTableData;

- (void) clearTableData;

- (void) closeWin : (UIButton*) myButton;

- (void) resetForm;

- (void) showContactData : (NSDictionary*) dictThisContact;

- (void) loadORData;

- (void) loadLocationData;

@end
