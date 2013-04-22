//
//  OAI_DataManager.m
//  AVI_SiteReport
//
//  Created by Steve Suranie on 3/17/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_DataManager.h"

@implementation OAI_DataManager

@synthesize projectData;

+(OAI_DataManager *)sharedDataManager {
    
    static OAI_DataManager* sharedDataManager;
    
    @synchronized(self) {
        
        if (!sharedDataManager)
            
            sharedDataManager = [[OAI_DataManager alloc] init];
        
        return sharedDataManager;
        
    }
    
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        fileManager = [[OAI_FileManager alloc] init];
    }
    
    return self;
}

#pragma mark - Project Data

- (NSMutableDictionary*) getData : (NSString*) strProjectID : (NSString*) strDataToGet {
    
    BOOL hasError = YES;
    
    NSString* strCheckString;
    if ([strDataToGet isEqualToString:@"Project Data"]) {
        strCheckString = @"Project";
    } else if ([strDataToGet isEqualToString:@"Contact Data"]) {
        strCheckString = @"Contacts";
    } else if ([strDataToGet isEqualToString:@"Procedure Room Data"]) {
        strCheckString = @"Procedure";
    } else if ([strDataToGet isEqualToString:@"Location Room Data"]) {
        strCheckString = @"Location";
    } else if ([strDataToGet isEqualToString:@"All Projects"]) {
        strCheckString = @"All";
    }
    
    NSMutableDictionary* dictData = [[NSMutableDictionary alloc] init];
    
    //get contents of project directory
    if(![strCheckString isEqualToString:@"All"]) {
        
        //get project data
        NSString* strProjectPath = [NSString stringWithFormat:@"%@", strProjectID];
        NSArray* arrProjectFiles = [fileManager getDirectoryContents:strProjectPath];
       
        
        if (arrProjectFiles.count > 0) {
            
            for(int i=0; i<arrProjectFiles.count; i++) {
                
                //check to see if the data we are looking for exists
                NSString* strFileName = [arrProjectFiles objectAtIndex:i];
                if([strFileName rangeOfString:strCheckString].location != NSNotFound) {
                    hasError = NO;
                    
                    //gather data
                    NSString* strFilePath = [NSString stringWithFormat:@"%@/%@", strProjectID, strFileName];
                    NSDictionary* dictStoredData = [fileManager readPlist:strFilePath];
                    
                    [dictData setObject:@"Success" forKey:@"Result"];
                    [dictData setObject:dictStoredData forKey:@"Data"];
                }
            }
            
        }
    
    } else {
        
        //get all projects
        NSArray* arrDocsDirectoryFiles = [fileManager getDocDirectoryFolders];
        
        if (arrDocsDirectoryFiles.count > 0) {
            
            hasError = NO;
            
            for(int i=0; i<arrDocsDirectoryFiles.count; i++) {
            
                NSString* strFileName = [arrDocsDirectoryFiles objectAtIndex:i];
                if ([strFileName rangeOfString:@".DS_Store"].location == NSNotFound && [strFileName rangeOfString:@"User"].location == NSNotFound && [strFileName rangeOfString:@"Documents"].location == NSNotFound) {
                    [dictData setObject:strFileName forKey:[NSString stringWithFormat:@"Folder_%@", strFileName]];
                }
            }
            
        } else {
            hasError = YES;
        }
        
    }
    
    if (hasError) { 
        
        NSString* strErrMsg;
        if ([strDataToGet isEqualToString:@"Contact Data"]) {
            strErrMsg = [NSString stringWithFormat:@"There are no saved contacts for project:%@", strProjectID];
        } else if ([strDataToGet isEqualToString:@"Project Data"]) {
            strErrMsg = [NSString stringWithFormat:@"There is no saved data for the project:%@", strProjectID];
        } else if ([strDataToGet isEqualToString:@"Procedure Room Data"]) {
            strErrMsg = [NSString stringWithFormat:@"There is no saved procedure rooms for the project:%@", strProjectID];
        } else if ([strDataToGet isEqualToString:@"Location Room Data"]) {
            strErrMsg = [NSString stringWithFormat:@"There is no saved location rooms for the project:%@", strProjectID];
        } else if ([strDataToGet isEqualToString:@"All Projects"]) {
            strErrMsg = [NSString stringWithFormat:@"There are no saved projects"];
        }

        [dictData setObject:@"Fail" forKey:@"Result"];
        [dictData setObject:strErrMsg forKey:@"Error Message"];
        
    }
    
    return dictData;
    
}

