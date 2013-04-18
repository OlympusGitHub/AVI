//
//  OAI_DataList.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/18/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_DataList.h"

@implementation OAI_DataList

@synthesize arrDataList, projectNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        fileManager = [[OAI_FileManager alloc] init];
        dataManager = [[OAI_DataManager alloc] init];
        
        arrDataList = [[NSMutableArray alloc] init];
        
        tblDataList = [[UITableView alloc]  initWithFrame:CGRectMake((self.frame.size.width/2)-125.0, 20.0, 250.0, 400.0)];
        tblDataList.delegate = self;
        tblDataList.dataSource = self;
        tblDataList.layer.borderWidth = 1.0;
        tblDataList.rowHeight = 30.0;
        [self addSubview:tblDataList];
        
        UIButton* btnUploadData = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUploadData setImage:[UIImage imageNamed:@"btnUploadNormal.png"] forState:UIControlStateNormal];
        [btnUploadData setFrame:CGRectMake(tblDataList.frame.origin.x, tblDataList.frame.origin.y + tblDataList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnUploadData addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
        btnUploadData.tag = 301;
        [self addSubview:btnUploadData];
        
        UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setImage:[UIImage imageNamed:@"btnDeleteIconNormal"] forState:UIControlStateNormal];
        [btnDelete setFrame:CGRectMake(btnUploadData.frame.origin.x + btnUploadData.frame.size.width + 10.0, tblDataList.frame.origin.y + tblDataList.frame.size.height + 10.0, 40.0, 40.0)];
        [btnDelete addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        btnDelete.tag = 302;
        [self addSubview:btnDelete];
        
        UIButton* btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:[UIImage imageNamed:@"btnCloseX"] forState:UIControlStateNormal];
        [btnClose setFrame:CGRectMake(self.frame.size.width-40.0, self.frame.size.height-60.0, 40.0, 40.0)];
        [btnClose addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        btnClose.tag = 303;
        [self addSubview:btnClose];
        
    }
    return self;
}

- (void) sendNotice:(UIButton *)myButton  {
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 301) {
        if (strDataListName) {
                        
            [userData setObject:@"Load Data" forKey:@"Action"];
            [userData setObject:arrDataList forKey:@"Data"];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Project Selected!"
                message: @"You did not select a project to load."
               delegate: self
              cancelButtonTitle: @"OK"
              otherButtonTitles: nil];
            [alert show];
        }
        
    } else if (myButton.tag == 302) {
        if(strDataListName) { 
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm Delete Request."
                        message: [NSString stringWithFormat:@"Please confirm you want to delete the project: %@", strDataListName]
                        delegate: self
                        cancelButtonTitle: nil
                        otherButtonTitles: @"Confirm", @"Cancel", nil];
            alert.tag = 911;
            [alert show];
            
        }
    } else if (myButton.tag == 303) {
        
        //clear out the data
        [arrDataList removeAllObjects];
        [tblDataList reloadData];
        
        [userData setObject:@"Close View" forKey:@"Action"];
        [userData setObject:self.superview forKey:@"View To Hide"];
        
       
    }
    
    /*This is the call back to the notification center, */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
}

- (void) deleteProject {
    
    [fileManager deleteDirectory:strDataListName];
        
    [self showAlert:@"Project Deleted":[NSString stringWithFormat:@"The project %@ has been deleted.", strDataListName]:nil:NO];
    
}

- (void) showData {
    
    [tblDataList reloadData];
}

- (void) clearTableData {
    
    [arrDataList removeAllObjects];
    [tblDataList reloadData];
}

- (void) loadData : (UIButton*) myButton {
 
    if (!strDataListName) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Project Load Error!."
            message: @"You did not select a project to load."
           delegate: self
          cancelButtonTitle: @"OK"
          otherButtonTitles: nil];
        [alert show];
    } else {
        
        
        NSString* strProjectPlist = [NSString stringWithFormat:@"%@/Project_%@.plist", strDataListName, strDataListName];
        NSDictionary* dictThisProject = [fileManager readPlist:strProjectPlist];
       
                
        //calling notification center
        NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
        
        [userData setObject:@"Load Project" forKey:@"Action"];
        [userData setObject:dictThisProject forKey:@"Project Data"];
        
        /*This is the call back to the notification center, */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
        
    }
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
        //[strOtherButtons appendString:nil];
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 911) { 
        if (buttonIndex == 0) {
            [self deleteProject];
        }
    }
}


#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrDataList.count;
    
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
    
    cell.textLabel.text = [arrDataList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    strDataListName = [arrDataList objectAtIndex:indexPath.row];
    
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
