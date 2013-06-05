//
//  ViewController.m
//  avi
//
//  Created by Steve Suranie on 4/15/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /*************INIT MANAGERS*********************/
    
    colorManager = [[OAI_ColorManager alloc] init];
    dataManager = [[OAI_DataManager alloc] init];
    fileManager = [[OAI_FileManager alloc] init];
    statesManager = [[OAI_States alloc] init];
    accountManager = [[OAI_Account alloc] init];
    mailManager = [[OAI_MailManager alloc] init];
    tabManager = [[OAI_SetTabOrder alloc] init];
    pdfManager = [[OAI_PDFManager alloc] init];
    
    dataManager.vMyParent = self.view;
    
    /*************INIT DATA ARRAYS******************/
    
    arrResultsData = [[NSMutableArray alloc] init];
    arrSectionData = [[NSMutableArray alloc] init];
    arrRequiredElements = [[NSMutableArray alloc] init];
    arrAllElements = [[NSMutableArray alloc] init];
    arrSavedProjects = [[NSMutableArray alloc] init];
    
    
    /*************INIT DATE PICKER******************/
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    arrStates = [statesManager getStates];
    
    /************NOTIFICATION CENTER*************/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"theMessenger"object:nil];
    
    /***********************************
     TOP BAR
     ***********************************/
    
    titleBarManager = [[OAI_TitleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0)];
    titleBarManager.titleBarTitle = @"Site Inspection Report";
    [titleBarManager buildTitleBar];
    [self.view addSubview:titleBarManager];
    
    /***********************************
     MAIN APP SCREEN
     **********************************/
    
    UIView* vMainWin = [[UIView alloc] initWithFrame:CGRectMake(0.0, titleBarManager.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-40.0)];
    
    //array to hold the segemented control count and button titles
    NSArray* arrSections = [[NSArray alloc] initWithObjects:@"Site Information", @"ENDOALPHA Solution", @"Hospital Information", @"Pre-Install Checks", @"Misc. Info.", nil];
    
    //get the elements
    arrSectionData = [dataManager buildData:arrSections];
    arrRequiredElements = dataManager.arrRequiredElements;
    
    //add a segmented control to top of the screen
    scNav = [[UISegmentedControl alloc] initWithItems:arrSections];
    
    [self resizeSegmentedControlSegments:1];
    
    CGRect scNavFrame = scNav.frame;
    scNavFrame.origin.y = 5.0;
    scNavFrame.origin.x = (self.view.frame.size.width/2)-(scNavFrame.size.width/2);
    scNav.frame = scNavFrame;
    [scNav setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [scNav addTarget:self action:@selector(scrollToView:) forControlEvents:UIControlEventValueChanged];
    
    [vMainWin addSubview:scNav];
    
    UIButton* btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setFrame:CGRectMake(240.0, scNav.frame.origin.y + scNav.frame.size.height + 10.0, 120.0, 30.0)];
    [btnSave addTarget:self action:@selector(saveData:) forControlEvents:UIControlEventTouchUpInside];
    [vMainWin addSubview:btnSave];
    
    UIButton* btnLoadData = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLoadData setTitle:@"Load Project" forState:UIControlStateNormal];
    [btnLoadData setFrame:CGRectMake(370.0, scNav.frame.origin.y + scNav.frame.size.height + 10.0, 120.0, 30.0)];
    [btnLoadData addTarget:self action:@selector(showSavedProject:) forControlEvents:UIControlEventTouchUpInside];
    [vMainWin addSubview:btnLoadData];
    
    UIButton* btnReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnReset setTitle:@"Reset" forState:UIControlStateNormal];
    [btnReset setFrame:CGRectMake(500.0, scNav.frame.origin.y + scNav.frame.size.height + 10.0, 120.0, 30.0)];
    [btnReset addTarget:self action:@selector(resetData:) forControlEvents:UIControlEventTouchUpInside];
    [vMainWin addSubview:btnReset];

    
    UIButton* btnEmail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnEmail setTitle:@"Email" forState:UIControlStateNormal];
    [btnEmail setFrame:CGRectMake(630.0, scNav.frame.origin.y + scNav.frame.size.height + 10.0, 120.0, 30.0)];
    [btnEmail addTarget:self action:@selector(emailData:) forControlEvents:UIControlEventTouchUpInside];
    [vMainWin addSubview:btnEmail];
    
    //add the scroll controller
    scrollManager = [[OAI_ScrollView alloc] initWithFrame:CGRectMake(10.0, scNav.frame.origin.y + scNav.frame.size.height + 40.0, self.view.frame.size.width-20.0, self.view.frame.size.height - scNav.frame.size.height)];
    [scrollManager setDelegate:self];
    [scrollManager setContentSize:CGSizeMake(768 * (arrSections.count+1), 1024)];
    myScrollViewOrigiOffSet = scrollManager.contentOffset;
    
    //add the form content
    for (int i=0; i<arrSections.count+1; i++) {
        
        float sectionX = 768*i;
        float sectionY = 0.0;
        float sectionW = 768.0;
        float sectionH = 1004.0;
        
        NSString* strSectionTitle;
        if (i==0) {
            strSectionTitle = @"Instructions";
            
        } else {
            strSectionTitle = [arrSections objectAtIndex:i-1];
        }
        
        //set up the section holder
        UIView* vSection = [[UIView alloc] initWithFrame:CGRectMake(sectionX, sectionY, sectionW, sectionH)];
        vSection.tag = i;
        
        //get the title size
        CGSize sectionTitleSize = [strSectionTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
        
        //add a label
        OAI_Label* lblSectionTitle = [[OAI_Label alloc] initWithFrame:CGRectMake(30.0, 30.0, sectionTitleSize.width, sectionTitleSize.height)];
        lblSectionTitle.text = strSectionTitle;
        lblSectionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
        [vSection addSubview:lblSectionTitle];
        
        //set up the element holder
        UIView* vSectionElements = [[UIView alloc] initWithFrame:CGRectMake(30.0, lblSectionTitle.frame.origin.y + lblSectionTitle.frame.size.height + 15.0, 768.0, 1004.0-(lblSectionTitle.frame.origin.y + lblSectionTitle.frame.size.height))];
        
        
        if (i>0 && i<4) {
            
            NSArray* arrThisSectionElements = [arrSectionData objectAtIndex:i-1];
            
            [self buildSectionElements:arrThisSectionElements :vSectionElements:strSectionTitle];
            
        } else if (i==5) {
            
            NSArray* arrThisSectionElements = [arrSectionData objectAtIndex:i-1];
            
            [self buildSectionElements:arrThisSectionElements :vSectionElements:strSectionTitle];
            
        } else if (i==4) {
            
            //need to get the subsections 
            NSArray* arrThisSectionElements = [arrSectionData objectAtIndex:i-1];
            NSArray* arrSubSections = [[NSArray alloc] initWithObjects:@"ENDOALPHA Control", @"Video", @"Boom Company", @"Safety", @"Documents", nil];
            
            //make the segement control for the subsections
            scSubSections = [[UISegmentedControl alloc] initWithItems:arrSubSections];
            [self resizeSegmentedControlSegments:2];
            CGRect scSubSectionFrame = scSubSections.frame;
            scSubSectionFrame.origin.y = 5.0;
            scSubSectionFrame.origin.x = (self.view.frame.size.width/2)-(scNavFrame.size.width/2);
            scSubSections.frame = scSubSectionFrame;
            [scSubSections setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
            [scSubSections addTarget:self action:@selector(scrollToSubSection:) forControlEvents:UIControlEventValueChanged];
            [vSectionElements addSubview:scSubSections];
             
            //add the scroll view for the subsections
            svSubSections = [[OAI_ScrollView alloc] initWithFrame:CGRectMake(30.0, scSubSections.frame.origin.y + scSubSections.frame.size.height + 10.0, vSectionElements.frame.size.width-60.0, 700.0)];
            [svSubSections setDelegate:self];
            [svSubSections setContentSize:CGSizeMake(vSectionElements.frame.size.width-60.0 * (arrSubSections.count), 700.0)];
            [vSectionElements addSubview:svSubSections];
            
            //add the subsections
            float subSectionX = 0.0;
            float subSectionY = 0.0;
            float subSectionW = vSectionElements.frame.size.width-60.0;
            float subSectionH = 700.0;
            
            for(int s=0; s<arrSubSections.count; s++) {
                
                NSString* strSubSectionName = [arrSubSections objectAtIndex:s];
                
                //increment the subsection x coord
                subSectionX = subSectionW * s;
                
                //add the subsection view
                UIView* vSubSection = [[UIView alloc] initWithFrame:CGRectMake(subSectionX, subSectionY, subSectionW, subSectionH)];
                
                NSMutableArray* arrThisSubSectionElements = [[NSMutableArray alloc] init];
                    
                for(int x=0; x<arrThisSectionElements.count; x++) {
                        
                    NSDictionary* dictThisElement = [arrThisSectionElements objectAtIndex:x];
                    NSString* strElementSubSection = [dictThisElement objectForKey:@"Section ID"];
                    
                    if([strElementSubSection isEqualToString:strSubSectionName]) {
                        
                        [arrThisSubSectionElements addObject:dictThisElement];
                    }
                }
                
                [self buildSectionElements:arrThisSubSectionElements :vSubSection :strSectionTitle];
                
                [svSubSections addSubview:vSubSection];
            
            }
            
        } else if (i==0) {
            
            UIFont* instFont = [UIFont fontWithName:@"Helvetica" size:22.0];
            UIColor* fontColor = [colorManager setColor:51.0 :51.0 :51.0];
            
            NSString* strInst = @"Welcome to the AVI Site Integration Report App. This app is intended to provide you with a means of collecting, storing and submitting data in relation to an ENDOALPHA installation.\n\nTo begin, touch any of the tabs at the top of the screen. The section associated with that tab will appear. Fill in the appropriate information.\n\nYour information can be saved at any time by clicking the \"Save\" button located at the top right of the screen. Once you have completed filling in the information for the site report click the \"Email\" button to submit the information.\n\n";
            CGSize instrSize = [strInst sizeWithFont:instFont constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel* lblIntroText = [[UILabel alloc] initWithFrame:CGRectMake(50.0, lblSectionTitle.frame.origin.y + lblSectionTitle.frame.size.height + 30.0, instrSize.width, instrSize.height)];
            lblIntroText.text = strInst;
            lblIntroText.textColor = fontColor;
            lblIntroText.font = instFont;
            lblIntroText.numberOfLines = 0;
            lblIntroText.lineBreakMode = NSLineBreakByWordWrapping;
            [lblIntroText sizeToFit];
            [vSection addSubview:lblIntroText];
            
            NSString* strViewInst = @"To view a list of saved information click on the list icons for the information you wish to load (Projects, Contacts, Procedure Rooms and Locations).";
            CGSize viewSize = [strViewInst sizeWithFont:instFont constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            //loading data
            UILabel* lblViewText = [[UILabel alloc] initWithFrame:CGRectMake(100.0, lblIntroText.frame.origin.y + lblIntroText.frame.size.height + 10, viewSize.width, viewSize.height)];
            lblViewText.text = strViewInst;
            lblViewText.textColor = fontColor;
            lblViewText.font = instFont;
            lblViewText.numberOfLines = 0;
            lblViewText.lineBreakMode = NSLineBreakByWordWrapping;
            [lblViewText sizeToFit];
            [vSection addSubview:lblViewText];
            
            UIImage* btnViewData = [UIImage imageNamed:@"btnLoadData.png"];
            UIImageView* imgViewData = [[UIImageView alloc] initWithImage:btnViewData];
            [imgViewData setFrame:CGRectMake(50.0, lblIntroText.frame.origin.y + lblIntroText.frame.size.height + 10, btnViewData.size.width, btnViewData.size.height)];
            [vSection addSubview:imgViewData];
            
            NSString* strLoadInst = @"To load saved information click on the load icon for the information you wish to load (Projects, Contacts, Procedure Rooms and Locations).";
            CGSize loadSize = [strLoadInst sizeWithFont:instFont constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            //loading data
            UILabel* lblLoadText = [[UILabel alloc] initWithFrame:CGRectMake(100.0, lblViewText.frame.origin.y + lblViewText.frame.size.height + 10, loadSize.width, loadSize.height)];
            lblLoadText.text = strLoadInst;
            lblLoadText.textColor = fontColor;
            lblLoadText.font = instFont;
            lblLoadText.numberOfLines = 0;
            lblLoadText.lineBreakMode = NSLineBreakByWordWrapping;
            [lblLoadText sizeToFit];
            [vSection addSubview:lblLoadText];
            
            UIImage* btnLoadData = [UIImage imageNamed:@"btnUploadNormal.png"];
            UIImageView* imgLoadData = [[UIImageView alloc] initWithImage:btnLoadData];
            [imgLoadData setFrame:CGRectMake(50.0, lblViewText.frame.origin.y + lblViewText.frame.size.height + 10, btnLoadData.size.width, btnLoadData.size.height)];
            [vSection addSubview:imgLoadData];
            
            NSString* strSaveInst = @"To save information click on the save icon for the information you wish to save (Projects, Contacts, Procedure Rooms and Locations).";
            CGSize saveSize = [strSaveInst sizeWithFont:instFont constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            //loading data
            UILabel* lblSaveText = [[UILabel alloc] initWithFrame:CGRectMake(100.0, lblLoadText.frame.origin.y + lblLoadText.frame.size.height + 10, saveSize.width, saveSize.height)];
            lblSaveText.text = strSaveInst;
            lblSaveText.textColor = fontColor;
            lblSaveText.font = instFont;
            lblSaveText.numberOfLines = 0;
            lblSaveText.lineBreakMode = NSLineBreakByWordWrapping;
            [lblSaveText sizeToFit];
            [vSection addSubview:lblSaveText];
            
            UIImage* btnSaveData = [UIImage imageNamed:@"btnStoreData.png"];
            UIImageView* imgSaveData = [[UIImageView alloc] initWithImage:btnSaveData];
            [imgSaveData setFrame:CGRectMake(50.0, lblLoadText.frame.origin.y + lblLoadText.frame.size.height + 10, btnSaveData.size.width, btnSaveData.size.height)];
            [vSection addSubview:imgSaveData];
            
        }
        
        [vSection addSubview:vSectionElements];
        [scrollManager addSubview:vSection];
        
    }
    
    [vMainWin addSubview:scrollManager];
    
    tabManager.arrAllElements = arrAllElements;

    _arrMasterTabOrder = [tabManager setTabOrder];
    
    [self.view addSubview:vMainWin];
    
    /**********************************
     TITLE SCREEN
     **********************************/
    
    titleScreenManager = [[OAI_TitleScreen alloc] initWithFrame:CGRectMake(0.0, titleBarManager.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-40.0)];
    titleScreenManager.strAppTitle = @"Site Inspection Report";
    [titleScreenManager buildTitleScreen];
    [self.view addSubview:titleScreenManager];
    
    /***********************************
     SPLASH SCREEN
     ***********************************/
    
    //check to see if we need to display the splash screen
    BOOL needsSplash = YES;
    
    if (needsSplash) {
        CGRect myBounds = self.view.bounds;
        appSplashScreen = [[OAI_SplashScreen alloc] initWithFrame:CGRectMake(myBounds.origin.x, myBounds.origin.y, myBounds.size.width, myBounds.size.height)];
        
        //pass the title screen over to the splash screen (so we can run the title screen fade)
        appSplashScreen.myTitleScreen = titleScreenManager;
        
        [self.view addSubview:appSplashScreen];
        [appSplashScreen runSplashScreenAnimation];
        
        
    }
    
    /***********************************
     ACCOUNT SCREEN
     ***********************************/
    CGRect accountFrame = CGRectMake(100.0, -350.0, 300.0, 350.0);
    accountManager.frame = accountFrame;
    [accountManager buildAccountObjects];
    [self.view addSubview:accountManager];
    [self.view bringSubviewToFront:titleBarManager];

    
    /**********************************
     MODALS
    **********************************/
    
    vAddContact = [[OAI_ModalDisplay alloc] initWithFrame:CGRectMake(-400.0, -600.0, 400.0, 600.0)];
    vAddContact.layer.shadowColor = [UIColor blackColor].CGColor;
    vAddContact.layer.shadowOffset = CGSizeMake(2.0,2.0);
    vAddContact.layer.shadowOpacity = .75;
    vAddContact.strModalTitle = @"Add Contact";
    vAddContact.alpha = 0.0;
    [vAddContact buildModal];
    
    [self.view addSubview:vAddContact];
    
    vGetContacts = [[OAI_ModalDisplay alloc] initWithFrame:CGRectMake(-400.0, -600.0, 400.0, 600.0)];
    vGetContacts.layer.shadowColor = [UIColor blackColor].CGColor;
    vGetContacts.layer.shadowOffset = CGSizeMake(2.0,2.0);
    vGetContacts.layer.shadowOpacity = .75;
    vGetContacts.strModalTitle = @"Get Contacts";
    vGetContacts.alpha = 0.0;
    [vGetContacts buildModal];
    
    [self.view addSubview:vGetContacts];
    
    vAddProcedureRoom = [[OAI_ModalDisplay alloc] initWithFrame:CGRectMake(-600.0, -800.0, 600.0, 800.0)];
    vAddProcedureRoom.layer.shadowColor = [UIColor blackColor].CGColor;
    vAddProcedureRoom.layer.shadowOffset = CGSizeMake(2.0,2.0);
    vAddProcedureRoom.layer.shadowOpacity = .75;
    vAddProcedureRoom.strModalTitle = @"Add Procedure Room";
    vAddProcedureRoom.alpha = 0.0;
    vAddProcedureRoom.tag = 603;
    
    vAddProcedureRoom.vMyParent = self.view;
    [vAddProcedureRoom buildModal];
    
    [self.view addSubview:vAddProcedureRoom];
    
    vSavedProjects = [[OAI_ModalDisplay alloc] initWithFrame:CGRectMake(-300.0, -600.0, 300.0, 600.0)];
    vSavedProjects.layer.shadowColor = [UIColor blackColor].CGColor;
    vSavedProjects.layer.shadowOffset = CGSizeMake(2.0,2.0);
    vSavedProjects.layer.shadowOpacity = .75;
    vSavedProjects.strModalTitle = @"Saved Projects";
    vSavedProjects.alpha = 0.0;
    vSavedProjects.tag = 601;
    [vSavedProjects buildModal];
    
    [self.view addSubview:vSavedProjects];
    
    vGetSavedRooms = [[OAI_ModalDisplay alloc] initWithFrame:CGRectMake(-400.0, -700.0, 400.0, 700.0)];
    vGetSavedRooms.layer.shadowColor = [UIColor blackColor].CGColor;
    vGetSavedRooms.layer.shadowOffset = CGSizeMake(2.0,2.0);
    vGetSavedRooms.layer.shadowOpacity = .75;
    vGetSavedRooms.strModalTitle = @"Saved Rooms";
    vGetSavedRooms.alpha = 0.0;
    
    [vGetSavedRooms buildModal];
    
    [self.view addSubview:vGetSavedRooms];
    
}

#pragma mark - Build Section Elements

- (void) buildSectionElements : (NSArray*) arrThisSectionElements : (UIView*) vSectionElements : (NSString*) strThisSection {
    
    float maxLabelWidth = [self getMaxLaeblWidth:arrThisSectionElements:strThisSection];
        
    float labelX = 0.0;
    float labelY = 20.0;
    float labelIncrement = 0.0;

    float elementX = maxLabelWidth + 10.0;
    float elementY = 20.0;
    float elementW = 0.0;
    float elementH = 0.0;
    
    int tag;
    for(int i=0; i<arrThisSectionElements.count; i++) {
                
        //get the dict
        NSDictionary* dictThisElement = [arrThisSectionElements objectAtIndex:i];
        
        //get the type
        NSString* strFieldType = [dictThisElement objectForKey:@"Field Type"];
        
        //get the label
        NSString* strFieldName = [dictThisElement objectForKey:@"Field Name"];
        
        //get the requiremnt
        NSString* strIsRequired = [dictThisElement objectForKey:@"isRequired"];
        
        NSString* strCommentLabel = [dictThisElement objectForKey:@"myLabel"];
        
        //get the size
        CGSize fieldNameSize = [strFieldName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0] constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        //build label
        UILabel* lblFieldName = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, fieldNameSize.width, fieldNameSize.height)];
        lblFieldName.text = strFieldName;
        lblFieldName.textColor = [colorManager setColor:51.0 :51.0 :51.0];
        lblFieldName.backgroundColor = [UIColor clearColor];
        lblFieldName.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        lblFieldName.numberOfLines = 0;
        lblFieldName.lineBreakMode = NSLineBreakByWordWrapping;
        [vSectionElements addSubview:lblFieldName];
        
        tag = i+1;
        if([strFieldType isEqualToString:@"Text Field"]) {
            
            //get the requiremnt
            NSString* strAlignment = [dictThisElement objectForKey:@"Element Align"];
            
            if ([strAlignment isEqualToString:@"Right"]) {
                elementX = vSectionElements.frame.size.width - 260.0;
                elementY = elementY + 15.0;
            }
            
            elementW = 200.0;
            elementH = 30.0;
            labelIncrement = 30.0;
            
            OAI_TextField* txtThisField = [[OAI_TextField alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
            
            if (strCommentLabel.length > 0) {
                txtThisField.myLabel = strCommentLabel;
            } else { 
                txtThisField.myLabel = strFieldName;
            }
            
            txtThisField.isRequired = strIsRequired;
            txtThisField.tag = tag;
            
            if ([txtThisField.myLabel rangeOfString:@"Date"].location != NSNotFound) {
                txtThisField.inputView = datePicker;
            }
            
            txtThisField.delegate = self;
            
            [vSectionElements addSubview:txtThisField];
            [arrAllElements addObject:txtThisField];
            
        } else if ([strFieldType isEqualToString:@"Table"]) {
            
            elementW =300.0;
            elementH = 100.0;
            labelIncrement = 100.0;
            
            UITableView* tblThisTable = [[UITableView alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
            tblThisTable.rowHeight = 30.0;
            tblThisTable.layer.borderColor = [colorManager setColor:51.0 :51.0 :51.0].CGColor;
            tblThisTable.layer.borderWidth = 1.0;
            tblThisTable.delegate = self;
            tblThisTable.dataSource = self;
           
            [vSectionElements addSubview:tblThisTable];
            [arrAllElements addObject:tblThisTable];
            
        } else if ([strFieldType isEqualToString:@"Checkbox"]) {
            
            //reset x
            elementX = vSectionElements.frame.size.width - 90.0;
            
            OAI_SimpleCheckbox* thisCheckbox = [[OAI_SimpleCheckbox alloc] initWithFrame:CGRectMake(elementX, elementY, 30.0, 30.0)];
            thisCheckbox.elementID = strFieldName;
            [thisCheckbox buildCheckBox];
            
            [vSectionElements addSubview:thisCheckbox];
            [arrAllElements addObject:thisCheckbox];
            
            elementH = fieldNameSize.height;
            labelIncrement = fieldNameSize.height;
            
        } else if ([strFieldType isEqualToString:@"MultiCheckbox"]) {
            
            NSArray* arrCheckboxes = [dictThisElement objectForKey:@"Checkboxes"];
            
            //set up the max label size
            float maxCheckBoxLabel = 0.0;
            
            for(int d=0; d<arrCheckboxes.count; d++ ) {
                
                NSString* strCheckboxTitle = [arrCheckboxes objectAtIndex:d];
                CGSize checkboxTitleSize = [strCheckboxTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
                if (maxCheckBoxLabel < checkboxTitleSize.width) {
                    maxCheckBoxLabel = checkboxTitleSize.width;
                }
            }
            
            //get the check box rule
            int ruleID = [[dictThisElement objectForKey:@"Rule ID"] intValue];
            
            //loop through the checkboxes
            for(int c=0; c<arrCheckboxes.count; c++) {
                
                //build the checkbox label
                UILabel* lblCheckbox = [[UILabel alloc] initWithFrame:CGRectMake(elementX, elementY, maxCheckBoxLabel, 30.0)];
                lblCheckbox.text = [arrCheckboxes objectAtIndex:c];
                lblCheckbox.textColor = [colorManager setColor:51.0 :51.0 :51.0];
                lblCheckbox.font = [UIFont fontWithName:@"Helvetica" size:20.0];
                lblCheckbox.backgroundColor = [UIColor clearColor];
            
                OAI_Checkbox* thisCheckbox = [[OAI_Checkbox alloc] initWithFrame:CGRectMake(lblCheckbox.frame.origin.x + lblCheckbox.frame.size.height, elementY, 30.0, 30.0)];
                
                thisCheckbox.strCheckboxLabel = [arrCheckboxes objectAtIndex:c];
                thisCheckbox.ruleID = ruleID;
                thisCheckbox.hasSpecialRule = YES;
                [thisCheckbox buildCheckbox];
                
                [vSectionElements addSubview:thisCheckbox];
                [arrAllElements addObject:thisCheckbox];
                
                elementY = elementY + 40.0;
                                
            }
            
            labelY = labelY + arrCheckboxes.count*40.0;
            
            
         } else if ([strFieldType isEqualToString:@"Tab"]) {
             
             elementX = vSectionElements.frame.size.width - 200.0;
             elementW = 140.0;
             elementH = 30.0;
             labelIncrement = elementH;
             
             //get the requiremnt
             NSArray* arrTabs = [dictThisElement objectForKey:@"Tabs"];
             
             OAI_Switch* scTabs = [[OAI_Switch alloc] initWithItems:arrTabs];
             scTabs.isRequired = strIsRequired;
             scTabs.elementID = strFieldName;
             
             [scTabs setFrame:CGRectMake(elementX, elementY, elementW, elementH)];
             
             [vSectionElements addSubview:scTabs];
             [arrAllElements addObject:scTabs];
             
        } else if ([strFieldType isEqualToString:@"Button Array"]) {
            
            NSArray* arrBtnTitles = [dictThisElement objectForKey:@"Buttons"];
            int tag = 100;
            
            for(int b=0; b<arrBtnTitles.count; b++) {
                
                tag = tag + 1;
                
                NSString* strBtnTitle = [arrBtnTitles objectAtIndex:b];
                
                UIImage* imgBtn;
                NSString* strBtnAction;
                
                if ([strBtnTitle isEqualToString:@"Add Contact"]) {
                    imgBtn = [UIImage imageNamed:@"btnNewUser.png"];
                    strBtnAction = @"newUser";
                } else if ([strBtnTitle isEqualToString:@"Get Contacts"]) {
                    imgBtn = [UIImage imageNamed:@"btnContactList.png"];
                    strBtnAction = @"getUsers";
                } else if ([strBtnTitle isEqualToString:@"Add Procedure Room"]) {
                    imgBtn = [UIImage imageNamed:@"btnNewOR.png"];
                    strBtnAction = @"newProcedureRoom";
                } else if ([strBtnTitle isEqualToString:@"Edit Procedure Room"]) {
                    imgBtn = [UIImage imageNamed:@"btnEdit.png"];
                    strBtnAction = @"editProcedureRoom";
                }
                    
                
                UIButton* btnThisButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnThisButton setImage:imgBtn forState:UIControlStateNormal];
                [btnThisButton addTarget:self action:@selector(buttonManager:) forControlEvents:UIControlEventTouchUpInside];
                [btnThisButton setFrame:CGRectMake(elementX, elementY, 79.0, 72.0)];
                btnThisButton.tag = tag;
                [vSectionElements addSubview:btnThisButton];

                CGSize buttonLabelSize = [strBtnTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
                
                UILabel* lblThisButton = [[UILabel alloc] initWithFrame:CGRectMake((btnThisButton.frame.origin.x+btnThisButton.frame.size.width/2)-(buttonLabelSize.width/2), btnThisButton.frame.origin.y+btnThisButton.frame.size.height + 4.0, buttonLabelSize.width, buttonLabelSize.height)];
                lblThisButton.text = strBtnTitle;
                lblThisButton.font = [UIFont fontWithName:@"Helvetica" size:10.0];
                lblThisButton.textColor = [colorManager setColor:51.0 :51.0 :51.0];
                lblThisButton.textAlignment = NSTextAlignmentCenter;
                lblThisButton.backgroundColor = [UIColor clearColor];
                [vSectionElements addSubview:lblThisButton];
                
                elementX = elementX + 110.0;
                
            }
            
        } else if ([strFieldType isEqualToString:@"Text View"]) {
            
            
            elementW = 400.0;
            elementX = 200.0;
            elementH = 600.0;
            
            OAI_TextView* txtThisView = [[OAI_TextView alloc] initWithFrame:CGRectMake(elementX, elementY, elementW, elementH)];
            txtThisView.myLabel = strFieldName;
            txtThisView.layer.borderWidth = 1.0;
            txtThisView.layer.borderColor = [colorManager setColor:51.0 :51.0 :51.0].CGColor;
            txtThisView.layer.cornerRadius = 5;
            txtThisView.clipsToBounds = YES;
            [vSectionElements addSubview:txtThisView];
            [arrAllElements addObject:txtThisView];
            
        }
    
    //increment label and next field
    elementY = elementY + elementH + 15.0;
    labelY = labelY + labelIncrement + 15.0;
    
    }

    //for passing to other views
    _arrElements = arrAllElements;
    
    

}

- (float) getMaxLaeblWidth:(NSArray *)arrThisSectionElements :(NSString *)strThisSection {
    
    float maxLabelWidth = 0.0;
    
    for(int i=0; i<arrThisSectionElements.count; i++) {
        
        //get the dict
        NSDictionary* dictThisElement = [arrThisSectionElements objectAtIndex:i];
        //get the field name
        NSString* strFieldName = [dictThisElement objectForKey:@"Field Name"];
        //get the size
        CGSize fieldNameSize = [strFieldName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0] constrainedToSize:CGSizeMake(600.0, 999.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        //check size
        if (fieldNameSize.width < 600.0) {
            if (maxLabelWidth < fieldNameSize.width) {
                maxLabelWidth = fieldNameSize.width;
            }
        } else {
            maxLabelWidth = 600.0;
        }
        
    }
    
    return maxLabelWidth;
        
        
}

#pragma mark - Notification Center

- (void) receiveNotification:(NSNotification* ) notification {
    
    [self.view endEditing:YES];
    
    if ([[notification name] isEqualToString:@"theMessenger"]) {
        
        //get the event
        NSString* strAction = [[notification userInfo] objectForKey:@"Action"];

        if ([strAction isEqualToString:@"Close View"]) {
            
            OAI_ModalDisplay* thisModal = [[notification userInfo] objectForKey:@"View To Hide"];
            [self animationManager:thisModal:nil];
            
        } else if ([strAction isEqualToString:@"Show View"]) {
           
            NSString* strViewToShow = [[notification userInfo] objectForKey:@"View To Show"];
            
            if ([strViewToShow isEqualToString:@"Account"]) {
                
                UIView* vThisView = accountManager;
                
                [self animationManager:nil:vThisView];
            
            } else if ([strViewToShow isEqualToString:@"Saved Projects"]) {
                
                NSDictionary* dictProjects = [dataManager getData:nil :@"All Projects"];
                
                NSString* strResults = [dictProjects objectForKey:@"Result"];
                
                if (![strResults isEqualToString:@"Fail"]) {
                    
                    for(NSString* strThisKey in dictProjects) {
                        
                        [arrSavedProjects addObject:[dictProjects objectForKey:strThisKey]];
                    }
                    
                    vSavedProjects.arrModalTableData = arrSavedProjects;
                    [vSavedProjects reloadTableData];
                    
                    OAI_ModalDisplay* thisModal = vSavedProjects;
                    
                    [self animationManager:thisModal:nil];
                    
                } else {
                    
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle: @"Project Load Error!"
                               message: @"There was a problem loading saved projects."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
                    [alert show];
                }
            
            }
        } else if ([strAction isEqualToString:@"Close View From String"]) {
            
            NSString* strViewToClose = [[notification userInfo] objectForKey:@"View To Close"];
            
            if ([strViewToClose isEqualToString:@"Contact"])  {
                [self animationManager:vAddContact :nil];
                [vAddContact resetForm];
            }
            
         } else if ([strAction isEqualToString:@"Load Project"]) {
             
             //get the project data
             NSDictionary* dictThisProjectData = [[notification userInfo] objectForKey:@"Project Data"];
             
             //display the data
             [self displayData:dictThisProjectData:YES];
             
             //clear out the data list table
             [vSavedProjects clearTableData];
             
        } else if ([strAction isEqualToString:@"Save Contact Data"]) {
            
            NSDictionary* dictThisContactData = [[notification userInfo] objectForKey:@"Contact Data"];
            
            [dataManager checkContactData:dictThisContactData :projectNumber];
             
        } else if ([strAction isEqualToString:@"Show Contact Data"]) {
            
            NSDictionary* dictThisContactData = [[notification userInfo] objectForKey:@"Contact Data"];
            [vAddContact showContactData:dictThisContactData];
            
            //close the get contacts
            [self animationManager:vGetContacts :nil];
            //open the add contacts
            [self animationManager:vAddContact :nil];
            
        } else if ([strAction isEqualToString:@"Delete Contact Data"]) {
            
            NSString* strContactToDelete = [[notification userInfo] objectForKey:@"Contact Name"];
            [dataManager deleteContact:strContactToDelete];
            
            //get the contact list
            NSMutableDictionary* dictResults = [dataManager getData:projectNumber:@"Contact Data"];
            
            //check for success or fail
            NSString* strResult = [dictResults objectForKey:@"Result"];
            
            if([strResult isEqualToString:@"Fail"]) {
                //hasError = YES;
                //strErrMsg = [dictResults objectForKey:@"Error Message"];
            } else {
                [self displayContacts:[dictResults objectForKey:@"Data"]];
            }
            
        } else if ([strAction isEqualToString:@"Load OR"]) {
            
            [self animationManager:vGetSavedRooms :nil];
            [self animationManager:vAddProcedureRoom :nil];
            
            vAddProcedureRoom.dictSavedORData = [[notification userInfo] objectForKey:@"OR Data"];
            vAddProcedureRoom.strModalTitle = @"Edit Procedure Room";
            [vAddProcedureRoom reloadMyTitleBar];
            [vAddProcedureRoom loadORData];
            
        } else if ([strAction isEqualToString:@"Load Location"]) {
            
            vAddProcedureRoom.dictSavedLocation = [[notification userInfo] objectForKey:@"Location Data"];
            [vAddProcedureRoom loadLocationData];
            
        } else if ([strAction isEqualToString:@"Read Plist"]) {
            
            dictAttachedData = [[NSDictionary alloc] init];
            
            NSURL* url = [[notification userInfo] objectForKey:@"File Path"];
            NSArray* arrURLParts = [url pathComponents];
            NSString* strFilePath = [NSString stringWithFormat:@"%@/%@", [arrURLParts objectAtIndex:arrURLParts.count-2], [arrURLParts objectAtIndex:arrURLParts.count-1]];
            
            dictAttachedData = [fileManager readPlist:strFilePath];
            
            [self examineAttachedData];
            
        }
    }
}


#pragma mark - Data Management

- (void) displayData : (NSDictionary* ) dictThisProject : (BOOL) needsAnimation {
    
    NSString* strElementName;
    
    for(NSString* strThisKey in dictThisProject) {
        
        for(int i=0; i<arrAllElements.count; i++) {
            
            if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
                
                OAI_TextField* txtThisField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
                strElementName = txtThisField.myLabel;
                
                if ([strElementName isEqualToString:strThisKey]) {
                    if (![[dictThisProject objectForKey:strThisKey] isEqualToString:@"No Entry"]) {
                        txtThisField.text = [dictThisProject objectForKey:strThisKey];
                    }
                }
                
            } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Checkbox class]]) {
                
                OAI_Checkbox* thisCheckbox = (OAI_Checkbox*)[arrAllElements objectAtIndex:i];
                strElementName = thisCheckbox.strCheckboxLabel;
                
                if ([strElementName isEqualToString:strThisKey]) {
                    
                    if ([[dictThisProject objectForKey:strThisKey] isEqualToString:@"YES"]) {
                        [thisCheckbox turnCheckOn];
                    }
                }
               
                
            } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
                
                OAI_SimpleCheckbox* thisCheckbox = (OAI_SimpleCheckbox*)[arrAllElements objectAtIndex:i];
                strElementName = thisCheckbox.elementID;
                
                if ([strElementName isEqualToString:strThisKey]) {
                    
                    if ([[dictThisProject objectForKey:strThisKey] isEqualToString:@"YES"]) {
                        [thisCheckbox turnCheckOn];
                    }
                }
                
            } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[UITableView class]]) {
                
                UITableView* tblThisTable = (UITableView*)[arrAllElements objectAtIndex:i];
                strElementName = @"State";
                
                if ([strElementName isEqualToString:strThisKey]) {
                    
                    NSString* strElementValue = [dictThisProject objectForKey:strThisKey];
                    
                    if(![strElementValue isEqualToString:@"No Entry"]) {
                        for(int s=0; s<arrStates.count; s++) {
                            
                            if ([strElementValue isEqualToString:[arrStates objectAtIndex:s]]) {
                                
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:s inSection:0];
                                
                                [tblThisTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                            }
                        }
                    }
                    
                    
                }
                                
            } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Switch class]]) {
                
                OAI_Switch* swThisSwitch = (OAI_Switch*)[arrAllElements objectAtIndex:i];
                strElementName = swThisSwitch.elementID;
                
                if ([strElementName isEqualToString:strThisKey]) {
                    
                    //get the saved value
                    NSString* strSavedValue = [dictThisProject objectForKey:strThisKey];
                    
                    //loop through the segments
                    for(int x=0; x<swThisSwitch.numberOfSegments; x++) {
                        
                        //get the title
                        NSString* strSegmentTitle = [swThisSwitch titleForSegmentAtIndex:x];
                        
                        if ([strSegmentTitle isEqualToString:strSavedValue]) {
                            
                            swThisSwitch.selectedSegmentIndex = x;
                            break;
                        }
                    }
                    
                }
                
            } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextView class]]) {
                
                OAI_TextView* txtThisView = (OAI_TextView*)[arrAllElements objectAtIndex:i];
                
                strElementName = txtThisView.myLabel;
                
                if ([strElementName isEqualToString:strThisKey]) {
                    if (![[dictThisProject objectForKey:strThisKey] isEqualToString:@"No Entry"]) {
                        txtThisView.text = [dictThisProject objectForKey:strThisKey];
                    }
                }

                
            }

        }
        
    }
    
    //close the modal window
    if (needsAnimation) { 
        [self animationManager:vSavedProjects :nil];
    }
    
    //if the titlescreen is displayed, close it
    if (titleScreenManager.alpha == 1.0) {
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         
         animations:^{
             titleScreenManager.alpha = 0.0;
         }

         completion:^ (BOOL finished) {
             
             CGRect myFrame = titleScreenManager.frame;
             myFrame.origin.x = 0-myFrame.size.width;
             myFrame.origin.y = 0-myFrame.size.height;
             titleScreenManager.frame = myFrame;
         }
         ];
    }
    
    //go to the first page
    [self scrollToViewFromData:1];
    scNav.selectedSegmentIndex = 0;
        
}

