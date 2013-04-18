//
//  OAI_OperatingRoomForm.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/13/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_OperatingRoomForm.h"

@implementation OAI_OperatingRoomForm

@synthesize projectNumber, strRoomID, arrImages, arrThumbnails, dictThisLocation, dictRoomData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        colorManager = [[OAI_ColorManager alloc] init];
        alertManager = [[OAI_AlertScreen alloc] init];
        fileManager = [[OAI_FileManager alloc] init];
                
        arrORList = [[NSMutableArray alloc] init];
        arrExisitingRooms = [[NSMutableArray alloc] init];
        dictRoomData = [[NSMutableDictionary alloc] init];
        arrLocationElements = [[NSMutableArray alloc] init];
        
        isExistingRoom = NO;
        
        NSString* strInstructions = @"Select to either enter a new room or edit an existing one from the options below.";
        CGSize instrSize = [strInstructions sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0] constrainedToSize:CGSizeMake(self.frame.size.width-20.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* lblInstructions = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width-20.0, instrSize.height)];
        lblInstructions.text = strInstructions;
        lblInstructions.numberOfLines = 0;
        lblInstructions.lineBreakMode = NSLineBreakByWordWrapping;
        lblInstructions.textColor = [colorManager setColor:66.0 :66.0 :66.0];
        lblInstructions.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        lblInstructions.backgroundColor = [UIColor clearColor];
        [self addSubview:lblInstructions];
        
        NSArray* arrSegmentTitles = [[NSArray alloc] initWithObjects:@"New Room", @"Edit Room", nil];
        scFormOptions = [[UISegmentedControl alloc] initWithItems:arrSegmentTitles];
        [scFormOptions setFrame:CGRectMake((self.frame.size.width/2)-(scFormOptions.frame.size.width/2), lblInstructions.frame.origin.y + lblInstructions.frame.size.height+10.0, scFormOptions.frame.size.width, 30.0)];
        [scFormOptions setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
        [scFormOptions addTarget:self action:@selector(formDataManager:) forControlEvents:UIControlEventValueChanged];
        scFormOptions.tag = 120;
        [self addSubview:scFormOptions];
        
        svFormViews = [[OAI_ScrollView alloc] initWithFrame:CGRectMake(10.0, scFormOptions.frame.origin.y + scFormOptions.frame.size.height + 15.0, self.frame.size.width-20.0, self.frame.size.height)];
        [svFormViews setContentSize: CGSizeMake(self.frame.size.width*2, svFormViews.frame.size.height)];
        svFormViews.delegate = self;
        svFormViews.canCancelContentTouches = NO;
        [svFormViews setDelaysContentTouches:NO];
        
        float screenX = 0.0;
        float screenY = 0.0;
        float screenW = svFormViews.frame.size.width;
        float screenH = self.frame.size.height-(scFormOptions.frame.size.height + lblInstructions.frame.size.height + 0.0);
        
        for(int i=0; i<2; i++) {
            
            UIView* thisScreen = [[UIView alloc] initWithFrame:CGRectMake(screenX, screenY, screenW, screenH)];
            
            if (i==0) {
                
                NSArray* arrORLabels = [[NSArray alloc] initWithObjects: @"Procedure Room ID", @"Length (ft)", @"Width (ft)", @"True Ceiling Height (ft)", @"False Ceiling Height (ft)", [[NSArray alloc] initWithObjects:@"Ceiling", @"Hatch", @"Drop Ceiling", @"Sealed", nil], @"OR Building", @"Floor", @"Department", @"OR Number", @"Number of Monitors", @"Types of Monitors", @"Wall Location", nil];
                
                UILabel* lblORProperties = [[UILabel alloc] initWithFrame:CGRectMake((thisScreen.frame.size.width/2)-200, 0.0, 400.0, 40.0)];
                lblORProperties.text = @"Procedure Room Information";
                lblORProperties.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                lblORProperties.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                lblORProperties.backgroundColor = [UIColor clearColor];
                lblORProperties.textAlignment = NSTextAlignmentCenter;
                [thisScreen addSubview:lblORProperties];

                float elementX = 40.0;
                float elementY = lblORProperties.frame.origin.y + lblORProperties.frame.size.height + 10.0;
                float elementW = 200.0;
                float elementH = 40.0;
                
                for (int x=0; x<arrORLabels.count; x++) {
                    
                    if (x != 5) {
                        
                        if (x>5) {
                            elementX = thisScreen.frame.size.width -230;
                           
                        }
                        
                        OAI_TextField* thisTextField = [[OAI_TextField alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
                        
                        thisTextField.placeholder = [arrORLabels objectAtIndex:x];
                        thisTextField.myLabel = [arrORLabels objectAtIndex:x];
                        thisTextField.delegate = self;
                        [thisScreen addSubview:thisTextField];
                        [dictRoomData setObject:thisTextField forKey:[arrORLabels objectAtIndex:x]];
                        
                        //601 indicates a numeric entry is needed
                        if (x>0 && x<4) { 
                            thisTextField.tag = 601;
                        } else if (x == 9 || x == 10) {
                            thisTextField.tag = 601;
                        }
                    
                    } else if (x == 5) {
                        
                        elementY = elementY + 10.0;
                        
                        UILabel* lblCeiling = [[UILabel alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
                        lblCeiling.text = @"Ceiling:";
                        lblCeiling.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                        lblCeiling.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                        lblCeiling.backgroundColor = [UIColor clearColor];
                        [thisScreen addSubview:lblCeiling];
                        
                     
                        scCeilingOptions = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:@"Hatch", @"Drop Ceiling", @"Sealed", nil]];
                        [scCeilingOptions setFrame:CGRectMake(elementX, lblCeiling.frame.origin.y + lblCeiling.frame.size.height, 250.0, elementH)];
                        [scCeilingOptions setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:14.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
                        scCeilingOptions.tag = 602;
                        [thisScreen addSubview:scCeilingOptions];
                        [dictRoomData setObject:scCeilingOptions forKey:@"Ceiling:"];
                        
                        //reset y for the next column
                         elementY = lblORProperties.frame.origin.y + lblORProperties.frame.size.height -40.0;
                        
                    }
                    
                    elementY = elementY + 50.0;
                                        
                }
                
                /*UIButton* btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnCamera setImage:[UIImage imageNamed:@"btnCameraNormal"] forState:UIControlStateNormal];
                [btnCamera setFrame:CGRectMake(30.0, scCeilingOptions.frame.origin.y + scCeilingOptions.frame.size.height + 10.0, 40.0, 40.0)];
                [btnCamera addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
                btnCamera.tag = 701;
                btnCamera.backgroundColor =[UIColor clearColor];
                btnCamera.userInteractionEnabled = YES;
                [thisScreen addSubview:btnCamera];
                
                UIButton* btnThumbnails = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnThumbnails setImage:[UIImage imageNamed:@"btnViewThumbnails.png"] forState:UIControlStateNormal];
                [btnThumbnails setFrame:CGRectMake(btnCamera.frame.origin.x, btnCamera.frame.origin.y + btnCamera.frame.size.height + 10.0, 40.0, 40.0)];
                [btnThumbnails addTarget:self action:@selector(showThumbnails:) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnThumbnails];*/
                 
                
                UIButton* btnRoomLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnRoomLocation setFrame:CGRectMake((thisScreen.frame.size.width/2)-150.0, scCeilingOptions.frame.origin.y + scCeilingOptions.frame.size.height + 30.0, 300.0, 30.0)];
                [btnRoomLocation setTitle:@"Other Room Location" forState:UIControlStateNormal];
                btnRoomLocation.titleLabel.textColor = [colorManager setColor:8.0 :16.0 :123.0];
                btnRoomLocation.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                btnRoomLocation.tag = 401;
                [btnRoomLocation addTarget:self action:@selector(scrollByButton:) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnRoomLocation];

            } else if (i==1) {
                
                UILabel* lblLocationInformation = [[UILabel alloc] initWithFrame:CGRectMake((thisScreen.frame.size.width/2)-200, 0.0, 400.0, 40.0)];
                lblLocationInformation.text = @"Other Room Information";
                lblLocationInformation.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                lblLocationInformation.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                lblLocationInformation.backgroundColor = [UIColor clearColor];
                lblLocationInformation.textAlignment = NSTextAlignmentCenter;
                [thisScreen addSubview:lblLocationInformation];
                
                float elementX = (thisScreen.frame.size.width/2)-150.0;
                float elementY = lblLocationInformation.frame.origin.y + lblLocationInformation.frame.size.height + 10.0;
                float elementW = 300.0;
                float elementH = 40.0;
            
                arrLocationData = [[NSArray alloc] initWithObjects:@"Location ID", @"Other Location Building", @"Floor", @"Department", @"Name of Room", @"Distance From OR (ft)", [[NSArray alloc] initWithObjects:@"Signal Connection", @"Type", nil], [[NSArray alloc] initWithObjects:@"Network", @"Type", nil], [[NSArray alloc] initWithObjects:@"AV Equipment", @"Type", nil],
                nil];
                
                arrLocationElementNames = [[NSArray alloc] initWithObjects:@"Location ID", @"Other Location Building", @"Floor", @"Department", @"Name of Room", @"Distance From OR (ft)", @"Signal Connection_checkbox", @"Signal Connection_type", @"Network_checkbox", @"Network_type", @"AV Equipment_checkbox", @"AV Equipment_type", nil];
                
                //get the max label width for the splits
                float maxLabelWidth = 0.0;
                for(int y=0; y<arrLocationData.count; y++) {
                    if (y>5) {
                        
                        NSArray* arrSplitData = [arrLocationData objectAtIndex:y];
                        NSString* strThisLabel = [arrSplitData objectAtIndex:0];
                        CGSize thisLabelSize = [strThisLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
                        if (thisLabelSize.width > maxLabelWidth) {
                            maxLabelWidth = thisLabelSize.width;
                        }
                    }
                }
                
                
                //buttons for the locations
                UIButton* btnAddLocation = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnAddLocation setImage:[UIImage imageNamed:@"btnAddLocation.png"] forState:UIControlStateNormal];
                [btnAddLocation setFrame:CGRectMake(30.0, elementY, 40.0, 40.0)];
                [btnAddLocation addTarget:self action:@selector(confirmResetLocationData) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnAddLocation];
                
                UIButton* btnSaveLocation = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnSaveLocation setImage:[UIImage imageNamed:@"btnStoreData.png"] forState:UIControlStateNormal];
                [btnSaveLocation setFrame:CGRectMake(30.0, btnAddLocation.frame.origin.y + btnAddLocation.frame.size.height + 10.0, 40.0, 40.0)];
                [btnSaveLocation addTarget:self action:@selector(saveLocationData:) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnSaveLocation];
                
                UIButton* btnGetLocations = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnGetLocations setImage:[UIImage imageNamed:@"btnLoadData.png"] forState:UIControlStateNormal];
                [btnGetLocations setFrame:CGRectMake(30.0, btnSaveLocation.frame.origin.y + btnSaveLocation.frame.size.height + 10.0, 40.0, 40.0)];
                [btnGetLocations addTarget:self action:@selector(getLocationData:) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnGetLocations];
                
                for(int x=0; x<arrLocationData.count; x++) {
                    
                    if (x<6) {
                        
                        OAI_TextField* thisTextField = [[OAI_TextField alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
                        
                        thisTextField.placeholder = [arrLocationData objectAtIndex:x];
                        thisTextField.myLabel = [arrLocationData objectAtIndex:x];
                        thisTextField.delegate = self;
                        [thisScreen addSubview:thisTextField];
                        [dictRoomData setObject:thisTextField forKey:[arrLocationData objectAtIndex:x]];
                        [arrLocationElements addObject:thisTextField];
                        
                        //601 indicates a numeric entry is needed
                        if (x==4) {
                            thisTextField.tag = 601;
                        } else if (x == 9 || x == 10) {
                            thisTextField.tag = 601;
                        }
                    
                    } else if (x>5) {
                        
                        NSArray* arrSplitData = [arrLocationData objectAtIndex:x];
                        
                        UILabel* lblCheckboxTitle = [[UILabel alloc] initWithFrame:CGRectMake(elementX, elementY, maxLabelWidth, elementH)];
                        lblCheckboxTitle.text = [arrSplitData objectAtIndex:0];
                        lblCheckboxTitle.textColor = [colorManager setColor:66.0 :66.0 :66.0];
                        lblCheckboxTitle.font = [UIFont fontWithName:@"Helvetica" size:18.0];
                        lblCheckboxTitle.backgroundColor = [UIColor clearColor];

                        [thisScreen addSubview:lblCheckboxTitle];
                            
                        OAI_SimpleCheckbox* thisCheckbox = [[OAI_SimpleCheckbox alloc] initWithFrame:CGRectMake(lblCheckboxTitle.frame.origin.x + lblCheckboxTitle.frame.size.width + 15.0, elementY+5.0, 30.0, 30.0)];
                        [thisCheckbox buildCheckBox];
                        [thisScreen addSubview:thisCheckbox];
                        [dictRoomData setObject:thisCheckbox forKey:[NSString stringWithFormat:@"%@_checkbox", [arrSplitData objectAtIndex:0]]];
                        [arrLocationElements addObject:thisCheckbox];

                        
                        OAI_TextField* thisTextField = [[OAI_TextField alloc] initWithFrame:CGRectMake(thisCheckbox.frame.origin.x + thisCheckbox.frame.size.width + 10.0, elementY+5.0, maxLabelWidth, 30.0)];
                        thisTextField.placeholder = [arrSplitData objectAtIndex:1];
                        thisTextField.myLabel = [arrSplitData objectAtIndex:1];
                        [thisScreen addSubview:thisTextField];
                        [dictRoomData setObject:thisTextField forKey:[NSString stringWithFormat:@"%@_type", [arrSplitData objectAtIndex:0]]];
                        [arrLocationElements addObject:thisTextField];
                        
                            
                    }
                    
                    elementY = elementY + 50.0;
                }
                
                UIButton* btnBackToOR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnBackToOR setFrame:CGRectMake((thisScreen.frame.size.width/2)-150.0, elementY, 300.0, 30.0)];
                [btnBackToOR setTitle:@"Back To Operating Room" forState:UIControlStateNormal];
                btnBackToOR.titleLabel.textColor = [colorManager setColor:8.0 :16.0 :123.0];
                btnBackToOR.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                btnBackToOR.tag = 402;
                [btnBackToOR addTarget:self action:@selector(scrollByButton:) forControlEvents:UIControlEventTouchUpInside];
                [thisScreen addSubview:btnBackToOR];

                
            }
            
            //add screen content
            [svFormViews addSubview:thisScreen];
            
            //increment x
            screenX = screenX + screenW;
        
        }
        
        [self addSubview:svFormViews];
        
        UIImage* btnImage = [UIImage imageNamed:@"btnSaveNormal.png"];
        
        UIButton* btnSaveRoom = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSaveRoom setImage:[UIImage imageNamed:@"btnSaveNormal.png"] forState:UIControlStateNormal];
        [btnSaveRoom setImage:[UIImage imageNamed:@"btnSaveHighlight.png"] forState:UIControlStateHighlighted];
        CGRect btnFrame;
        btnFrame.origin.x = (self.frame.size.width/2)-(btnImage.size.width+10);
        btnFrame.origin.y = self.frame.size.height - (btnImage.size.height + 30);
        btnFrame.size.width = btnImage.size.width;
        btnFrame.size.height = btnImage.size.height;
        [btnSaveRoom setFrame:btnFrame];
        btnSaveRoom.userInteractionEnabled = YES;
        btnSaveRoom.tag = 702;
        [btnSaveRoom addTarget:self action:@selector(saveRoomData:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSaveRoom];
        
        UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setImage:[UIImage imageNamed:@"btnCancelNormal.png"] forState:UIControlStateNormal];
        [btnCancel setImage:[UIImage imageNamed:@"btnCancelHighlight.png"] forState:UIControlStateHighlighted];
        CGRect btnCancelFrame;
        btnCancelFrame.origin.x = (self.frame.size.width/2)+10;
        btnCancelFrame.origin.y = self.frame.size.height - (btnImage.size.height + 30);
        btnCancelFrame.size.width = btnImage.size.width;
        btnCancelFrame.size.height = btnImage.size.height;
        [btnCancel setFrame:btnCancelFrame];
        btnCancel.tag = 703;
        btnCancel.userInteractionEnabled = YES;
        [btnCancel addTarget:self action:@selector(sendNotice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
        
        listManager = [[OAI_ORList alloc] initWithFrame:CGRectMake(-350.0, -600.0, 350.0, 600.0)];
        listManager.backgroundColor = [UIColor whiteColor];
        listManager.alpha = 0.0;
        listManager.tag = 101;
        listManager.projectNumber = projectNumber;
        [self addSubview:listManager];
        
        locationManager = [[OAI_LocationList alloc] initWithFrame:CGRectMake(-350.0, -600.0, 350.0, 600.0)];
        locationManager.backgroundColor = [UIColor whiteColor];
        locationManager.alpha = 0.0;
        locationManager.tag = 101;
        locationManager.projectNumber = projectNumber;
        [self addSubview:locationManager];
        
        
    }
    return self;
}

- (void) setParent:(UIView *)parentView  {
    _vMyParent = parentView;
}

#pragma mark - Save Data
- (void) saveRoomData:(UIButton *)myButton {
    
    //dismiss the keyboard if it is displayed
    [self endEditing:YES];
    
    parsedORData = [self parseORData:dictRoomData:@"OR"];
    saveORData = [[NSMutableDictionary alloc] init];
    
    [self checkForProjectNumber];
    
    //reset the tabs
    scFormOptions.selectedSegmentIndex = -1;

    //validate that a project was selected
    if (projectNumber.length == 0 ) {
        
        [self showAlert:@"Procedure Room Error!" :@"You have not entered a project number. All rooms need to be associated with a project number." :nil :NO];
            
        } else {
            
        //validate that the room has an id
        txtOperatingRoomID = [dictRoomData objectForKey:@"Procedure Room ID"];
        
        if (txtOperatingRoomID.text.length == 0 || [txtOperatingRoomID.text isEqualToString:@""] || [txtOperatingRoomID.text isEqualToString:NULL]) {
            
            [self showAlert:@"Procedure Room Error!" :@"You must enter an ID for this operating room before storing any data for it." :nil :NO];
            
        } else {
            
            [saveORData setObject:parsedORData forKey:txtOperatingRoomID.text];
            
            //get the plist for this room
            dictSavedRoomData = [fileManager readPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber]];
            
            //plist doesn't exist so save data
            if (dictSavedRoomData.count == 0) {
                
                [fileManager createPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber]];
                
                [fileManager writeToPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber] :saveORData];
                
                [self showAlert:@"Procedure Room Saved!" :[NSString stringWithFormat:@"The data for operating room %@ has been saved", txtOperatingRoomID.text] :nil :NO];
                
            } else {
                
                //check to see if this is a duplicate
                BOOL isDuplicate = NO;
                
                for(NSString* thisORID in dictSavedRoomData) {
                    
                    //there is already a room saved with that id
                    if ([thisORID isEqualToString:txtOperatingRoomID.text]) {
                        isDuplicate = YES;
                    }
                }
                
                if (isDuplicate) {
                    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Duplicate Procedure Room" message:@"A procedure room with this ID already exists, do you want to overwrite the data anyway?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
                    
                    alert.tag = 420;
                    [alert show];
                    
                } else {
                    
                    for(NSString* thisKey in dictSavedRoomData) {
                        
                        NSDictionary* dictThisOR = [dictSavedRoomData objectForKey:thisKey];
                        [saveORData setObject:dictThisOR forKey:thisKey];
                    }
                    
                    [saveORData setObject:parsedORData forKey:txtOperatingRoomID.text];
                    
                    [fileManager writeToPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber] :saveORData];
                    
                    [self showAlert:@"Procedure Room Saved!" :[NSString stringWithFormat:@"The data for operating room %@ has been saved", txtOperatingRoomID.text] :nil :NO];
                }
                    
            }
                
        }
        
    }
}

