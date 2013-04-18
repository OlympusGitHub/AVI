//
//  OAI_Checkbox.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_Checkbox.h"

@implementation OAI_Checkbox

@synthesize strCheckboxLabel, isChecked, checkboxSize, hasSpecialRule, ruleID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.userInteractionEnabled = YES;
        
        
                
    }
    return self;
}

- (void) buildCheckbox {
    
    //build checkbox
    vCheckbox = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    vCheckbox.layer.borderWidth = 1.0;
    vCheckbox.layer.borderColor = [colorManager setColor:66.0 :66.0 :66.0].CGColor;
    vCheckbox.userInteractionEnabled = YES;
    
    //tap gesture
    UITapGestureRecognizer* checkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxTapAction:)];
    
    //add the gesture
    [vCheckbox addGestureRecognizer:checkTap];
    
    //build checkbox label
    CGSize checkboxLabelSize = [strCheckboxLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
    UILabel* thisCheckboxLabel = [[UILabel alloc] initWithFrame:CGRectMake(vCheckbox.frame.origin.x + vCheckbox.frame.size.width + 10.0, 0.0, checkboxLabelSize.width, checkboxLabelSize.height)];
    thisCheckboxLabel.text = strCheckboxLabel;
    thisCheckboxLabel.textColor = [colorManager setColor:66.0 :66.0: 66.0];
    thisCheckboxLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    thisCheckboxLabel.backgroundColor = [UIColor clearColor];
    
    checkboxSize = CGSizeMake(checkboxLabelSize.width + 40.0, checkboxLabelSize.height);
    
    //set up check mark image
    imgCheckMark = [UIImage imageNamed:@"checkmark.png"];
    vImgCheckMark = [[UIImageView alloc] initWithImage:imgCheckMark];
        
    //center it
    [vImgCheckMark setFrame:CGRectMake((vCheckbox.frame.size.width/2)-(vImgCheckMark.frame.size.width/2), (vCheckbox.frame.size.height/2)-(vImgCheckMark.frame.size.height/2), vImgCheckMark.frame.size.width, vImgCheckMark.frame.size.height)];
    vImgCheckMark.alpha = 0.0;
        
    [vCheckbox addSubview:vImgCheckMark];
    
    if (isChecked) {
        vImgCheckMark.alpha = 1.0;
    }
    
    [self addSubview:vCheckbox];
    [self addSubview:thisCheckboxLabel];
    
}