- (void) displayContacts : (NSDictionary*) dictContacts {
    
    NSMutableArray* arrContacts = [[NSMutableArray alloc] init];
    for(NSString* strThisKey in dictContacts) {
        [arrContacts addObject:strThisKey];
    }
    
    vGetContacts.strProjectNumber = projectNumber;
    vGetContacts.arrModalTableData = arrContacts;
    [vGetContacts reloadTableData];
    
}

- (void) displaySavedRooms : (NSDictionary* ) dictSavedRooms {
    
    NSMutableArray* arrSavedRoomTitles = [[NSMutableArray alloc] init];
    for(NSString* strThisKey in dictSavedRooms) {
        [arrSavedRoomTitles addObject:strThisKey];
    }
    
    vGetSavedRooms.strProjectNumber = projectNumber;
    vGetSavedRooms.arrModalTableData = arrSavedRoomTitles;
    vGetSavedRooms.dictSavedORData = dictSavedRooms;
    [vGetSavedRooms reloadTitleBar];
    [vGetSavedRooms reloadTableData];
    
}

- (void) showSavedProject:(UIButton *)myButton  {
    
    NSDictionary* dictProjects = [dataManager getData:nil :@"All Projects"];
    
    NSString* strResults = [dictProjects objectForKey:@"Result"];
    
    if (![strResults isEqualToString:@"Fail"]) {
        
        //build project list
        for(NSString* strThisKey in dictProjects) {
            
            NSString* strProjectName = [dictProjects objectForKey:strThisKey];
            
            if ([strProjectName rangeOfString:@".plist"].location == NSNotFound && [strProjectName rangeOfString:@"Inbox"].location == NSNotFound) {
                [arrSavedProjects addObject:strProjectName];
            }
        }
        
        //pass project list to modal window and reload the table
        vSavedProjects.arrModalTableData = arrSavedProjects;
        [vSavedProjects reloadTableData];
        
        //display the modal window
        OAI_ModalDisplay* thisModal = vSavedProjects;
        
        [self animationManager:thisModal:nil];
        
    } else {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Project Load Error!"
                                   message: @"There was a problem loading saved projects."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
    }

}