- (void) saveLocationData : (UIButton*) myButton; {
    
    [self checkForProjectNumber];
    [self checkForORID];
    
    //dismiss keyboard
    [self endEditing:YES];
    
    parsedORData = [self parseORData:dictRoomData:@"Location"];
    
    //do all the checks
    //validate that a project was selected
    if (projectNumber.length == 0 ) {
        
        [self showAlert:@"Location Room Error!" :@"You have not entered a project number. All rooms need to be associated with a project number." :nil :NO];
    } else {
        
        if(strRoomID.length == 0 || strRoomID == nil) { 
            
            [self showAlert:@"Location Room Error!" :@"You must enter an ID for this operating room before storing any data for it." :nil :NO];
        
        } else {
            
            NSString* strLocatonID = [parsedORData objectForKey:@"Location ID"];
            if (strLocatonID.length == 0 || [strLocatonID isEqualToString:@""] || [strLocatonID isEqualToString:NULL]) {
                
                [self showAlert:@"Location Room Error!" :@"You must enter an ID for this location before storing any data for it." :nil :NO];
                
            } else {
                
                //set the OR ID in the dictionary
                [parsedORData setObject:strRoomID forKey:@"Operating Room ID"];
                
                //set thislocation data to dict, use id as unique identifier
                NSDictionary* dictThisLocationData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      parsedORData, strLocatonID,
                                                      nil];
                
                 NSDictionary* dictLocationData = [fileManager readPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber]];
                
                //there's no file, create one
                if (dictLocationData.count == 0) {
                    
                    //create the file
                    [fileManager createPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber]];
                    
                    //write the data to the file
                    [fileManager writeToPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber] :dictThisLocationData];
                    
                    [self showAlert:@"Locations Data Saved!" :[NSString stringWithFormat:@"The data for location  %@ has been saved", strLocatonID] :nil :NO];
                    
                } else {
                    
                    BOOL hasMatch = NO;
                    
                    //check the location dictionary and see if the or room id and location room id combo already exists
                    
                    for(NSString* strThisKey in dictLocationData) {
                        
                        dictThisLocation = [dictLocationData objectForKey:strThisKey];
                        strThisORID = [dictThisLocation objectForKey:@"Operating Room ID"];
                        strThisLocationID = [dictThisLocation objectForKey:@"Location ID"];
                        
                        if ([strThisORID isEqualToString:strRoomID] && [strThisLocationID isEqualToString:strLocatonID]) {
                            
                            hasMatch = YES;
                            break;
                        }
                    }
                    
                    if (hasMatch) { 
                    
                        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Duplicate Location!" message:[NSString stringWithFormat:@"The location: %@ for procedure room: %@ already exists. Do you want to overwrite the data?", strThisLocationID, strThisORID] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
                        
                        alert.tag = 421;
                        [alert show];
                    
                    } else {
                        
                        NSMutableDictionary* dictNewData = [[NSMutableDictionary alloc] init];
                        
                        for(NSString* strThisLocation in dictLocationData) {
                            
                            //get a location dict
                            dictThisLocation = [dictLocationData objectForKey:strThisLocation];
                            
                            [dictNewData setObject:dictThisLocation forKey:strThisLocation];
                            
                        }//end loop through location names
                        
                        //add new location
                        [dictNewData setObject:parsedORData forKey:strLocatonID];
                        
                        //store data
                        [fileManager writeToPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber] :dictNewData];
                        
                        [self showAlert:@"Locations Data Saved!" :[NSString stringWithFormat:@"The data for location  %@ has been saved", strLocatonID] :nil :NO];
                    }
                }
                
            }//end check to make sure user entered a location id
            
        }//end check for operating room id
        
    }//end check for project id
}

