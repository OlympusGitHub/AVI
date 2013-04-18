//
//  OAI_TextView.m
//  avi
//
//  Created by Steve Suranie on 4/15/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_TextView.h"

@implementation OAI_TextView

@synthesize isRequired, myLabel, myNumberType;

- (id)initWithFrame:(CGRect)frame


{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        self.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.backgroundColor = [UIColor whiteColor];
        self.returnKeyType = UIReturnKeyDone;
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 2.0;
        self.clipsToBounds = YES;
        
    }
    return self;
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