- (void) saveData : (UIButton*) myButton {
    
    [self.view endEditing:YES];
    
    //check to see if we loaded a value into the project number field
    for(int i=0; i<arrAllElements.count; i++) {
        
        if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisTextField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
            
            if ([txtThisTextField.myLabel isEqualToString:@"Project Number:"]) {
                projectNumber = txtThisTextField.text;
            }
        }
    }
    
    if (projectNumber) {
        
        dataManager.arrAllElements = arrAllElements;
        BOOL wasSaved = [dataManager saveData:projectNumber];
        
        NSString* strAlertMsg;
        if (wasSaved) {
            strAlertMsg = [NSString stringWithFormat:@"The data for project id %@ was saved!", projectNumber];
        } else {
            strAlertMsg = [NSString stringWithFormat:@"There was a problem saving the data for project id %@", projectNumber];
        }
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Data Saving Message!"
                message: strAlertMsg
                delegate: self
             cancelButtonTitle: @"OK"
             otherButtonTitles: nil];
            [alert show];
        
    } else {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Data Saving Error!"
        message: @"You cannot save data without a project number!"
        delegate: self
         cancelButtonTitle: @"OK"
         otherButtonTitles: nil];
        [alert show];

    }
    
}

- (void) examineAttachedData  {
    
    if(dictAttachedData) {
        
        //get the project data
        NSDictionary* dictProjectData = [dictAttachedData objectForKey:@"Project Data"];
        NSString* strProjectNumber = [dictProjectData objectForKey:@"Project Number:"];
        
        //check to see if project exists
        NSArray* arrDocumentDiretories = [fileManager getDocDirectoryFolders];
        if ([arrDocumentDiretories containsObject:strProjectNumber]) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Project Already Exists!"
                       message: [NSString stringWithFormat:@"The project: %@ already exists in your documents directory. Do you want to proceed? Doing so will over write the existing data.", strProjectNumber]
                      delegate: self
             cancelButtonTitle: nil
             otherButtonTitles: @"Yes", @"No", nil];
            alert.tag = 311;
            [alert show];

        } else {
            [self parseAttachedData];
        }
        
        
    } else {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Data Display Error!"
                                   message: @"There was a problem displaying the attached data."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        
    }

}

