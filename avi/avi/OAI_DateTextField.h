//
//  OAI_DateTextField.h
//  AVI
//
//  Created by Steve Suranie on 3/29/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAI_ColorManager.h"

@interface OAI_DateTextField : UITextField {
 
    UIDatePicker* datePicker;
    OAI_ColorManager* colorManager;
}

@property (nonatomic, retain) NSString* myLabel;
@property (nonatomic, retain) NSString* myNumberType;
@property (nonatomic, assign) BOOL isRequired;

- (void) setDate : (UIDatePicker*) myDatePicker;

@end