- (void) saveLocationRoomData {
    
    NSMutableDictionary* dictNewData = [[NSMutableDictionary alloc] init];
    
    //check to see if there is a location data file
    NSDictionary* dictLocationData = [fileManager readPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber]];
    
    
    //loop through and save everything to a new dict except for the one we are overwriting
    for(NSString* strThisKey in dictLocationData) {
        
        NSDictionary* dictSavedLocation = [dictLocationData objectForKey:strThisKey];
        
        NSString* strSavedRoomID = [dictSavedLocation objectForKey:@"Operating Room ID"];
        NSString* strSavedLocationID = [dictSavedLocation objectForKey:@"Location ID"];
        
        if ([strSavedRoomID isEqualToString:strThisORID]) {
            
            if (![strSavedLocationID isEqualToString:strThisLocationID]) {
                
                [dictNewData setObject:dictSavedLocation forKey:strSavedLocationID];
            }
            
        } else if (![strSavedRoomID isEqualToString:strThisORID]) {
            
            [dictNewData setObject:dictSavedLocation forKey:strSavedLocationID];
        }
    }
    
    
    
    //put the current location data
    NSString* strLocatonID = [parsedORData objectForKey:@"Location ID"];
    [dictNewData setObject:parsedORData forKey:strLocatonID];
    
    //save the data
    //store data
    [fileManager writeToPlist:[NSString stringWithFormat:@"%@/Locations.plist", projectNumber] :dictNewData];
    
   [self showAlert:@"Locations Data Saved!" :[NSString stringWithFormat:@"The data for location  %@ has been saved", strLocatonID] :nil :NO];
    
}