- (void) parseAttachedData {
    
    //get the data
    NSDictionary* dictProjectData = [dictAttachedData objectForKey:@"Project Data"];
    NSDictionary* dictContactData = [dictAttachedData objectForKey:@"Contacts"];
    NSDictionary* dictProcedureRoomData = [dictAttachedData objectForKey:@"Procedure Rooms"];
    
    //display the project data
    [self displayData:dictProjectData:NO];
    [svSubSections setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    
    //overwrite the existing plist files
    
    //get the project number
    NSString* strProjectNumber = [dictProjectData objectForKey:@"Project Number:"];
    NSString* strProjectPath = [NSString stringWithFormat:@"%@/Project_%@.plist", strProjectNumber, strProjectNumber];
    NSString* strContactsPath = [NSString stringWithFormat:@"%@/Contacts.plist", strProjectNumber];
    NSString* strProcedureRoomsPath = [NSString stringWithFormat:@"%@/OperatingRooms.plist", strProjectNumber];
    
    [fileManager writeToPlist:strProjectPath :dictProjectData];
    [fileManager writeToPlist:strContactsPath :dictContactData];
    [fileManager writeToPlist:strProcedureRoomsPath :dictProcedureRoomData];
    
    
}

- (void) datePickerValueChanged : (id) myDatePicker {
    
    NSDateFormatter* dfDate = [[NSDateFormatter alloc] init];
    [dfDate setDateFormat:@"MM/dd/YYYY"];
    
    thisDate = datePicker.date;
    
    for(int i=0; i<arrAllElements.count; i++) {
        if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            OAI_TextField* txtThisField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
            if (txtThisField.isFirstResponder) {
                txtThisField.text = [dfDate stringFromDate:thisDate];
            }
        }
    }
    
    
}



