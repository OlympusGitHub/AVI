//
//  OAI_ScrollView.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/8/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_ScrollView.h"

@implementation OAI_ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self setShowsHorizontalScrollIndicator:YES];
        [self setShowsVerticalScrollIndicator:NO];
        self.pagingEnabled = YES;
        self.scrollEnabled = NO;
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
