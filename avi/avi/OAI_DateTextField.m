//
//  OAI_DateTextField.m
//  AVI
//
//  Created by Steve Suranie on 3/29/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_DateTextField.h"

@implementation OAI_DateTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        self.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeyDone;
        self.userInteractionEnabled = YES;
        
        datePicker = [[UIDatePicker alloc]init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
    }
    return self;
}

- (void) setDate : (UIDatePicker*) myDatePicker {
    
    NSDateFormatter* myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString* dateString = [myDateFormatter stringFromDate:myDatePicker.date];
    self.text = dateString;
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
