//
//  OAI_TitleScreen.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TitleScreen.h"

@implementation OAI_TitleScreen

@synthesize strAppTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) buildTitleScreen  {
    
    //init the color manager
    colorManager = [[OAI_ColorManager alloc] init];
    
    //get the size of the title string
    CGSize titleSize = [strAppTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size: 48.0]];
    
    UIView* bottomFill = [[UIView alloc] initWithFrame:CGRectMake(0.0, 705.0, 768.0, 325.0)];
    bottomFill.backgroundColor = [colorManager setColor:8.0 :16.0 :123.0];
    [self addSubview:bottomFill];
    
    UIImageView* imgTitleScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 200.0, 768.0, 510.0)];
    imgTitleScreen.image = [UIImage imageNamed:@"imgENDOALPHA.png"];
    [self addSubview:imgTitleScreen];
    
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 200-(titleSize.height-13.0), titleSize.width, titleSize.height)];
    lblTitle.text = strAppTitle;
    lblTitle.textColor = [colorManager setColor:8.0 :16.0 :123.0];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.layer.shadowColor = [UIColor blackColor].CGColor;
    lblTitle.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    lblTitle.layer.shadowOpacity = .75;
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:48.0];
    
    UIButton* btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnStart setFrame:CGRectMake((self.frame.size.width/2)-100, 100.0, 200.0, 30.0)];
    btnStart.backgroundColor = [colorManager setColor:8.0 :16.0 :123.0];
    [btnStart addTarget:self action:@selector(fadeTitleScreen) forControlEvents:UIControlEventTouchUpInside];
    btnStart.layer.cornerRadius = 16.0f;
    [self addSubview:btnStart];
    
    UILabel* btnLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-100, 100.0, 200.0, 30.0)];
    btnLabel.text = @"Begin";
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.backgroundColor = [UIColor clearColor];
    btnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:btnLabel];
    
    
    [self addSubview:lblTitle];
}

- (void) fadeTitleScreen   {
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
     
        animations:^{
            self.alpha = 0.0;
        }
     
        completion:^ (BOOL finished) {
            
            CGRect myFrame = self.frame;
            myFrame.origin.x = 0-myFrame.size.width;
            myFrame.origin.y = 0-myFrame.size.height;
            self.frame = myFrame;
        }
     ];
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
