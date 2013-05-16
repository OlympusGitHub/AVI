//
//  OAI_ModalDisplay.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/12/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_ModalDisplay.h"

@implementation OAI_ModalDisplay

@synthesize strModalTitle, strModalTitleBarImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        
        UIView* vModalCorners = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        vModalCorners.layer.cornerRadius = 24.0f;
        vModalCorners.backgroundColor = [UIColor whiteColor];
        vModalCorners.clipsToBounds = YES;
        
        vModalBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vModalCorners.frame.size.width, 80.0)];
        vModalBar.backgroundColor = [colorManager setColor:233.0 :178.0 :38.0];
        vModalBar.layer.shadowColor = [UIColor blackColor].CGColor;
        vModalBar.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        vModalBar.layer.shadowOpacity = .75;
        
        
        lblModalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 200.0, 40.0)];
        lblModalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
        lblModalLabel.text = @"Modal Test";
        lblModalLabel.textColor = [colorManager setColor:51.0 :51.0 :51.0];
        lblModalLabel.backgroundColor = [UIColor clearColor];
        lblModalLabel.textAlignment = NSTextAlignmentCenter;
        [vModalBar addSubview:lblModalLabel];
        
        /*UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"btnCloseX"] forState:UIControlStateNormal];
        [btnClose setFrame:CGRectMake(self.frame.size.width-50.0, self.frame.size.height-50.0, 40.0, 40.0)];
        [btnClose addTarget:self action:@selector(closeWin:) forControlEvents:UIControlEventTouchUpInside];
        [vModalCorners addSubview:btnClose];*/
        
        [vModalCorners addSubview:vModalBar];
        
        [self addSubview:vModalCorners];
    }
    return self;
}

- (void) buildModal {
    
    lblModalLabel.text = strModalTitle;
    CGSize modalTitleSize = [strModalTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
    CGRect lblModalLabelFrame = lblModalLabel.frame;
    lblModalLabelFrame.size.width = modalTitleSize.width;
    lblModalLabelFrame.origin.x = (vModalBar.frame.size.width/2)-(modalTitleSize.width/2);
    lblModalLabel.frame = lblModalLabelFrame;
    
    
    if ([strModalTitle isEqualToString:@"Add Contact"]) {
        
        addContact = [[OAI_NewContactForm alloc] initWithFrame:CGRectMake(20.0, vModalBar.frame.origin.y + vModalBar.frame.size.height+10.0, self.frame.size.width-40.0, self.frame.size.height - vModalBar.frame.size.height)];
        [self addSubview:addContact];
        
    } else if ([strModalTitle isEqualToString:@"Get Contacts"]) {
        
        contactList = [[OAI_ContactList alloc] initWithFrame:CGRectMake(20.0, vModalBar.frame.origin.y + vModalBar.frame.size.height+10.0, self.frame.size.width-40.0, self.frame.size.height - vModalBar.frame.size.height)];
        [self addSubview:contactList];
        
    } else if ([strModalTitle isEqualToString:@"Add Procedure Room"]) {
        addProcedureRoom = [[OAI_OperatingRoomForm alloc] initWithFrame:CGRectMake(20.0, vModalBar.frame.origin.y + vModalBar.frame.size.height+10.0, self.frame.size.width-40.0, self.frame.size.height - vModalBar.frame.size.height)];
        
        addProcedureRoom.vMyParent = _vMyParent;
        [self addSubview:addProcedureRoom];
        
    } else if ([strModalTitle isEqualToString:@"Saved Projects"]) {
        savedProjects = [[OAI_DataList alloc] initWithFrame:CGRectMake(20.0, vModalBar.frame.origin.y + vModalBar.frame.size.height+10.0, self.frame.size.width-40.0, self.frame.size.height - vModalBar.frame.size.height)];
        [self addSubview:savedProjects];
        
    } else if ([strModalTitle isEqualToString:@"Saved Rooms"]) {
        
        savedRooms = [[OAI_ORList alloc] initWithFrame:CGRectMake(20.0, vModalBar.frame.origin.y + vModalBar.frame.size.height+10.0, self.frame.size.width-40.0, self.frame.size.height - vModalBar.frame.size.height)];
        [self addSubview:savedRooms];
        
    }
}

#pragma mark - Title Bar

- (void) reloadTitleBar {
    
    savedRooms.strProjectNumber = _strProjectNumber; 
    [savedRooms reloadTitleBar];
}

#pragma mark - Table Management

- (void) reloadTableData {
    
    if ([strModalTitle isEqualToString:@"Get Contacts"]) {
        contactList.strProjectNumber = _strProjectNumber;
        contactList.arrContactNames = _arrModalTableData;
        [contactList displayContacts];
        
    } else if ([strModalTitle isEqualToString:@"Saved Projects"]) {
        savedProjects.arrDataList = _arrModalTableData;
        [savedProjects showData];
        
    } else if ([strModalTitle isEqualToString:@"Saved Rooms"]) {
        savedRooms.arrORList = _arrModalTableData;
        [savedRooms showData];
    }
}

- (void) resetForm {
    
    if ([strModalTitle isEqualToString:@"Add Contact"]) {
        [addContact resetForm];
    }
}

- (void) clearTableData {
    
    if ([strModalTitle isEqualToString:@"Get Contacts"]) {
        
    } else if ([strModalTitle isEqualToString:@"Saved Projects"]) {
        [savedProjects clearTableData];
    }
    
}

#pragma mark Data Management

- (void) showContactData : (NSDictionary*) dictThisContact {
    
    [addContact populateContact:dictThisContact];
}

- (void) loadORData {
    addProcedureRoom.dictSavedORData = _dictSavedORData;
    [addProcedureRoom loadProcedureRoomData];
}

- (void) loadLocationData {
    
    addProcedureRoom.dictSavedLocation = _dictSavedLocation;
    [addProcedureRoom loadLocationData:nil];
}

#pragma mark - Close

- (void) closeWin : (UIButton*) myButton {
    
    
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
