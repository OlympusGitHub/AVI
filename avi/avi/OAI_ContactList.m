//
//  OAI_ContactList.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/13/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_ContactList.h"

@implementation OAI_ContactList

@synthesize arrContactNames, dictContacts;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        fileManager = [[OAI_FileManager alloc] init];
        
        NSString* strInstructions = @"Select a name from the table below to view that person's profile.";
        CGSize instrSize = [strInstructions sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0] constrainedToSize:CGSizeMake(self.frame.size.width-20.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* lblInstructions = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, self.frame.size.width-20.0, instrSize.height)];
        lblInstructions.text = strInstructions;
        lblInstructions.numberOfLines = 0;
        lblInstructions.lineBreakMode = NSLineBreakByWordWrapping;
        lblInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblInstructions.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        lblInstructions.backgroundColor = [UIColor clearColor];
        [self addSubview:lblInstructions];
        
        tblContacts = [[UITableView alloc] initWithFrame:CGRectMake(10.0, lblInstructions.frame.origin.y + lblInstructions.frame.size.height + 20.0, self.frame.size.width-20.0, 200.0)];
        tblContacts.delegate = self;
        tblContacts.dataSource = self;
        tblContacts.layer.borderWidth = 1.0;
        tblContacts.rowHeight = 30.0;
        [self addSubview:tblContacts];
        
        /***************BUTTONS********************/
        
        UIButton* btnDeleteContact = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteContact setImage:[UIImage imageNamed:@"btnDeleteIconNormal.png"] forState:UIControlStateNormal];
        [btnDeleteContact setFrame:CGRectMake(30.0, tblContacts.frame.origin.y + tblContacts.frame.size.height + 20.0, 40.0, 40.0)];
        [btnDeleteContact addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        btnDeleteContact.tag = 999;
        [self addSubview:btnDeleteContact];
        
        //set up an image to get width and height from
        UIImage* btnImage = [UIImage imageNamed:@"btnSubmitNormal.png"];
        
        UIButton* btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSubmit setImage:btnImage forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonFrame = btnSubmit.frame;
        buttonFrame.origin.x = ((self.frame.size.width/2)/2)-(btnImage.size.width/2);
        buttonFrame.origin.y = btnDeleteContact.frame.origin.y + btnDeleteContact.frame.size.height + 20.0;
        buttonFrame.size.width = btnImage.size.width;
        buttonFrame.size.height = btnImage.size.height;
        btnSubmit.frame = buttonFrame;
        btnSubmit.tag = 701;
        [self addSubview:btnSubmit];
        
        UIImage* btnCancelImage = [UIImage imageNamed:@"btnCancelNormal.png"];
        
        UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setImage:btnCancelImage forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonCancelFrame = btnCancel.frame;
        buttonCancelFrame.origin.x = (self.frame.size.width/2)-((self.frame.size.width/2)/2)+(btnCancelImage.size.width);
        buttonCancelFrame.origin.y = btnDeleteContact.frame.origin.y + btnDeleteContact.frame.size.height + 20.0;
        buttonCancelFrame.size.width = btnImage.size.width;
        buttonCancelFrame.size.height = btnImage.size.height;
        btnCancel.frame = buttonCancelFrame;
        btnCancel.tag = 702;
        [self addSubview:btnCancel];

        
    }
    return self;
}

- (void) displayContacts {
    
    [tblContacts reloadData];
}



#pragma mark - Notification Method

- (void) sendNotice : (UIButton*) myButton {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 701) {
                
        //make sure the user has selected a contact
        if (strContactName.length == 0) {
            [self showAlert:@"Contact Data Error!" :@"You did not select a contact name!" :nil :NO];
            
        } else {
            
    
            NSString* strContactFilePath = [NSString stringWithFormat:@"%@/Contacts.plist", _strProjectNumber];
            NSDictionary* dictContactsData = [fileManager readPlist:strContactFilePath];
            NSDictionary* dictThisContact;
            
            for(NSString* strStoredContactName in dictContactsData) {
                
                if ([strContactName isEqualToString:strStoredContactName]) {
                    dictThisContact = [dictContactsData objectForKey:strContactName];
                }
            }
            
            
            [userData setObject:@"Show Contact Data" forKey:@"Action"];
            [userData setObject:dictThisContact forKey:@"Contact Data"];
            [userData setObject:@"Edit Contact" forKey:@"Contact Action"];
            
            //reset selected contact
            strContactName = nil;
        }
        
    } else if (myButton.tag == 999) {
        if (strContactName.length == 0) {
            [self showAlert:@"Contact Data Error!" :@"You did not select a contact name!" :nil :NO];
        } else {
            
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Confirm Delete Contact" message:[NSString stringWithFormat:@"Please confirm that you wish to delete the contact:%@", strContactName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
            
            alert.tag = 411;
            [alert show];
            
        }
    } else {
        
        //deselect any table selections
        /*NSIndexPath* nilPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tblContacts selectRowAtIndexPath:nilPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];*/
        
        [userData setObject:@"Close View" forKey:@"Action"];
        [userData setObject:self.superview forKey:@"View To Hide"];
    }
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

- (void) deleteContact {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:@"Delete Contact Data" forKey:@"Action"];
    [userData setObject:strContactName forKey:@"Contact Name"];
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

#pragma mark - Show Alert

- (void) showAlert : (NSString* ) alertTitle : (NSString*) alertMsg : (NSArray*) alertButtons : (BOOL) cancelButtonNil {
    
    NSString* strCancelBtn;
    if (cancelButtonNil) {
        strCancelBtn = nil;
    } else {
        strCancelBtn = @"OK";
    }
    
    NSMutableString* strOtherButtons = [[NSMutableString alloc] initWithString:@""];
    if (alertButtons.count > 0) {
        for(int i=0; i<alertButtons.count; i++) {
            [strOtherButtons appendString:[NSString stringWithFormat:@"%@, ", [alertButtons objectAtIndex:i]]];
        }
        [strOtherButtons appendString:nil];
    } else {
        strOtherButtons = nil;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
                                                    message: alertMsg
                                                   delegate: self
                                          cancelButtonTitle: strCancelBtn
                                          otherButtonTitles: nil];
    
    [alert show];
    
}

#pragma mark Alert Methods
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 411) {
        if (buttonIndex == 0){
            [self deleteContact];
        } else {
            
            NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
            
            [userData setObject:@"Close View" forKey:@"Action"];
            [userData setObject:self.superview forKey:@"View To Hide"];
            
            /*This is the call back to the notification center, */
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
        }
    }
}



#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrContactNames.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //alternate row colors
    if (indexPath.row % 2) {
        cell.backgroundColor = [colorManager setColor:193 :230 :249];
    } else {
        cell.backgroundColor = [colorManager setColor:238 :238 :238];
    }
    
    cell.textLabel.text = [arrContactNames objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    strContactName = [arrContactNames objectAtIndex:indexPath.row];
    
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