- (void) resetData : (UIButton*) myButton {
    
    for(int i=0; i<arrAllElements.count; i++) {
        
        if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
            txtThisField.text = @"";
            
        } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Checkbox class]]) {
            
            OAI_Checkbox* thisCheckbox = (OAI_Checkbox*)[arrAllElements objectAtIndex:i];
            [thisCheckbox turnCheckOff];
                        
        } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_SimpleCheckbox class]]) {
            
            OAI_SimpleCheckbox* thisCheckbox = (OAI_SimpleCheckbox*)[arrAllElements objectAtIndex:i];
            [thisCheckbox turnCheckOff]; 
          
        } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[UITableView class]]) {
            
            UITableView* tblThisTable = (UITableView*)[arrAllElements objectAtIndex:i];
            
            NSIndexPath *selectedPath = tblThisTable.indexPathForSelectedRow;
            
            [tblThisTable deselectRowAtIndexPath:selectedPath animated:NO];
            
                        
        } else if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_Switch class]]) {
            
            OAI_Switch* swThisSwitch = (OAI_Switch*)[arrAllElements objectAtIndex:i];
            swThisSwitch.selectedSegmentIndex = -1;
            
        }

    }
    
}

- (void) getProjectNumber {
    
    for(int i=0; i<arrAllElements.count; i++) {
        
        if([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
            if ([txtThisField.myLabel isEqualToString:@"Project Number:"]) {
                projectNumber = txtThisField.text;
            }
        }
    }
    
}

- (void) emailData : (UIButton*) myButton {
    
    //dismiss the keyboard
    [self.view endEditing:YES];
    
    BOOL isValid = YES;
    NSMutableString* strErrMsg = [[NSMutableString alloc] initWithString:@"There was an error with your data. Some of the required fields were not saved. Please add information for the following:\n\n"];
    
    NSMutableDictionary* dictMasterData = [[NSMutableDictionary alloc] init];
    
    [self getProjectNumber];
    
    if (projectNumber) { 
        
        //get all the saved data

        NSString* strProjectPath = [NSString stringWithFormat:@"%@/Project_%@.plist", projectNumber, projectNumber];
        
        NSString* strContactPath = [NSString stringWithFormat:@"%@/Contacts.plist", projectNumber];
        
        NSString* strProcedurePath = [NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber];
        
        
        //get the main project data
        NSDictionary* dictProjectData = [fileManager readPlist:strProjectPath];
        NSDictionary* dictContactData = [fileManager readPlist:strContactPath];
        NSDictionary* dictProcedureData = [fileManager readPlist:strProcedurePath];
        NSDictionary* dictAccountData = [fileManager readPlist:@"UserAccount.plist"];
        
        if (dictAccountData.count == 0) {
            isValid = NO;
            [strErrMsg appendString:@"You must enter your account data.\n\n"];
        }
        
        if (dictContactData.count == 0) {
            isValid = NO;
            [strErrMsg appendString:@"You must enter at least one contact.\n\n"];
        }
        
       if (dictProcedureData.count == 0) {
            isValid = NO;
            [strErrMsg appendString:@"You must enter at least one procedure room.\n\n"];
        }
        
        
        if(dictProjectData.count > 0) {
            //validate the data
            for(NSString* strThisKey in dictProjectData) {
                
                //loop through the required elements
                for(int r=0; r<arrRequiredElements.count; r++) {
                    
                    //get the dict and then the field name
                    NSDictionary* dictThisElementInfo = [arrRequiredElements objectAtIndex:r];
                    
                    
                    NSString* strFieldName = [dictThisElementInfo objectForKey:@"Field Name"];
                    
                    //check for a match
                    if ([strThisKey isEqualToString:strFieldName]) {
                        
                        //on a match, get the saved data
                        NSString* strFieldValue = [dictProjectData objectForKey:strThisKey];
                        
                        if (!strFieldValue || strFieldValue == nil || [strFieldValue isEqualToString:@"-1"] ||[strFieldValue isEqualToString:@"No Entry"] || [strFieldValue isEqualToString:@""]) {
                            
                            [strErrMsg appendString:[NSString stringWithFormat:@"%@\n\n", strThisKey]];
                            isValid = NO;
                        }
                    }
                    
                }
                
            }
            
            //check the AVP/UCES/UCES+ checkboxes
            
            if (!isValid) {
                
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle: @"Email Error!"
                           message: strErrMsg
                          delegate: self
                 cancelButtonTitle: @"OK"
                 otherButtonTitles: nil];
                [alert show];
                
            } else { 
            
            //put into master dictionary
            
                [dictMasterData setObject:dictProjectData forKey:@"Project Data"];
                
                //get the other dictionaries and add them to the master
                NSString* strContactPath = [NSString stringWithFormat:@"%@/Contacts.plist", projectNumber];
                NSString* strProcedurePath = [NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber];
                NSString* strLocationsPath = [NSString stringWithFormat:@"%@/Locations.plist", projectNumber];
                
                NSDictionary* dictContacts = [fileManager readPlist:strContactPath];
                NSDictionary* dictProcedureRooms = [fileManager readPlist:strProcedurePath];
                NSDictionary* dictLocations = [fileManager readPlist:strLocationsPath];
                
                if (dictContacts){ 
                    [dictMasterData setObject:dictContacts forKey:@"Contacts"];
                }
                
                if (dictProcedureRooms) { 
                    [dictMasterData setObject:dictProcedureRooms forKey:@"Procedure Rooms"];
                }
                
                if (dictLocations) {
                    [dictMasterData setObject:dictLocations forKey:@"Locations"];
                }
                
                if(dictAccountData) {
                    [dictMasterData setObject:dictAccountData forKey:@"Account Data"];
                }
            
                //send to mail manager to parse into html
                mailManager.dictProjectData = dictMasterData;
                mailManager.arrAllElements = arrAllElements;
                mailManager.strProjectNumber = projectNumber;
                NSString* strMailBody = [mailManager composeMailBody];
                
                NSString* strEmailSubject = [NSString stringWithFormat:@"AVI Inspection Site Report for: %@", projectNumber];
            
                //mail it
                //check to make sure the app can send email
                if ([MFMailComposeViewController canSendMail]) {
                    
                    //init a mail view controller
                    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                    
                    NSArray* ccRecipients = [[NSArray alloc] initWithObjects:@"douglas.curry@olympus.com", @"lisa.webb@olympus.com", nil];
                    
                    NSArray* bccRecipients = [[NSArray alloc] initWithObjects:@"steve.suranie@olympus.com", nil];
                    
                    [mailViewController setCcRecipients:ccRecipients];
                    [mailViewController setBccRecipients:bccRecipients];
                    
                    //set delegate
                    mailViewController.mailComposeDelegate = self;
                    
                    [mailViewController setSubject:strEmailSubject];
                    
                    [mailViewController setMessageBody:strMailBody isHTML:YES];
                    
                    NSString* strPDFTitle = [NSString stringWithFormat:@"SiteInspectionReport_%@.pdf", projectNumber];
                    
                    pdfManager.projectNumber = projectNumber;
                    pdfManager.dictPDFData = dictMasterData;
                    
                    [pdfManager makePDF:strPDFTitle :dictMasterData];
                                        
                    //get path to pdf file
                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString* documentsDirectory = [paths objectAtIndex:0];
                    NSString* pdfFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", projectNumber, strPDFTitle]];
                    
                    //convert pdf file to NSData
                    NSData* pdfData = [NSData dataWithContentsOfFile:pdfFilePath];
                                        
                    //attach the pdf file
                    [mailViewController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:strPDFTitle];
                    
                    
                    //attach the plist
                    
                    //create master plist
                    NSString* strMasterPlistFile = [NSString stringWithFormat:@"%@_Master.plist", projectNumber];
                    NSString* masterPlistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", projectNumber, strMasterPlistFile]];
                    
                    //create the plist file
                    //NSFileManager *fileManager = [NSFileManager defaultManager];
                    [dictMasterData writeToFile: masterPlistFilePath atomically:YES];
                                    
                    NSData* masterData = [NSData dataWithContentsOfFile:masterPlistFilePath];
                    [mailViewController addAttachmentData:masterData mimeType:@"plist" fileName:strMasterPlistFile];
                    
                    [self presentViewController:mailViewController animated:YES completion:NULL];
                    
                } else {
                    
                    NSLog(@"Device is unable to send email in its current state.");
                    
                }

            }
            
        } else {
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Email Error!"
                message: [NSString stringWithFormat:@"There is no project data for project: %@", projectNumber]
                      delegate: self
             cancelButtonTitle: @"OK"
             otherButtonTitles: nil];
            [alert show];
            
        }
    
        
        
    } else {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Email Error!"
        message: @"You cannot email data without a project number!"
        delegate: self
         cancelButtonTitle: @"OK"
         otherButtonTitles: nil];
        [alert show];
        
        
    }

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    
    switch (result){
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email was sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Manage Buttons 

- (void) buttonManager:(UIButton *)myButton {
    
    int myTag = myButton.tag;
    BOOL hasError = NO;
    OAI_ModalDisplay* thisModal;
    NSString* strErrMsg;
    
    //check to see if we loaded a value into the project number field
    for(int i=0; i<arrAllElements.count; i++) {
        
        if ([[arrAllElements objectAtIndex:i] isMemberOfClass:[OAI_TextField class]]) {
            
            OAI_TextField* txtThisTextField = (OAI_TextField*)[arrAllElements objectAtIndex:i];
            
            if ([txtThisTextField.myLabel isEqualToString:@"Project Number:"]) {
                projectNumber = txtThisTextField.text;
            }
        }
    }
    
    if (projectNumber) { 
    
        if (myTag == 101) {
            
            thisModal = vAddContact;
            
        } else if (myTag == 102) {
            
            thisModal = vGetContacts;
            
            //get the contact list
            NSMutableDictionary* dictResults = [dataManager getData:projectNumber:@"Contact Data"];
            
            //check for success or fail
            NSString* strResult = [dictResults objectForKey:@"Result"];
            
            if([strResult isEqualToString:@"Fail"]) {
                hasError = YES;
                strErrMsg = [dictResults objectForKey:@"Error Message"];
            } else {
                [self displayContacts:[dictResults objectForKey:@"Data"]];
            }
    
        } else if (myTag == 103) {
            
            thisModal = vAddProcedureRoom;
            thisModal.strModalTitle = @"Add Procedure Room";
            [thisModal reloadMyTitleBar];
            
        } else if (myTag == 104) {
            
            thisModal = vGetSavedRooms;
            
            NSDictionary* dictSavedRooms = [fileManager readPlist:[NSString stringWithFormat:@"%@/OperatingRooms.plist", projectNumber]];
            
            if (dictSavedRooms.count == 0) {
                hasError = YES;
                strErrMsg = @"There are no saved rooms to edit.";
            } else {
                
                vAddProcedureRoom.strModalTitle = @"Edit Procedure Room";
                
                [self displaySavedRooms:dictSavedRooms];
            }
            
        }
        
        //if there are no errors show animation, otherwise show alert
        if (!hasError) { 
            
            [self animationManager:thisModal:nil];
        
        } else {
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error!"
               message: strErrMsg
              delegate: self
             cancelButtonTitle: @"OK"
             otherButtonTitles: nil];
            [alert show];
       
        }
        
    } else {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Error!"
            message: @"You cannot perform this action without a project number!"
              delegate: self
     cancelButtonTitle: @"OK"
     otherButtonTitles: nil];
        [alert show];
        
    }
   
    
}

