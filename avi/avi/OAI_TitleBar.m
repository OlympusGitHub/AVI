//
//  OAI_TitleBar.m
//  AVI Site Integration
//
//  Created by Steve Suranie on 3/7/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TitleBar.h"

@implementation OAI_TitleBar

@synthesize titleBarTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        //shadow
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.75;
        
    }
    return self;
}


#pragma mark - Build Title Bar

- (void) buildTitleBar { 
        
    //set olympus logo
    UIImageView* OALogoTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OA_logo_black_topbar.png"]];
    
    //position the logo
    CGRect topBarLogoFrame = OALogoTopBar.frame;
    topBarLogoFrame.origin.x = 15.0;
    topBarLogoFrame.origin.y = 8.0;
    OALogoTopBar.frame = topBarLogoFrame;
    
    //add the logo
    [self addSubview:OALogoTopBar];
    
    //add the toggle account data button
    UIImage* imgAccount = [UIImage imageNamed:@"btnAccount.png"];
    UIButton* btnAccount = [[UIButton alloc] initWithFrame:CGRectMake(OALogoTopBar.frame.origin.x+OALogoTopBar.frame.size.width + 20.0, 4.0, imgAccount.size.width, imgAccount.size.height)];
    [btnAccount setImage:imgAccount forState:UIControlStateNormal];
    [btnAccount addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
    btnAccount.tag = 105;
    [btnAccount setBackgroundColor:[UIColor clearColor]];
    [self addSubview:btnAccount];
    
    /*UIButton* btnLoadData = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLoadData setImage:[UIImage imageNamed:@"btnLoadData.png"] forState:UIControlStateNormal];
    [btnLoadData setFrame:CGRectMake(btnAccount.frame.origin.x + btnAccount.frame.size.width, btnAccount.frame.origin.y-4.0, 40.0, 40.0)];
    [btnLoadData addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
    btnLoadData.tag = 104;
    [self addSubview:btnLoadData];*/
    
    //add title bar title
    CGSize titleSize = [titleBarTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    
    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-(titleSize.width+10.), 8.0, titleSize.width, titleSize.height)];
    lblTitle.text = titleBarTitle;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [self addSubview:lblTitle];
    
}

#pragma mark - Send Notice
- (void) sendNotice : (UIButton*) myButton {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 104) {
        [userData setObject:@"Show View" forKey:@"Action"];
        [userData setObject:@"Saved Projects" forKey:@"View To Show"];
   
    } else if (myButton.tag == 105) {
        
        [userData setObject:@"Show View" forKey:@"Action"];
        [userData setObject:@"Account" forKey:@"View To Show"];
        
    }
    
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
