//
//  OAI_TextView.h
//  avi
//
//  Created by Steve Suranie on 4/15/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OAI_ColorManager.h"

@interface OAI_TextView : UITextView {
    
    OAI_ColorManager* colorManager;
}


@property (nonatomic, retain) NSString* myLabel;
@property (nonatomic, retain) NSString* myNumberType;
@property (nonatomic, retain) NSString* isRequired;

@end