#pragma mark - Animation Manager 

- (void) animationManager : (OAI_ModalDisplay*) vThisModal : (UIView*) vThisView {
    
    float alpha = 0.0;
    float viewY = 0.0;
    BOOL isHiding = NO;
    
    if (vThisModal) {
                        
            if (vThisModal.tag == 602) {
                viewY = 40.0;
            } else if (vThisModal.tag == 603) {
                viewY = 140.0;
            } else {
                viewY = 200.0;
            }
                        
            //get the location of the view
            CGRect vModalFrame = vThisModal.frame;
            
            if (vModalFrame.origin.x <0) {
                vModalFrame.origin.x = (self.view.frame.size.width/2)-(vModalFrame.size.width/2);
                vModalFrame.origin.y = viewY;
                vThisModal.frame = vModalFrame;
                alpha = 1.0;
            } else {
                vModalFrame.origin.x = 0-vModalFrame.size.width;
                vModalFrame.origin.y = 0-vModalFrame.size.height;
                alpha = 0.0;
                isHiding = YES;
            }
            
            [UIView animateWithDuration:0.4
                    delay:0
                    options:UIViewAnimationOptionCurveEaseIn
             
                    animations:^(void){
                        vThisModal.alpha = alpha;
                    }
             
                    completion:^(BOOL Finished){
                        if (isHiding) {
                            vThisModal.frame = vModalFrame;
                        }
                    }
             ];

    } else if (vThisView) {
        
        //toggle the view
        CGRect viewFrame = vThisView.frame;
        if (viewFrame.origin.y == -350.0) {
            viewFrame.origin.y = 0;
            alpha = 0.0;
        } else {
            isHiding = YES;
            viewFrame.origin.y = -1*viewFrame.size.height;
            alpha = 1.0;
        }
        
        [UIView animateWithDuration:0.4
              delay:0
            options:UIViewAnimationOptionCurveEaseIn

         animations:^(void){
             vThisView.frame = viewFrame;
         }

         completion:^(BOOL Finished){
             if (isHiding) {
                 vThisView.alpha = alpha;
             }
         }
        ];
            
    }
}

