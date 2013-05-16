//
//  OAI_SetTabOrder.m
//  avi
//
//  Created by Steve Suranie on 4/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_SetTabOrder.h"

@implementation OAI_SetTabOrder

- (NSMutableArray*) setTabOrder {
    
    NSMutableArray* arrMasterTabOrder = [[NSMutableArray alloc] init];
    
    for(int i=0; i<_arrAllElements.count; i++) {
        
        if (i<_arrAllElements.count-1) {
        
            if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            
                OAI_TextField* thisTextField = (OAI_TextField*)[_arrAllElements objectAtIndex:i];
                thisTextField.nextField = [_arrAllElements objectAtIndex:i+1];
                
            }
            
        }
    }
    
    
    return arrMasterTabOrder;
    
}

@end
