//
//  OAI_CustomButton.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/10/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_CustomButton.h"

@implementation OAI_CustomButton

@synthesize strMyButtonImage, strMyButtonTitle, strMyButtonHighlight, strMyAction, buttonX, buttonY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void) buildButton {
        
    UIImage* imgBtnImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", strMyButtonImage]];
    
    float frameH;
    CGSize btnTitleSize;
    if(strMyButtonTitle) { 
        
        btnTitleSize = [strMyButtonTitle sizeWithFont:[UIFont fontWithName:@"Helvetica"  size: 18.0]];
        frameH = imgBtnImage.size.height + btnTitleSize.height + 10.0;
        
    } else {
        
        frameH = imgBtnImage.size.height + 10.0;
        
    }
    
    //reset the frame
    CGRect myFrame = self.frame;
    myFrame.origin.x = buttonX;
    myFrame.origin.y = buttonY;
    myFrame.size.height = frameH;
    self.frame = myFrame;
    
    UIButton* btnMyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMyButton setImage:imgBtnImage forState:UIControlStateNormal];
    [btnMyButton setFrame:CGRectMake(0.0, 0.0, imgBtnImage.size.width, imgBtnImage.size.height)];
    [btnMyButton addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    btnMyButton.userInteractionEnabled = YES;
    [btnMyButton setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:btnMyButton];
    
    
    if(strMyButtonTitle) { 
        UILabel* lblBtnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, btnMyButton.frame.origin.y + btnMyButton.frame.size.height, btnTitleSize.width, btnTitleSize.height)];
        lblBtnTitle.text = strMyButtonTitle;
        lblBtnTitle.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblBtnTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:lblBtnTitle];
    }
    
    [self bringSubviewToFront:btnMyButton];
        
}

- (void) showView : (UIButton*) btnClicked {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:strMyAction forKey:@"Action"];
    [userData setObject:strMyButtonTitle forKey:@"Button Title"];
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
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
