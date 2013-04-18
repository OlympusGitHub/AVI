//
//  OAI_ImageView.h
//  IntegrationSiteReport
//
//  Created by Steve Suranie on 12/21/12.
//  Copyright (c) 2012 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OAI_ImageView : UIImageView

@property (nonatomic, retain) NSString* imageID;
@property (nonatomic, retain) NSMutableDictionary* imageData;

@end
