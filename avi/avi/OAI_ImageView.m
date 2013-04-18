//
//  OAI_ImageView.m
//  IntegrationSiteReport
//
//  Created by Steve Suranie on 12/21/12.
//  Copyright (c) 2012 Olympus. All rights reserved.
//

#import "OAI_ImageView.h"

@implementation OAI_ImageView

@synthesize imageID,imageData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage)];
        
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:imageTap];
        
    }
    return self;
}

- (void) zoomImage {
    
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