#pragma mark - Scroll View Methods

- (void) scrollToView : (UISegmentedControl*) myControl {
    
    //close keyboard
    [self.view endEditing:YES];
    
    //get the selected index from the segemented control
    int selectedIndex = myControl.selectedSegmentIndex + 1;
    
    //set up a point
    float pageX = selectedIndex * 768.0;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //reset the my origi offset (so when keyboard is dismissed scroll remains on page)
    myScrollViewOrigiOffSet = scrollOffset;
    
    //light up the first tab in the subsections tabs
    if (selectedIndex == 4) {
        [scSubSections setSelectedSegmentIndex:0];
    }
    
    //move the scroll offset to that point
    [scrollManager setContentOffset:scrollOffset animated:YES];
    
    //reset the subsection scroll and sc
    [scSubSections setSelectedSegmentIndex:-1];
    [svSubSections setContentOffset:CGPointMake(0.0, 0.0)];
    
    
}

- (void) scrollToViewFromData:(int)pageIndex {
    
    //close keyboard
    [self.view endEditing:YES];
    
    //set up a point
    float pageX = pageIndex * 768.0;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //move the scroll offset to that point
    [scrollManager setContentOffset:scrollOffset animated:YES];
}

- (void) scrollToSubSection : (UISegmentedControl*) myControl {
 
    //close keyboard
    [self.view endEditing:YES];
    
    //get the selected index from the segemented control
    int selectedIndex = myControl.selectedSegmentIndex;
    
    //set up a point
    float pageX = selectedIndex * 708.0;
    float pageY = 0.0;
    CGPoint scrollOffset = CGPointMake(pageX, pageY);
    
    //move the scroll offset to that point
    [svSubSections setContentOffset:scrollOffset animated:YES];
}