- (NSMutableDictionary*) parseORData : (NSMutableDictionary* ) dictORData : (NSString*) parseWhat {
    
    
    NSMutableDictionary* parsedRoomData = [[NSMutableDictionary alloc] init];
    
    //loop through the dictionary
    for(NSString* thisKey in dictORData) {
        
        //get each object
        if ([[dictORData objectForKey:thisKey] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisTextField = (OAI_TextField*)[dictORData objectForKey:thisKey];
            
            if (txtThisTextField.text.length > 0) {
                
                if ([parseWhat isEqualToString:@"Location"]) {
                    if ([arrLocationElementNames containsObject:thisKey]) { 
                        [parsedRoomData setObject:txtThisTextField.text forKey:thisKey];
                    }
                } else {
                    if (![arrLocationElementNames containsObject:thisKey]) {
                        [parsedRoomData setObject:txtThisTextField.text forKey:thisKey];
                    }
                }
            }
            
        } else if ([[dictORData objectForKey:thisKey] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
            
            OAI_SimpleCheckbox* chkThisCheckbox = (OAI_SimpleCheckbox*)[dictORData objectForKey:thisKey];
            if([chkThisCheckbox.isChecked isEqualToString:@"YES"]) {
                
                if ([parseWhat isEqualToString:@"Location"]) {
                    if ([arrLocationElementNames containsObject:thisKey]) {
                        [parsedRoomData setObject:@"YES" forKey:thisKey];
                    }
                } else {
                    if (![arrLocationElementNames containsObject:thisKey]) {
                        [parsedRoomData setObject:@"YES" forKey:thisKey];
                    }
                }
                
            }
            
        } else if ([[dictORData objectForKey:thisKey] isMemberOfClass:[UISegmentedControl class]]) {
            
            UISegmentedControl* scThisControl = (UISegmentedControl*)[dictORData objectForKey:thisKey];
            
            if ([parseWhat isEqualToString:@"Location"]) {
                if ([arrLocationElementNames containsObject:thisKey]) {
                    [parsedRoomData setObject:[NSString stringWithFormat:@"%i", scThisControl.selectedSegmentIndex] forKey:thisKey];
                }
            } else {
                if (![arrLocationElementNames containsObject:thisKey]) {
                    [parsedRoomData setObject:[NSString stringWithFormat:@"%i", scThisControl.selectedSegmentIndex] forKey:thisKey];
                }
            }
        }
    }
    
    return parsedRoomData;
}

- (void) saveProcedureRoomData {
    
    //make new dictionary
    NSMutableDictionary* dictNewData = [[NSMutableDictionary alloc] init];
    
    //reset the tabs
    scFormOptions.selectedSegmentIndex = -1;
    
    //loop through the saved data
    for(NSString* strThisKey in dictSavedRoomData) {
        
        if (![strThisKey isEqualToString:txtOperatingRoomID.text]) { 
        
            NSDictionary* dictThisOR = [dictSavedRoomData objectForKey:strThisKey];
            [dictNewData setObject:dictThisOR forKey:strThisKey];
        }
    }
    
    [dictNewData setObject:parsedORData forKey:txtOperatingRoomID.text];
    
    [fileManager writeToPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber] :saveORData];
    
    [self showAlert:@"Procedure Room Saved!" :[NSString stringWithFormat:@"The data for operating room %@ has been saved", txtOperatingRoomID.text] :nil :NO];
    
}

- (void) loadProcedureRoomData {
    
    [self endEditing:YES];
    
    //get the pro room list view
    CGRect listManagerFrame = listManager.frame;
    listManagerFrame.origin.x = 0-listManagerFrame.size.width;
    listManagerFrame.origin.y = 0-listManagerFrame.size.height;
    
    //close the proroom list
    [UIView animateWithDuration:0.4
          delay:0
        options:UIViewAnimationOptionCurveEaseIn

     animations:^(void){
         listManager.alpha = 0.0;
     }

     completion:^(BOOL Finished){
         //move off screen
         listManager.frame = listManagerFrame;
     }
    ];

    
    for(NSString* strThisKey in _dictSavedORData) {
        
        //get the value
        NSString* strThisValue = [_dictSavedORData objectForKey:strThisKey];
        
        //loop through the elements and find a match
        for(NSString* strThisElement in dictRoomData) {
            
            if ([strThisKey isEqualToString:strThisElement]) {
                
                if ([[dictRoomData objectForKey:strThisElement] isMemberOfClass:[OAI_TextField class]]) {
                    
                    OAI_TextField* txtThisField = (OAI_TextField*)[dictRoomData objectForKey:strThisElement];
                    txtThisField.text = strThisValue;
                    
                } else if ([[dictRoomData objectForKey:strThisElement] isMemberOfClass:[OAI_Checkbox class]]) {
                    
                    OAI_Checkbox* thisCheckbox = (OAI_Checkbox*)[dictRoomData objectForKey:strThisElement];
                    
                    if ([strThisValue isEqualToString:@"YES"]) {
                    } else {
                    }
                         
                } else if ([[dictRoomData objectForKey:strThisElement] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
                    
                    OAI_SimpleCheckbox* thisCheckbox = (OAI_SimpleCheckbox*)[dictRoomData objectForKey:strThisElement];
                    
                    
                } else if ([[dictRoomData objectForKey:strThisElement] isMemberOfClass:[UITableView class]]) {
                    
                    UITableView* tblThisTable = (UITableView*)[dictRoomData objectForKey:strThisElement];
                    
                    
                } else if ([[dictRoomData objectForKey:strThisElement] isMemberOfClass:[OAI_Switch class]]) {
                    
                    OAI_Switch* swThisSwitch = (OAI_Switch*)[dictRoomData objectForKey:strThisElement];
                    
                    if ([strThisValue intValue] > -1) {
                        swThisSwitch.selectedSegmentIndex = [strThisValue intValue];
                    }
                    
                }

            }
        }
        
        
    }
    
}

- (void) checkForProjectNumber {
    
    //get the project number text field and check to see if it has loaded data in it
    NSArray* arrParentSubviews = _vMyParent.subviews;
    UIView* vMainSub = [arrParentSubviews objectAtIndex:0];
    NSArray* arrMainSubviews = vMainSub.subviews;
    OAI_ScrollView* scScroll = [arrMainSubviews objectAtIndex:3];
    NSArray* arrScrollSubviews = scScroll.subviews;
    UIView* vPage2 = [arrScrollSubviews objectAtIndex:1];
    NSArray* arrSectionSubs = vPage2.subviews;
    UIView* vSection = [arrSectionSubs objectAtIndex:1];
    NSArray* arrSiteInspectionElements = vSection.subviews;
    txtProjectNumber = [arrSiteInspectionElements objectAtIndex:1];
    projectNumber = txtProjectNumber.text;
    
}

- (void) checkForORID {
    
    NSArray* arrScrollSubs = svFormViews.subviews;
    UIView* vPage1 = [arrScrollSubs objectAtIndex:0];
    NSArray* arrPageSubs = vPage1.subviews;
    OAI_TextField* txtORID = (OAI_TextField*)[arrPageSubs objectAtIndex:1];
    
    strRoomID = txtORID.text;
    
}

#pragma mark - Form Management

- (void) formDataManager : (UISegmentedControl*) control {
    
    //get the selected index from the segemented control
    int selectedIndex = control.selectedSegmentIndex;
    
    if (selectedIndex == 0) {
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm New Room!"
            message: @"Confirm that you wish to begin a new room. If you do, all unsaved data in the form will be deleted."
           delegate: self
          cancelButtonTitle: nil
          otherButtonTitles: @"Confirm", @"Cancel", nil
        ];
        alert.tag = 911;
        [alert show];

    } else {
        
        [self checkForProjectNumber];
        
        if (projectNumber) { 
        
            //read operating room file
            NSString* strORFile = [NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber];
            NSDictionary* dictORData = [fileManager readPlist:strORFile];
            
            listManager.arrORList = dictORData.allKeys;
            listManager.dictORData = dictORData;
            listManager.projectNumber = projectNumber;
            
            [listManager showData];
            
            //display the listmanager
            CGRect newFrame = CGRectMake((self.frame.size.width/2)-175.0, (self.frame.size.height/2)-300.0, 350.0, 600.0);
            listManager.frame = newFrame;
            
            [UIView animateWithDuration:1.0
             
                delay:0.0
                options:UIViewAnimationOptionCurveEaseIn
             
                animations:^{
                    listManager.alpha = 1.0;
                }
             
                completion:^ (BOOL finished) {
                    nil;
                }
             ];
            
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Loading Stored Data Error"
                        message: @"You must set a project number in order to view stored operating rooms."
                       delegate: self
              cancelButtonTitle: @"OK"
              otherButtonTitles: nil
            ];
            [alert show];
            
            [scFormOptions setSelectedSegmentIndex:-1];
            
        }
    }
    
}

