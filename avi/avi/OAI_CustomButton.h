//
//  OAI_CustomButton.h
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/10/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"

@interface OAI_CustomButton : UIView {
    
    OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* strMyButtonTitle;
@property (nonatomic, retain) NSString* strMyButtonImage;
@property (nonatomic, retain) NSString* strMyButtonHighlight;
@property (nonatomic, retain) NSString* strMyAction;
@property (nonatomic, assign) float buttonX;
@property (nonatomic, assign) float buttonY;


- (void) buildButton;

- (void) showView : (UIButton*) btnClicked; 

@end
