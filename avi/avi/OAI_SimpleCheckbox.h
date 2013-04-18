//
//  OAI_SimpleCheckbox.h
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/25/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"

@interface OAI_SimpleCheckbox : UIView <UIGestureRecognizerDelegate>{
    
    OAI_ColorManager* colorManager;
    UIView* box;

}

@property (nonatomic, retain) NSString* isChecked;
@property (nonatomic, retain) NSString* elementID;


- (void) buildCheckBox;

- (void) toggleCheckImage : (UIGestureRecognizer*) theTouch;

- (void) turnCheckOff;

- (void) turnCheckOn;

@end