#pragma mark - Segemented Control Methods

- (void) resizeSegmentedControlSegments : (int) myControl {
    
    
    if (myControl == 1) { 
    
        NSArray* segments = scNav.subviews;
    
        //loop
        for(int i=0; i<segments.count; i++) {
            
            //get the segment
            UIView* aSegment = [segments objectAtIndex:i];
            //get the segment subviews
            NSArray* aSegmentSubviews = aSegment.subviews;
            
            //loop
            for(UILabel* segmentLabel in aSegmentSubviews) {
                
                //make sure it is a UILabel
                if ([segmentLabel isKindOfClass:[UILabel class]]) {
                    
                    //get the text value
                    NSString* segmentText = segmentLabel.text;
                    
                    CGSize segmentTextSize = [segmentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
                    
                    [scNav setWidth:segmentTextSize.width-5.0 forSegmentAtIndex:i];
                    
                }
            }
            
        }
    
    } else {
        
        NSArray* segments = scSubSections.subviews;
        
        //loop
        for(int i=0; i<segments.count; i++) {
            
            //get the segment
            UIView* aSegment = [segments objectAtIndex:i];
            //get the segment subviews
            NSArray* aSegmentSubviews = aSegment.subviews;
            
            //loop
            for(UILabel* segmentLabel in aSegmentSubviews) {
                
                //make sure it is a UILabel
                if ([segmentLabel isKindOfClass:[UILabel class]]) {
                    
                    //get the text value
                    NSString* segmentText = segmentLabel.text;
                    
                    CGSize segmentTextSize = [segmentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
                    
                    [scSubSections setWidth:segmentTextSize.width+20.0 forSegmentAtIndex:i];
                    
                }
            }
            
        }

    }

    
}

#pragma mark - Table View Management
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrStates.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [arrStates objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [colorManager setColor:66.0 :66.0 :66.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    strSelectedState = [arrStates objectAtIndex:indexPath.row];
}

#pragma mark - TextField Methods

- (void)textFieldDidEndEditing:(OAI_TextField *)textField {
    
    [textField resignFirstResponder];
    
    if ([textField.myLabel isEqualToString:@"Project Number:"]) {
        projectNumber = textField.text;
    }
    
    
    
}

- (void)textFieldDidBeginEditing:(OAI_TextField *)textField {
    
    nextTag = textField.tag + 1;
    
    if([textField.myLabel rangeOfString:@"Date"].location !=NSNotFound) {
        
        NSDateFormatter* dfDate = [[NSDateFormatter alloc] init];
        [dfDate setDateFormat:@"MM/dd/YYYY"];
        
        NSDate *date = [NSDate date];
        textField.text = [dfDate stringFromDate:date];
        
    }
}

- (BOOL)textFieldShouldReturn:(OAI_TextField *)textField {
    
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

#pragma mark - Alert Methods

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (actionSheet.tag == 311) {
        
        if (buttonIndex == 0) {
            
            [self parseAttachedData];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
