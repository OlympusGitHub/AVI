//
//  OAI_TextField.h
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"


@interface OAI_TextField : UITextField <UITextFieldDelegate> {
    
     OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* myLabel;
@property (nonatomic, retain) NSString* myNumberType;
@property (nonatomic, retain) NSString* isRequired;
@property (nonatomic, assign) int tabNumber;
@property (nonatomic, assign) OAI_TextField* nextField;

- (void) handleTap : (CGPoint) hitPoint;
@end
