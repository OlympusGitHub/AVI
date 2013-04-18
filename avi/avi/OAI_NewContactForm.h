//
//  OAI_NewContactForm.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/12/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_ColorManager.h"

#import "OAI_TextField.h"
#import "OAI_SimpleCheckbox.h"
#import "OAI_CustomButton.h"

@interface OAI_NewContactForm : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    OAI_ColorManager* colorManager;
    
    NSArray* arrContactTypes;
    NSMutableDictionary* contactData;
    
    OAI_TextField* txtContactName;
    OAI_TextField* txtContactEmail;
    OAI_TextField* txtContactPhone;
    OAI_SimpleCheckbox* mainContactCheck;
    UITableView* tblContactTypes;
    
}

@property (nonatomic, retain) UIView* myParent;
@property (nonatomic, assign) BOOL isEditing; 

- (void) sendNotice : (UIButton*) myButton;

- (NSMutableDictionary*) getContactData;

- (void) populateContact : (NSDictionary*) dictContact;

- (void) resetForm; 

@end