- (void) clearForm {
    
    //loop through the dictionary
    for(NSString* thisKey in dictRoomData) {
        
        //get each object
        if ([[dictRoomData objectForKey:thisKey] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisTextField = (OAI_TextField*)[dictRoomData objectForKey:thisKey];
            txtThisTextField.text = @"";
            
        } else if ([[dictRoomData objectForKey:thisKey] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
            
            OAI_SimpleCheckbox* chkThisCheckbox = (OAI_SimpleCheckbox*)[dictRoomData objectForKey:thisKey];
            [chkThisCheckbox turnCheckOff];
            
        } else if ([[dictRoomData objectForKey:thisKey] isMemberOfClass:[UISegmentedControl class]]) {
            
            UISegmentedControl* scThisControl = (UISegmentedControl*)[dictRoomData objectForKey:thisKey];
            [scThisControl setSelectedSegmentIndex:-1];
                
        }
        
    
    }
    
    [scFormOptions setSelectedSegmentIndex:-1];
    
}

- (void) confirmResetLocationData  {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirm New Location"
                message: @"Are you sure you want to start a new location? All unsaved location data will be lost."
               delegate: self
      cancelButtonTitle: nil
      otherButtonTitles: @"Confirm", @"Cancel", nil
    ];
    alert.tag = 411;
    [alert show];
    
}

- (void) resetLocationData { 
    
    for(int i = 0; i<arrLocationData.count; i++) {
        
        if([[arrLocationData objectAtIndex:i] isKindOfClass:[NSString class]]) {
            
            OAI_TextField* thisTextField = [dictRoomData objectForKey:[arrLocationData objectAtIndex:i]];
            thisTextField.text = @"";
            
        } else if ([[arrLocationData objectAtIndex:i] isKindOfClass:[NSArray class]]) {
            
            NSArray* arrSplitData = [arrLocationData objectAtIndex:i];
            
            if (arrSplitData.count > 0) { 
                NSString* strThisCheckbox = [NSString stringWithFormat:@"%@_checkbox", [arrSplitData objectAtIndex:0]];
                NSString* strThisCheckboxType = [NSString stringWithFormat:@"%@_type", [arrSplitData objectAtIndex:0]];
            
                OAI_SimpleCheckbox* thisCheckbox = [dictRoomData objectForKey:strThisCheckbox];
                [thisCheckbox turnCheckOff];
            
                OAI_TextField* txtCheckBoxType = [dictRoomData objectForKey:strThisCheckboxType];
                 txtCheckBoxType.text = @"";
            }
        }
    }
    
}

- (void) getLocationData : (UIButton*) myButton {
    
    [self checkForORID];
    [self endEditing:YES];
    
    if (!projectNumber) {
        
        [self showAlert:@"Location List Error!" :@"In order to see location information you must enter a project number." :nil :NO];
    
    } else {
        
        if (!strRoomID) {
        
        [self showAlert:@"Location List Error!" :@"In order to see location information you must enter a operating room ID." :nil :NO];
            
        } else {
            
            locationManager.strORID = strRoomID;
            
            //read location plist
            NSString* strLocationPlistPath = [NSString stringWithFormat:@"%@/Locations.plist", projectNumber];
            
            NSDictionary* dictLocations = [fileManager readPlist:strLocationPlistPath];
            
            if (dictLocations.count > 0) { 
            
                NSMutableArray* arrLocationIDS = [[NSMutableArray alloc] init];
            
                for(NSString* strThisKey in dictLocations) {
                
                    dictThisLocation = [dictLocations objectForKey:strThisKey];
                    
                    NSString* strMyOR = [dictThisLocation objectForKey:@"Operating Room ID"]
                    ;
                    
                    if ([strMyOR isEqualToString:strRoomID]) { 
                        [arrLocationIDS addObject:strThisKey];
                    }
                }
                
                locationManager.projectNumber = projectNumber;
                locationManager.arrLocationList = arrLocationIDS;
                locationManager.dictLocationData = dictLocations;
                [locationManager showData];
                
                [locationManager setFrame:CGRectMake((self.frame.size.width/2)-175.0, (self.frame.size.height/2)-300.0, 350.0, 600.0)];
                
                //display location list manager;
                [UIView
                     animateWithDuration:1.0
                     delay:0.0
                     options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         locationManager.alpha = 1.0;
                     }
                     completion:^ (BOOL finished){
                         nil;
                     }
                 ];
                
                
                
            } else {
                [self showAlert:@"Location List Error!" :@"There are no saved locations" :nil :NO];
            }
            
        }
    }
}