- (NSMutableArray*) buildData : (NSArray*) arrSections {
    
    _arrRequiredElements = [[NSMutableArray alloc] init];
    
    NSMutableArray* arrFormData = [[NSMutableArray alloc] init];
    
    for(int i=0; i<arrSections.count; i++) {
        
        NSMutableArray* formElements = [[NSMutableArray alloc] init];
        
        if ([[arrSections objectAtIndex:i] isEqualToString:@"Site Information"]) {
            
            //dict to hold form elements
                        
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Project Number:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Medium", @"Field Size",
              nil]];
            
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Inspection Date:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isDateField",
              @"NO", @"isRequired",
              @"Medium", @"Field Size",
              @"YES", @"isDateField",
              nil]];
            
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Prepared By:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Medium", @"Field Size",
              nil]];
            
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Revised Date:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isDateField",
              @"NO", @"isRequired",
              @"Medium", @"Field Size",
              @"YES", @"isDateField",
              nil]];
            
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Revised By:", @"Field Name",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Medium", @"Field Size",
              nil]];
            
        } else if ([[arrSections objectAtIndex:i] isEqualToString:@"ENDOALPHA Solution"]) {
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"ENDOALPHA Control:", @"Field Name",
              @"MultiCheckbox", @"Field Type",
              @"One Needed", @"isRequired",
              @"N/A", @"Field Size",
              @"1", @"Rule ID",
              [[NSArray alloc] initWithObjects:@"AVP", @"UCES", @"UCES+" ,nil], @"Checkboxes",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"ENDOALPHA Video:", @"Field Name",
              @"MultiCheckbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"2", @"Rule ID",
              [[NSArray alloc] initWithObjects:@"HD Recording", @"SD Recording",nil], @"Checkboxes",
              nil]
             ];
            
            for(int x=0; x<formElements.count; x++) {
                
                NSDictionary* dictThisElement = [formElements objectAtIndex:x];
                
                NSString* strIsRequired = [dictThisElement objectForKey:@"isRequired"];
                if ([strIsRequired isEqualToString:@"YES"]) {
                    [_arrRequiredElements addObject:dictThisElement];
                }
            }
            
        } else if ([[arrSections objectAtIndex:i] isEqualToString:@"Hospital Information"]) {
            
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Hospital  Name:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Width", @"Field Size",
              @"1", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Address:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Width", @"Field Size",
              @"1", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"City:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Large", @"Field Size",
              @"1", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"State:", @"Field Name",
              @"Table", @"Field Type",
              @"YES", @"isRequired",
              @"Small", @"Field Size",
              @"1", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Zip:", @"Field Name",
              @"Text Field", @"Field Type",
              @"YES", @"isRequired",
              @"Small", @"Field Size",
              @"1", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              [[NSArray alloc] initWithObjects:@"Add Contact", @"Get Contacts", @"Add Procedure Room", nil], @"Buttons",
              @"Button Array", @"Field Type",
              nil]];
            
            for(int x=0; x<formElements.count; x++) {
                
                NSDictionary* dictThisElement = [formElements objectAtIndex:x];
                
                NSString* strIsRequired = [dictThisElement objectForKey:@"isRequired"];
                if ([strIsRequired isEqualToString:@"YES"]) {
                    [_arrRequiredElements addObject:dictThisElement];
                }
            }
              
            
        } else if ([[arrSections objectAtIndex:i] isEqualToString:@"Pre-Install Checks"]) {
        
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Cabeling length does not exceed approx 130ft. between AV equipment to AVP Rack:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C1", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Hospital representative agreed to cable:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C2", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Placement of AVP agreed by hospital representative in accordance to installation manual:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C3", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Placement of Touch Panels agreed by hospital:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C4", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Audio and Video interfaces requirements and specifications have been discussed:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C5", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Data interfaces requirements and specifications have been discussed:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C6", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Other pre-installation requirements checked:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"N/A", @"Field Size",
              @"S1C7", @"Check ID",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Comments:", @"Field Name",
              @"ENDOALPHA_Control_Comments", @"myLabel",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Field Size",
              @"NO", @"Relocate",
              @"ENDOALPHA Control", @"Section ID",
              nil]
             ];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Pre-installation requirements checked:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Cabling route agreed:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Placement of Recording Device agreed by hospital:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Video interfaces requirements and specifications have been discussed:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Data interfaces requirements and specifications have been discussed:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Comments:", @"Field Name",
              @"ENDOALPHA_Video_Comments", @"myLabel",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Video", @"Section ID",
              @"2", @"Sub Section",
              nil]];

            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Site was inspected by boom company:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"60", @"Element Height",
              @"Boom Company", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Type of Boom (Model Number):", @"Field Name",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Boom Company", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Tentative Install Dates:", @"Field Name",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"YES", @"isDateField",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Boom Company", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Comments:", @"Field Name",
              @"Boom_Company_Comments", @"myLabel",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Boom Company", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Construction:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Old", @"New", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Is Olympus Required For Tear Out:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Safety glasses required:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Safety shoes required:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Hard hat required:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Hearing protection required:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Scrubs required:", @"Field Name",
              @"Tab", @"Field Type",
              @"YES", @"isRequired",
              [[NSArray alloc] initWithObjects:@"Yes", @"No", nil], @"Tabs",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Comments:", @"Field Name",
              @"Safety_Comments", @"myLabel",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Safety", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"2D Floor Plan:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Electrical Installation Scheme:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];
            
            /*[formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Pictures (required):", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];*/
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Facility Drawing:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Other:", @"Field Name",
              @"Checkbox", @"Field Type",
              @"NO", @"isRequired",
              @"NO", @"hasSpecialRules",
              @"2", @"Special Rule ID",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Comments:", @"Field Name",
              @"Documents_Comments", @"myLabel",
              @"Right", @"Element Align",
              @"Text Field", @"Field Type",
              @"NO", @"isRequired",
              @"Large", @"Element Width",
              @"30", @"Element Height",
              @"Documents", @"Section ID",
              nil]];
            
            for(int x=0; x<formElements.count; x++) {
                
                NSDictionary* dictThisElement = [formElements objectAtIndex:x];
                
                NSString* strIsRequired = [dictThisElement objectForKey:@"isRequired"];
                if ([strIsRequired isEqualToString:@"YES"]) {
                    [_arrRequiredElements addObject:dictThisElement];
                }
            }
            
        } else if ([[arrSections objectAtIndex:i] isEqualToString:@"Miscellaneous"]) {
            
            [formElements addObject:
             [[NSMutableDictionary alloc] initWithObjectsAndKeys:
              @"Miscellaneous Info:", @"Field Name",
              @"Text View", @"Field Type",
              @"NO", @"isRequired",
              nil]];
            
        }

        [arrFormData addObject:formElements];
    }
    
    return arrFormData;
    
}