- (void) checkboxTapAction : (UIGestureRecognizer*) myTap {
    
    //get the gestures view
    UIView* thisView = myTap.view;
    
    //store all the checkboxes
    UIView* myParent = thisView.superview.superview;
    NSArray* arrAlLChecksboxes = myParent.subviews;
    
    //get its subviews
    NSArray* arrCheckboxSubs = thisView.subviews;
    
    //get the imageview
    UIImageView* theImage = [arrCheckboxSubs objectAtIndex:0];
    
    //needs a check mark
    if (theImage.alpha == 0.0) {
        
        //check to see if this checkbox has special rules
        if(hasSpecialRule) {
           
            //check to see what the rule is
            
            
            //UCES/AVP/UCES+ RULE
            if (ruleID == 1) {
                
                
                if ([strCheckboxLabel isEqualToString:@"UCES"] || [strCheckboxLabel isEqualToString:@"AVP"]) {
                    
                    OAI_Checkbox* thisCheckbox = [self getCheckbox:arrAlLChecksboxes :@"UCES+"];
                            
                    //get it's state
                    if (thisCheckbox.isChecked == YES) {
                                
                        NSArray* checkBoxWrapper = thisCheckbox.subviews;
                        UIView* vCheckBox = [checkBoxWrapper objectAtIndex:0];
                        NSArray* arrCheckBoxItems = vCheckBox.subviews;
                        
                        UIImageView* vImgMyheckMark = [arrCheckBoxItems objectAtIndex:0];
                        vImgMyheckMark.alpha = 0.0;
                        thisCheckbox.isChecked = NO;
                    }
                            
                } else if ([strCheckboxLabel isEqualToString:@"UCES+"]) {
                    
                    NSMutableArray* arrOtherCheckboxes = [[NSMutableArray alloc] init];
                    
                    [arrOtherCheckboxes addObject:[self getCheckbox:arrAlLChecksboxes :@"UCES"]];
                    [arrOtherCheckboxes addObject:[self getCheckbox:arrAlLChecksboxes :@"AVP"]];
                    
                    for(int x=0; x<arrOtherCheckboxes.count; x++) {
                        
                        OAI_Checkbox* thisCheckbox = [arrOtherCheckboxes objectAtIndex:x];
                        
                        //get it's state
                        if (thisCheckbox.isChecked == YES) {
                            
                            NSArray* checkBoxWrapper = thisCheckbox.subviews;
                            UIView* vCheckBox = [checkBoxWrapper objectAtIndex:0];
                            NSArray* arrCheckBoxItems = vCheckBox.subviews;
                            
                            UIImageView* vImgMyheckMark = [arrCheckBoxItems objectAtIndex:0];
                            vImgMyheckMark.alpha = 0.0;
                            thisCheckbox.isChecked = NO;
                        }
                        
                    }
                }
            
            } else {
                
                //HD/SD RECORDING RULE
                if ([strCheckboxLabel isEqualToString:@"HD Recording"]) {
                    
                    OAI_Checkbox* thisCheckbox = [self getCheckbox:arrAlLChecksboxes :@"SD Recording"];
                    
                    //get it's state
                    if (thisCheckbox.isChecked == YES) {
                        
                        NSArray* checkBoxWrapper = thisCheckbox.subviews;
                        UIView* vCheckBox = [checkBoxWrapper objectAtIndex:0];
                        NSArray* arrCheckBoxItems = vCheckBox.subviews;
                        
                        UIImageView* vImgMyheckMark = [arrCheckBoxItems objectAtIndex:0];
                        vImgMyheckMark.alpha = 0.0;
                        thisCheckbox.isChecked = NO;
                    }
                    
                } else if ([strCheckboxLabel isEqualToString:@"SD Recording"]) {
                    
                    OAI_Checkbox* thisCheckbox = [self getCheckbox:arrAlLChecksboxes :@"HD Recording"];
                    
                    //get it's state
                    if (thisCheckbox.isChecked == YES) {
                        
                        NSArray* checkBoxWrapper = thisCheckbox.subviews;
                        UIView* vCheckBox = [checkBoxWrapper objectAtIndex:0];
                        NSArray* arrCheckBoxItems = vCheckBox.subviews;
                        
                        UIImageView* vImgMyheckMark = [arrCheckBoxItems objectAtIndex:0];
                        vImgMyheckMark.alpha = 0.0;
                        thisCheckbox.isChecked = NO;
                    }

                    
                }
            }
                    
        }
        
        theImage.alpha = 1.0;
        
        //change the state
        OAI_Checkbox* thisCheckbox = [self getCheckbox:arrAlLChecksboxes :strCheckboxLabel];
        thisCheckbox.isChecked = YES;
        
    } else {
        
        //hide the check mark
        theImage.alpha = 0.0;
        
        //change the state
        OAI_Checkbox* thisCheckbox = [self getCheckbox:arrAlLChecksboxes :strCheckboxLabel];
        thisCheckbox.isChecked = NO;
    }
    
    
    
}

- (void) turnCheckOn  {
    
    NSArray* mySubviews = self.subviews;
    
    for(int i=0; i<mySubviews.count; i++) {
     
        if ([[mySubviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
            
            UIView* box = [mySubviews objectAtIndex:i];
            NSArray* arrBoxSubviews = box.subviews;
            
            if (arrBoxSubviews.count > 0) { 
                UIImageView* theCheckmark = [arrBoxSubviews objectAtIndex:0];
                theCheckmark.alpha = 1.0;
                self.isChecked = YES;
            }
        }
    }
    
}

- (void) turnCheckOff  {
    
    NSArray* mySubviews = self.subviews;
    
    for(int i=0; i<mySubviews.count; i++) {
        
        if ([[mySubviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
            
            UIView* box = [mySubviews objectAtIndex:i];
            NSArray* arrBoxSubviews = box.subviews;
            
            if (arrBoxSubviews.count > 0) { 
                UIImageView* theCheckmark = [arrBoxSubviews objectAtIndex:0];
                theCheckmark.alpha = 0.0;
                self.isChecked = NO;
            }
        }
    }
}

- (OAI_Checkbox*) getCheckbox : (NSArray*) allCheckboxes : (NSString*) strBoxToFind {
    
    //check to see if UCES+ is checked and uncheck if is
    for(int c=0; c<allCheckboxes.count; c++) {
        
        //get the uces+ checkbox
        if ([[allCheckboxes objectAtIndex:c] isMemberOfClass:[OAI_Checkbox class]]) {
            
            OAI_Checkbox* thisCheckbox = (OAI_Checkbox*)[allCheckboxes objectAtIndex:c];
            
            if ([thisCheckbox.strCheckboxLabel isEqualToString:strBoxToFind]) {
             
                return thisCheckbox;
            }

        }
    }
    
    return 0;
    
}

- (void) toggleCheckBox : (UIImageView*) thisImageView : (OAI_Checkbox*) myParent {
    
    //get state
    if(thisImageView.alpha == 1.0) {
        
        //hide it
        thisImageView.alpha = 0.0;
        
        //reset state
        myParent.isChecked = NO;
        
    } else {
        
        //show it
        thisImageView.alpha = 1.0;
        
        myParent.isChecked = YES;
        
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