- (void) loadLocationData : (NSString*) resetWhat  {
    
    //reset the right form
    if ([resetWhat isEqualToString:@"OR"]) {
        [self clearForm];
    } else { 
        [self resetLocationData];
    }
    
    //loop through each saved elements key/value pair
    for(NSString* strThisKey in _dictSavedLocation) {
        
        //get the value
        NSString* strThisElementValue = [_dictSavedLocation objectForKey:strThisKey];
        
        //loop through the location dictionary and match keys
        for(NSString* strOtherKey in dictRoomData) {
            
            //get a match
            if ([strOtherKey isEqualToString:strThisKey]) {
                
                //get the element type and set it's value
                if([[dictRoomData objectForKey:strOtherKey] isMemberOfClass:[OAI_TextField class]]) {
                    
                    OAI_TextField* thisTextField = (OAI_TextField*)[dictRoomData objectForKey:strOtherKey];
                    thisTextField.text = strThisElementValue;
                    
                } else if ([[dictRoomData objectForKey:strOtherKey] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
                    
                    OAI_SimpleCheckbox* chkThisCheckbox = (OAI_SimpleCheckbox*)[dictRoomData objectForKey:strOtherKey];
                    
                    [chkThisCheckbox turnCheckOn];
                    
                } else if ([[dictRoomData objectForKey:strOtherKey] isMemberOfClass:[UISegmentedControl class]]) {
                    
                    UISegmentedControl* scThisControl = (UISegmentedControl*)[dictRoomData objectForKey:strOtherKey];
                    int selectedIndex = [strThisElementValue intValue];
                    [scThisControl setSelectedSegmentIndex:selectedIndex];
                    
                }
                
            }
             
            
        }
        
        
    }
    
    
    //close list
    CGRect myFrame = CGRectMake(0-self.frame.size.width, 0.0-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.5
     
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         
                         locationManager.alpha = 0.0;
                     }
     
                     completion:^ (BOOL finished) {
                         locationManager.frame = myFrame;
                     }
     ];
     

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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 911) {
        if (buttonIndex == 0) {
            [self clearForm];
        }
    } else if (alertView.tag == 411) {
        if (buttonIndex == 0)  {
            [self resetLocationData];
        }
    }
}