- (BOOL) saveData : (NSString*) projectNumber {
    
    OAI_States* statesManager = [[OAI_States alloc] init];
    arrStates = [statesManager getStates];
    
    NSMutableDictionary* dictProjectData = [[NSMutableDictionary alloc] init];
    NSString* strElementKey;
    NSString* strElementValue;
    
    //make sure the elements were passed
    if (_arrAllElements) {
        
        //loop
        for(int i=0; i<_arrAllElements.count; i++) {
        
            if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
                
                OAI_TextField* txtThisField = (OAI_TextField*)[_arrAllElements objectAtIndex:i];
                strElementKey = txtThisField.myLabel;
                strElementValue = txtThisField.text;
                
            } else if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Checkbox class]]) {
                
                OAI_Checkbox* thisCheckbox = (OAI_Checkbox*)[_arrAllElements objectAtIndex:i];
                strElementKey = thisCheckbox.strCheckboxLabel;
                if (thisCheckbox.isChecked) {
                    strElementValue = @"YES";
                } else {
                    strElementValue = @"NO";
                }
                
            } else if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
                
                OAI_SimpleCheckbox* thisCheckbox = (OAI_SimpleCheckbox*)[_arrAllElements objectAtIndex:i];
                strElementKey = thisCheckbox.elementID;
                if ([thisCheckbox.isChecked isEqualToString:@"YES"]) {
                    strElementValue = @"YES";
                } else {
                    strElementValue = @"NO";
                }
                
            } else if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[UITableView class]]) {
                
                //call back home and get the table and it's selected value
                UITableView* tblThisTable = (UITableView*)[_arrAllElements objectAtIndex:i];
                
                strElementKey = @"State";
                NSIndexPath *selectedPath = tblThisTable.indexPathForSelectedRow;
                if (selectedPath != nil) {
                    strElementValue = [arrStates objectAtIndex:selectedPath.row];
                } else {
                    strElementValue = @"No Entry";
                }
                
            } else if ([[_arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Switch class]]) {
                
                OAI_Switch* swThisSwitch = (OAI_Switch*)[_arrAllElements objectAtIndex:i];
                strElementKey = swThisSwitch.elementID;
                if (swThisSwitch.selectedSegmentIndex == -1) {
                    strElementValue = @"No Entry";
                } else {
                    strElementValue = [swThisSwitch titleForSegmentAtIndex:swThisSwitch.selectedSegmentIndex];
                }
                
            }
            
            if (strElementValue == nil) {
                strElementValue = @"No Entry";
            }
            [dictProjectData setObject:strElementValue forKey:strElementKey];
            
        }
        
    }
    
    //NSLog(@"%@", dictProjectData);
    
    NSString* strFilePath = [NSString stringWithFormat:@"%@/Project_%@.plist", projectNumber, projectNumber];
    
    BOOL success = [fileManager writeToPlist:strFilePath :dictProjectData];
    
    if (success) {
        
        return YES;
    } else {
        return NO;
    }
    
    return 0;
    
}

