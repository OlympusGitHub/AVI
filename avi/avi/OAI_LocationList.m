//
//  OAI_LocationList.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/19/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_LocationList.h"

@implementation OAI_LocationList

@synthesize arrLocationList, projectNumber, dictLocationData, strORID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        fileManager = [[OAI_FileManager alloc] init];
        colorManager = [[OAI_ColorManager alloc] init];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        self.layer.shadowOpacity = .75;
        
        arrLocationList = [[NSMutableArray alloc] init];
        NSString* strTitle = [NSString stringWithFormat:@"Location Data For Operating Room: %@", strORID];

        
        UILabel* lblLocationData = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2-150.0), 30.0, self.frame.size.width-60.0, 60.0)];
        lblLocationData.text = strTitle;
        lblLocationData.textColor = [colorManager setColor:8.0 :16.0 :123.0];
        lblLocationData.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
        lblLocationData.backgroundColor = [UIColor clearColor];
        lblLocationData.numberOfLines = 0;
        lblLocationData.lineBreakMode = NSLineBreakByWordWrapping;
        lblLocationData.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblLocationData];
        
        tblLocationList = [[UITableView alloc]  initWithFrame:CGRectMake((self.frame.size.width/2)-125.0, (self.frame.size.height/2)-200.0, 250.0, 400.0)];
        tblLocationList.delegate = self;
        tblLocationList.dataSource = self;
        tblLocationList.layer.borderWidth = 1.0;
        tblLocationList.rowHeight = 30.0;
        [self addSubview:tblLocationList];
        
        UIButton* btnUploadData = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUploadData setImage:[UIImage imageNamed:@"btnUploadNormal.png"] forState:UIControlStateNormal];
        [btnUploadData setFrame:CGRectMake(tblLocationList.frame.origin.x, tblLocationList.frame.origin.y + tblLocationList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnUploadData addTarget:self action:@selector(loadLocation:) forControlEvents:UIControlEventTouchUpInside];
        btnUploadData.tag = 301;
        [self addSubview:btnUploadData];
        
        UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setImage:[UIImage imageNamed:@"btnDeleteIconNormal"] forState:UIControlStateNormal];
        [btnDelete setFrame:CGRectMake(btnUploadData.frame.origin.x + btnUploadData.frame.size.width + 10.0, tblLocationList.frame.origin.y + tblLocationList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnDelete addTarget:self action:@selector(confirmDelete:) forControlEvents:UIControlEventTouchUpInside];
        btnDelete.tag = 302;
        [self addSubview:btnDelete];
        
        UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"btnCloseX"] forState:UIControlStateNormal];
        [btnClose setFrame:CGRectMake(self.frame.size.width-40.0, self.frame.size.height-40.0, 40.0, 40.0)];
        [btnClose addTarget:self action:@selector(closeWin:) forControlEvents:UIControlEventTouchUpInside];
        btnClose.tag = 303;
        [self addSubview:btnClose];
    }
    return self;
}

- (void) showData {
    [tblLocationList reloadData];
}

- (void) loadLocation : (UIButton*) myButton {
    
    //dismiss the keyboard
    [self endEditing:YES];
    
    if(!strLocationListName) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Room Error!."
                    message: @"You did not select a room to load."
                   delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        NSDictionary* dictThisLocation = [dictLocationData objectForKey:strLocationListName];
        
        //calling notification center
        NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
        
        [userData setObject:@"Load Location" forKey:@"Action"];
        [userData setObject:dictThisLocation forKey:@"Location Data"];
        
        /*This is the call back to the notification center, */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
    }
    
}

- (void) confirmDelete : (UIButton*) myButton {
    
    if(!strLocationListName) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Room Error!."
                    message: @"You did not select a room to delete."
                   delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
        
        
    } else { 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Room Deleted."
            message: [NSString stringWithFormat:@"Confirm that you want to delete the location room: %@", strLocationListName]
            delegate: self
          cancelButtonTitle: nil
          otherButtonTitles: @"Confirm", @"Cancel", nil];
        alert.tag = 911;
        [alert show];
    }
}

- (void) deleteLocation  {
    
    //dismiss the keyboard
    [self endEditing:YES];
    
    if(strLocationListName) {
        
        NSMutableDictionary* newLocationData = [[NSMutableDictionary alloc] init];
        
        for(NSString* strThisKey in dictLocationData) {
            
            if (![strThisKey isEqualToString:strLocationListName]) {
                
                NSDictionary* dictThisLocation = [dictLocationData objectForKey:strThisKey];
                [newLocationData setObject:dictThisLocation forKey:strThisKey];
            }
        }
        
        
        NSString* strLocationPlistPath = [NSString stringWithFormat:@"%@/Locations.plist", projectNumber];
        [fileManager writeToPlist:strLocationPlistPath :newLocationData];
        
        //reload data
        
        //make new array of locations that have the correct OR
        NSMutableArray* arrNewLocation = [[NSMutableArray alloc] init];
        for(NSString* strThisKey in newLocationData) {
            
            NSDictionary* dictThisLocation = [newLocationData objectForKey:strThisKey];
            NSString* strMyOR = [dictThisLocation objectForKey:@"Operating Room ID"];
            
            if([strMyOR isEqualToString:strORID]) {
                [arrNewLocation addObject:strThisKey];
            }
        }
        
        arrLocationList = arrNewLocation;
        [tblLocationList reloadData];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Room Deleted."
            message: [NSString stringWithFormat:@"The location room: %@ has been deleted.", strLocationListName]
            delegate: self
            cancelButtonTitle: @"OK"
            otherButtonTitles: nil];

        [alert show];

    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location Room Error!."
            message: @"You did not select a room to delete."
           delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void) closeWin:(UIButton *)myButton  {
    
    [UIView
         animateWithDuration:1.0
         delay:0.0
         options:UIViewAnimationOptionCurveEaseIn
         animations:^{
             
             self.alpha = 0.0;
         }
     
         completion:^ (BOOL finished){
             [self setFrame:CGRectMake(-350, -600, self.frame.size.width, self.frame.size.height)];
         }
     ];
}

#pragma mark - Alert Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 911) {
        if (buttonIndex == 0) {
            [self deleteLocation];
        }
    }
}


#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrLocationList.count;
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
    
    cell.textLabel.text = [arrLocationList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    strLocationListName = [arrLocationList objectAtIndex:indexPath.row];
    
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