-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (actionSheet.tag == 420) {
        if (buttonIndex == 0){
            overwriteData = YES;
            [self saveProcedureRoomData];
            
        }else {
            overwriteData = NO;
        }
    } else if (actionSheet.tag == 421) {
        if (buttonIndex == 0){
            overwriteData = YES;
            [self saveLocationRoomData];
            
        }else {
            overwriteData = NO;
        }
    } else {
        //just sit here and do nothing
    }
}



#pragma mark - Notification

- (void) sendNotice:(UIButton *)myButton {
    
    [self checkForORID];
    [self endEditing:YES];
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    
    if (myButton.tag == 701) {
        
        if(!strRoomID) { 
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Procedure Room Error!"
                message: @"You must enter an ID for this operating room before storing any data for it."
                delegate: self
                cancelButtonTitle: @"OK"
                otherButtonTitles: nil];
            [alert show];
                        
        } else {
                    
            [userData setObject:@"Take Picture" forKey:@"Action"];
            [userData setObject:strRoomID forKey:@"Operating Room ID"];
                    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
        }        
        
    } else if (myButton.tag == 703) {
        
        NSArray* arrMyParentSubviews = _vMyParent.subviews;
        
        //remove the view if it currently exist
        for(int i=0; i<arrMyParentSubviews.count; i++) {
            
            if ([[arrMyParentSubviews objectAtIndex:i] isMemberOfClass:[OAI_ScrollView class]]) {
                
                //fix the scroll view nudging over
                svNav = (OAI_ScrollView*)[arrMyParentSubviews objectAtIndex:i];
                //set up a point
                float pageX = 3 * 768.0;
                float pageY = 0.0;
                CGPoint scrollOffset = CGPointMake(pageX, pageY);
                                
                //move the scroll offset to that point
                [svNav setContentOffset:scrollOffset animated:YES];
                
            }
        }
        
        [self clearForm];
        
        [userData setObject:@"Close View" forKey:@"Action"];
        [userData setObject:@"Operating Room Form" forKey:@"View Class"];
        [userData setObject:self.superview forKey:@"View To Hide"];
        
        //reset the tab
        scFormOptions.selectedSegmentIndex = -1;
        
        /*This is the call back to the notification center, */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
    }
    
    
    
}