#pragma mark - Contact Data

- (BOOL) checkContactData : (NSDictionary*) dictContactData : (NSString*) strProjectID {
    
    BOOL hasContact = NO;
    _strProjectNumber = strProjectID;
    dictMyContactData = dictContactData;
    
    //check to make sure the contact doesn't already exist
    NSString* strContactsPath = [NSString stringWithFormat:@"%@/Contacts.plist", strProjectID];

    NSDictionary* dictAllContacts = [fileManager readPlist:strContactsPath];
    
    if (dictAllContacts) {
        NSString* strContactName = [dictContactData objectForKey:@"Contact Name"];
        NSString* strContactTitle = [dictContactData objectForKey:@"Contact Title"];
        
        for(NSString* strThisKey in dictAllContacts) {
            
            NSDictionary* dictThisContact = [dictAllContacts objectForKey:strThisKey];
            NSString* strThisContactName = [dictThisContact objectForKey:@"Contact Name"];
            NSString* strThisContactTitle = [dictThisContact objectForKey:@"Contact Title"];
            
            if ([strContactName isEqualToString:strThisContactName] && [strContactTitle isEqualToString:strThisContactTitle]) {
                hasContact = YES;
            }
        }
    }
    
    //if it does exist, ask if the user wants to over write the data
    
    if (hasContact) {
        
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Duplicate Contact" message:@"A contact already exists with this name and title, do you want to overwrite the data anyway?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
        
        alert.tag = 411;
        [alert show];
        
    } else {
        overwriteData = YES;
        BOOL success = [self saveContactData:dictContactData :strProjectID :overwriteData];
        return success;
    }
    
}

- (BOOL) saveContactData : (NSDictionary*) dictContactData : (NSString*) strProjectID : (BOOL) canOverwrite {
        
        NSString* strContactsPath = [NSString stringWithFormat:@"%@/Contacts.plist", strProjectID];
        NSMutableDictionary* newContactData = [[NSMutableDictionary alloc] init];
        
        //new contact data
        NSString* strContactName = [dictContactData objectForKey:@"Contact Name"];
        
        
        NSDictionary* dictAllContacts = [fileManager readPlist:strContactsPath];
        
        //add the old data to the new dictionary
        if (dictAllContacts.count > 0) { 
            for(NSString* strThisKey in dictAllContacts) {
                
                NSDictionary* dictThisContact = [dictAllContacts objectForKey:strThisKey];
                
                if (![strThisKey isEqualToString:strContactName]) { 
                    [newContactData setObject:dictThisContact forKey:strThisKey];
                }
            }
        }
        
        [newContactData setObject:dictContactData forKey:strContactName];
        
        BOOL success = [fileManager writeToPlist:strContactsPath :newContactData];

        if (success) {
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Contact Saved!"
                message: [NSString stringWithFormat:@"The contact %@ has been saved in the project; %@", strContactName, strProjectID]
                      delegate: self
             cancelButtonTitle: @"OK"
             otherButtonTitles: nil];
            [alert show];
            
            contactDataSaved = YES;
        }
    
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    [userData setObject:@"Close View From String" forKey:@"Action"];
    [userData setObject:@"Contact" forKey:@"View To Close"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theMessenger" object:self userInfo: userData];
    
}

- (BOOL) deleteContact : (NSString*) strContactName {
    
    NSString* strFilePath = [NSString stringWithFormat:@"%@/Contacts.plist", _strProjectNumber];
    
    //read contacts
    NSDictionary* dictContactList = [fileManager readPlist:strFilePath];
    NSMutableDictionary* dictNewContactList = [[NSMutableDictionary alloc] init];
    
    //rewrite contacts
    for(NSString* strThisKey in dictContactList) {
        if (![strThisKey isEqualToString:strContactName]) {
            NSDictionary* dictThisContact = [dictContactList objectForKey:strThisKey];
            [dictNewContactList setObject:dictThisContact forKey:strThisKey];
        }
    }
    
    //write contacts
    BOOL success = [fileManager writeToPlist:strFilePath :dictNewContactList];
    return success;
    
}



- (NSString *)getDocsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark Alert Methods
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 411) { 
        if (buttonIndex == 0){
            overwriteData = YES;
            [self saveContactData:dictMyContactData:_strProjectNumber:overwriteData];
            
        }else {
            overwriteData = NO;
        }
    }
}




@end
