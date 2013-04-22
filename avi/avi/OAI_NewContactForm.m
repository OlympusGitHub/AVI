//
//  OAI_NewContactForm.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/12/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_NewContactForm.h"

@implementation OAI_NewContactForm

@synthesize myParent, isEditing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        contactData = [[NSMutableDictionary alloc] init];
        
        UILabel* lblInstructions = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width-20.0, 60.0)];
        lblInstructions.text = @"Fill out the form below and click the submit button to add a contact to your contact list for this project.";
        lblInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblInstructions.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        lblInstructions.numberOfLines  = 0;
        lblInstructions.lineBreakMode = NSLineBreakByWordWrapping;
        lblInstructions.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblInstructions];
        
        //set up the contacts array
        arrContactTypes = [[NSArray alloc] initWithObjects:@"Select A Contact Type", @"Hospital Management", @"Hospital Project Management", @"Facility Management", @"BioMedical Department", @"IT Department", @"Shipping/Receiving", @"Boom Manufacturer", @"Other/Unknown", nil];
        
        tblContactTypes = [[UITableView alloc] initWithFrame:CGRectMake(10.0, lblInstructions.frame.origin.y + lblInstructions.frame.size.height + 5.0, self.frame.size.width-20.0, 160.0)];
        tblContactTypes.dataSource = self;
        tblContactTypes.delegate = self;
        tblContactTypes.rowHeight = 30.0;
        tblContactTypes.layer.cornerRadius = 3.0;
        tblContactTypes.layer.borderWidth = 1.0;
        [self addSubview:tblContactTypes];
        
        
        txtContactName = [[OAI_TextField alloc] initWithFrame:CGRectMake(10.0, tblContactTypes.frame.origin.y + tblContactTypes.frame.size.height + 10.0, self.frame.size.width-20, 30.0)];
        txtContactName.placeholder = @"Contact Name";
        txtContactName.myLabel = @"Contact Name";
        txtContactName.delegate = self;
        txtContactName.tag = 1;
        [self addSubview:txtContactName];
        
        
        txtContactPhone = [[OAI_TextField alloc] initWithFrame:CGRectMake(10.0, txtContactName.frame.origin.y + txtContactName.frame.size.height + 10.0, self.frame.size.width-20, 30.0)];
        txtContactPhone.placeholder = @"Contact Phone";
        txtContactPhone.myLabel = @"Contact Phone";
        txtContactPhone.delegate = self;
        txtContactPhone.tag = 2;
        [self addSubview:txtContactPhone];
        
        
        txtContactEmail = [[OAI_TextField alloc] initWithFrame:CGRectMake(10.0, txtContactPhone.frame.origin.y + txtContactPhone.frame.size.height + 10.0, self.frame.size.width-20, 30.0)];
        txtContactEmail.placeholder = @"Contact Email";
        txtContactEmail.myLabel = @"Contact Email";
        txtContactEmail.tag = 3;
        txtContactEmail.delegate = self;
        [self addSubview:txtContactEmail];
        
        
        
        /*******checkbox for main contact*********/
        UILabel* lblMainContact = [[UILabel alloc] initWithFrame:CGRectMake(10.0, txtContactEmail.frame.origin.y + txtContactEmail.frame.size.height + 10.0, self.frame.size.width-20, 30.0)];
        lblMainContact.text = @"Set Contact as Main Contact";
        lblMainContact.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblMainContact.font = [UIFont fontWithName:@"Helvetica" size: 18.0];
        lblMainContact.numberOfLines = 0;
        lblMainContact.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblMainContact];
        
        mainContactCheck = [[OAI_SimpleCheckbox alloc] initWithFrame:CGRectMake(self.frame.size.width-50.0, lblMainContact.frame.origin.y, 30.0, 30.0)];
        mainContactCheck.elementID = @"Main Contact Check";
        [mainContactCheck buildCheckBox];
        [self addSubview:mainContactCheck];
        
        
        /***************BUTTONS********************/
        //set up an image to get width and height from
        UIImage* btnImage = [UIImage imageNamed:@"btnSubmitNormal.png"];
        
        UIButton* btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSubmit setImage:btnImage forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonFrame = btnSubmit.frame;
        buttonFrame.origin.x = ((self.frame.size.width/2)/2)-(btnImage.size.width/2);
        buttonFrame.origin.y = mainContactCheck.frame.origin.y + 50.0;
        buttonFrame.size.width = btnImage.size.width;
        buttonFrame.size.height = btnImage.size.height;
        btnSubmit.tag = 701;
        btnSubmit.frame = buttonFrame;
        [self addSubview:btnSubmit];
        
        UIImage* btnCancelImage = [UIImage imageNamed:@"btnCancelNormal.png"];
        
        UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setImage:btnCancelImage forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonCancelFrame = btnCancel.frame;
        buttonCancelFrame.origin.x = (self.frame.size.width/2)-((self.frame.size.width/2)/2)+(btnCancelImage.size.width);
        buttonCancelFrame.origin.y = mainContactCheck.frame.origin.y + 50.0;
        buttonCancelFrame.size.width = btnImage.size.width;
        buttonCancelFrame.size.height = btnImage.size.height;
        btnCancel.frame = buttonCancelFrame;
        btnCancel.tag = 702;
        [self addSubview:btnCancel];
        
    }
    return self;
}

