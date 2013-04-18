//
//  OAI_SimpleCheckbox.m
//  OAI_IntegrationSiteReport_v1
//
//  Created by Steve Suranie on 11/25/12.
//  Copyright (c) 2012 Steve Suranie. All rights reserved.
//

#import "OAI_SimpleCheckbox.h"

@implementation OAI_SimpleCheckbox

@synthesize isChecked, elementID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        colorManager = [[OAI_ColorManager alloc] init];
    }
    return self;
}

- (void) buildCheckBox {
    
    box = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    box.layer.borderWidth = 1.0;
    box.layer.borderColor = [UIColor blackColor].CGColor;
    box.backgroundColor = [UIColor whiteColor];
    
    //tap gesture
    UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCheckImage:)];
    sectionTap.delegate = self;
    
    //add the gesture
    [box addGestureRecognizer:sectionTap];
    
    isChecked = @"NO";
    
    [self addSubview:box];
}

- (void) toggleCheckImage : (UIGestureRecognizer*) theTouch {
    
    UIView* thisBox = theTouch.view;
    NSArray* boxSubviews = thisBox.subviews;
    
    //add check image
    UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    
    //center the checkmark
    CGRect checkMarkFrame = checkMark.frame;
    checkMarkFrame.origin.x = (thisBox.frame.size.width/2) - (checkMarkFrame.size.width/2);
    checkMarkFrame.origin.y = (thisBox.frame.size.height/2) - (checkMarkFrame.size.height/2);
    checkMark.frame = checkMarkFrame;

    
    if (boxSubviews.count == 1) {
        //checkbox is checked
        UIImageView* checkMark = [boxSubviews objectAtIndex:0];
        [checkMark removeFromSuperview];
        isChecked = @"NO";
    } else {
        [box addSubview:checkMark];
        isChecked = @"YES";
    }

}

- (void) turnCheckOff {
    
    NSArray* boxSubviews = box.subviews;
    
    //checkbox is checked
    if ([isChecked isEqualToString:@"YES"]) {
        UIImageView* checkMark = [boxSubviews objectAtIndex:0];
        [checkMark removeFromSuperview];
        isChecked = @"NO";
    }
    
}

- (void) turnCheckOn {
    
    //checkbox is checked
    if ([isChecked isEqualToString:@"NO"]) {
        UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        //center the checkmark
        CGRect checkMarkFrame = checkMark.frame;
        checkMarkFrame.origin.x = (box.frame.size.width/2) - (checkMarkFrame.size.width/2);
        checkMarkFrame.origin.y = (box.frame.size.height/2) - (checkMarkFrame.size.height/2);
        checkMark.frame = checkMarkFrame;
        [box addSubview:checkMark];
        isChecked = @"YES";
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
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