#pragma mark - Scroll Methods

- (void) scrollByButton : (UIButton*) myButton {
    
    int indexNum = 0;
    CGRect formViewFrame = svFormViews.frame;
    
    if (myButton.tag == 401) {
        indexNum = 1;
        
        //change the scroll view y location
        formViewFrame.origin.y = 10.0;
        svFormViews.frame = formViewFrame;
        
        [self toggleElements];
        
    } else if (myButton.tag == 402) {
        indexNum = 0;
        //change the scroll view y location
        formViewFrame.origin.y = scFormOptions.frame.origin.y + scFormOptions.frame.size.height + 10.0;
        svFormViews.frame = formViewFrame;
        
        //clear the location data out
        [self resetLocationData];
        
        [self toggleElements];
    }
    
    //set up a point
    float pageX = indexNum * self.frame.size.width;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //reset the my origi offset (so when keyboard is dismissed scroll remains on page)
    myScrollViewOrigiOffSet = scrollOffset;
    
    //move the scroll offset to that point
    [svFormViews setContentOffset:scrollOffset animated:YES];
    
}

- (void) toggleElements {
    
    //get the subviews
    NSArray* mySubviews = self.subviews;
    
    //check to see what scroll view page we are on
    CGPoint scrollPoint = [svFormViews contentOffset];
    
    for(int i=0; i<mySubviews.count; i++) {
        
        if ([[mySubviews objectAtIndex:i] isMemberOfClass:[UISegmentedControl class]]) {
        
            UISegmentedControl* myControl = (UISegmentedControl*)[mySubviews objectAtIndex:i];
            
            if(scrollPoint.x == 0.0) {
                myControl.alpha = 0.0;
            } else {
                myControl.alpha = 1.0;
            }
        } else if ([[mySubviews objectAtIndex:i] isMemberOfClass:[UIButton class]]) {
            
            UIButton* myButton = (UIButton*)[mySubviews objectAtIndex:i];
            
            if(scrollPoint.x == 0.0) {
                myButton.alpha = 0.0;
            } else {
                myButton.alpha = 1.0;
            }
            
        } else if ([[mySubviews objectAtIndex:i] isMemberOfClass:[UILabel class]]) {
            
            UILabel* myLabel = (UILabel*)[mySubviews objectAtIndex:i];
            
            if(scrollPoint.x == 0.0) {
                myLabel.alpha = 0.0;
            } else {
                myLabel.alpha = 1.0;
            }
            
        }
    }
}

#pragma mark - Text Field Delegate Methods

- (void)textFieldDidEndEditing:(OAI_TextField *)textField {
    
    
    //text field needs to be numeric
    if(textField.tag == 601) {
        
        
    }
    
    if ([textField.myLabel isEqualToString:@"Operating Room ID"]) {
        strRoomID = textField.text;
    } 
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Check if string contains numbers (including decimals)






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
