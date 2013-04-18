//
//  OAI_Checkbox.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"

@interface OAI_Checkbox : UIView {
    
    OAI_ColorManager* colorManager;
    
    UIView* vCheckbox;
    UIImage* imgCheckMark;
    UIImageView* vImgCheckMark;
}

@property (nonatomic, retain) NSString* strCheckboxLabel;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) CGSize checkboxSize;
@property (nonatomic, assign) BOOL hasSpecialRule;
@property (nonatomic, assign) int ruleID;

- (void) buildCheckbox;

- (void) checkboxTapAction : (UIGestureRecognizer*) myTap;

- (OAI_Checkbox*) getCheckbox : (NSArray*) allCheckboxes : (NSString*) strBoxToFind;

- (void) toggleCheckBox : (UIImageView*) thisImageView : (OAI_Checkbox*) myParent;

- (void) turnCheckOn;

- (void) turnCheckOff;


@end
