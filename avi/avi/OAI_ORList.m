//
//  OAI_ORList.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_ORList.h"

@implementation OAI_ORList

@synthesize arrORList, projectNumber, dictORData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        fileManager = [[OAI_FileManager alloc] init];
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        self.layer.shadowOpacity = .75;
        
        arrORList = [[NSMutableArray alloc] init];
        
        UILabel* lblORData = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 30.0, self.frame.size.width-60.0, 60.0)];
        lblORData.text = [NSString stringWithFormat:@"Operating Room Data For Project: %@", projectNumber];
        lblORData.textColor = [colorManager setColor:8.0 :16.0 :123.0];
        lblORData.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
        lblORData.backgroundColor = [UIColor clearColor];
        lblORData.numberOfLines = 0;
        lblORData.lineBreakMode = NSLineBreakByWordWrapping;
        lblORData.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblORData];
        
        tblORList = [[UITableView alloc]  initWithFrame:CGRectMake((self.frame.size.width/2)-125.0, (self.frame.size.height/2)-200.0, 250.0, 400.0)];
        tblORList.delegate = self;
        tblORList.dataSource = self;
        tblORList.layer.borderWidth = 1.0;
        tblORList.rowHeight = 30.0;
        [self addSubview:tblORList];
        
        UIButton* btnUploadData = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUploadData setImage:[UIImage imageNamed:@"btnUploadNormal.png"] forState:UIControlStateNormal];
        [btnUploadData setFrame:CGRectMake(tblORList.frame.origin.x, tblORList.frame.origin.y + tblORList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnUploadData addTarget:self action:@selector(loadRoom:) forControlEvents:UIControlEventTouchUpInside];
        btnUploadData.tag = 301;
        [self addSubview:btnUploadData];
        
        UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setImage:[UIImage imageNamed:@"btnDeleteIconNormal"] forState:UIControlStateNormal];
        [btnDelete setFrame:CGRectMake(btnUploadData.frame.origin.x + btnUploadData.frame.size.width + 10.0, tblORList.frame.origin.y + tblORList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnDelete addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        btnDelete.tag = 302;
        [self addSubview:btnDelete];
        
        UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"btnCloseX"] forState:UIControlStateNormal];
        [btnClose setFrame:CGRectMake(self.frame.size.width-40.0, self.frame.size.height-40.0, 40.0, 40.0)];
        [btnClose addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        btnClose.tag = 303;
        [self addSubview:btnClose];

    }
    return self;
}

- (void) sendNotice : (UIButton*) myButton {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 301) {
        //load data
    } else if (myButton.tag == 302) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Delete Request."
                message: [NSString stringWithFormat:@"Please confirm you want to delete the operating room: %@\nThis will also delete it's associated locations.", strORListName]
               delegate: self
      cancelButtonTitle: nil
      otherButtonTitles: @"Confirm", @"Cancel", nil];
        alert.tag = 911;
        [alert show];

        
    } else if (myButton.tag == 303) {
        
        //reset form tabs
        [self resetFormTabs];
        
        //close view
        [UIView
             animateWithDuration:0.5
             delay:0.0
             options:UIViewAnimationOptionCurveEaseIn
             animations:^{
                 
             self.alpha = 0.0;
             }
             
             completion:^ (BOOL finished){
                 [self setFrame:CGRectMake(-350, -600, self.frame.size.width, self.frame.size.height)];
             }
         ];
        
        
        [userData setObject:@"Reset ORSC" forKey:@"Action"];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

- (void) showData {
    
    [tblORList reloadData];
}

- (void) loadRoom : (UIButton*) myButton {
    
    if(!strORListName) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Load Room Error!."
            message: @"You did not select a room to load."
           delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        //reset form tabs
        [self resetFormTabs];
        
        NSDictionary* dictThisOR = [dictORData objectForKey:strORListName];
        
        //calling notification center
        NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
        
        [userData setObject:@"Load OR" forKey:@"Action"];
        [userData setObject:dictThisOR forKey:@"OR Data"];
        
        /*This is the call back to the notification center, */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
        
    }
    
}


- (void) deleteRoom {
    
    //make new dictionaries for ors 
    NSMutableDictionary* dictOperatingRooms = [[NSMutableDictionary alloc]init];
    
    //set the new data (remove the deleted OR)
    for(NSString* strThisKey in dictORData) {
        
        if (![strThisKey isEqualToString:strORListName]) {
            NSDictionary* dictThisOR = [dictORData objectForKey:strThisKey];
            [dictOperatingRooms setObject:dictThisOR forKey:strThisKey];
        }
    }
    
    //write the new plist file
    NSString* strORFile = [NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber];
    [fileManager writeToPlist:strORFile :dictOperatingRooms];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Operating Room Deleted."
                message: [NSString stringWithFormat:@"The operating room %@ has been deleted.", strORListName]
               delegate: self
      cancelButtonTitle: @"OK"
      otherButtonTitles: nil];
    [alert show];
    
    
    //go through the location plist and remove any locations associated with the room
    NSString* pathToLocations =[NSString stringWithFormat:@"%@/Locations.plist", projectNumber];
    
    //get the plist contents
    NSDictionary* dictLocations = [fileManager readPlist:pathToLocations];
    //set up a new dictionary to hold the data
    NSMutableDictionary* newLocationData = [[NSMutableDictionary alloc] init];
    
    //loop through the plist contents and delete the ones associated with the deleted OR
    for(NSString* strThisKey in dictLocations) {
        
        if(![strThisKey isEqualToString:strORListName]) {
            [newLocationData setObject:[dictLocations objectForKey:strThisKey] forKey:strThisKey];
        }
    }
    
    //write the new locations plist
    [fileManager writeToPlist:pathToLocations :newLocationData];
    
    //relaod the table data
    dictORData = [fileManager readPlist:strORFile];
    arrORList = dictORData.allKeys;
    [tblORList reloadData];
    
    //reset form tabs
    [self resetFormTabs];
    
    
}

- (void) resetFormTabs {
 
    //reset the tabs on the parent view
    UIView* myParent = self.superview;
    NSArray* arrSubviews = myParent.subviews;
    
    UISegmentedControl* scFormOptions = (UISegmentedControl*)[arrSubviews objectAtIndex:1];
    scFormOptions.selectedSegmentIndex = -1;
}

#pragma mark - Alert Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 911) {
        if (buttonIndex == 0) {
            [self deleteRoom];
        }
    }
}


#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrORList.count;
    
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
    
    cell.textLabel.text = [arrORList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    strORListName = [arrORList objectAtIndex:indexPath.row];
    
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