- (void) sendNotice : (UIButton*) myButton {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 701) {
        
       
        if (isEditing) {
            
            [userData setObject:@"Edit Contact Data" forKey:@"Action"];
            
        } else {
            
             [userData setObject:@"Save Contact Data" forKey:@"Action"];
        }
            
        NSMutableDictionary* dictContactData = [self getContactData];
        [userData setObject:dictContactData forKey:@"Contact Data"];
        
    } else { 
        
        [userData setObject:@"Close View" forKey:@"Action"];
        [userData setObject:self.superview forKey:@"View To Hide"];
        
    }
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

- (NSMutableDictionary*) getContactData {
    
    if (txtContactName.text) { 
        [contactData setObject:txtContactName.text forKey:@"Contact Name"];
    }
    
    if (txtContactPhone.text)  { 
        [contactData setObject:txtContactPhone.text forKey:@"Contact Phone"];
    }
    
    if (txtContactEmail.text) { 
        [contactData setObject:txtContactEmail.text forKey:@"Contact Email"];
    }
    
    NSString* isMainContact; 
    if ([mainContactCheck.isChecked isEqualToString:@"YES"]) {
        isMainContact = @"YES";
    } else {
        isMainContact = @"NO";
    }
    
    [contactData setObject:isMainContact forKey:@"Main Contact"];
    
    NSIndexPath* selectedIndexPath = [tblContactTypes indexPathForSelectedRow];
    
    NSString* strContactType;
    if (selectedIndexPath.row != 0) { 
        strContactType = [arrContactTypes objectAtIndex:selectedIndexPath.row];
    } else {
        strContactType = @"Other/Unknown";
    }
    
    [contactData setObject:strContactType forKey:@"Contact Type"];
    
    return contactData;
}

- (void) populateContact : (NSDictionary*) dictContact {
    
    for(NSString* strThisKey in dictContact) {
        
        if ([strThisKey isEqualToString:@"Contact Name"]) {
            txtContactName.text = [dictContact objectForKey:strThisKey];
        } else if ([strThisKey isEqualToString:@"Contact Phone"]) {
            txtContactPhone.text = [dictContact objectForKey:strThisKey];
        } else if ([strThisKey isEqualToString:@"Contact Email"]) {
            txtContactEmail.text = [dictContact objectForKey:strThisKey];
        } else if ([strThisKey isEqualToString:@"Contact Title"]) {
            NSString* strContactTitle = [dictContact objectForKey:strThisKey];
            for(int i=0; i<arrContactTypes.count; i++) {
             
                if ([[arrContactTypes objectAtIndex:i] isEqualToString:strContactTitle]) {
                    NSIndexPath* idxPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [tblContactTypes selectRowAtIndexPath:idxPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                    [[tblContactTypes delegate] tableView:tblContactTypes didSelectRowAtIndexPath:idxPath];
                }
            }
        }
    }
}

- (void) resetForm {
    
    txtContactName.text = @"";
    txtContactEmail.text = @"";
    txtContactPhone.text = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    [tblContactTypes selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    int nextTextField = textField.tag + 1;
    
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTextField];
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrContactTypes.count;
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
    
    cell.textLabel.text = [arrContactTypes objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.row == 0) {
        NSString* strContactTitle = [arrContactTypes objectAtIndex:indexPath.row];
        [contactData setObject:strContactTitle forKey:@"Contact Title"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Contact Title Error"
            message: @"Please select a job title for the contact. If the person's title is unknown or not included in the list select \"Other\"."
           delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
    }
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
