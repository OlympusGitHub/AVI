//
//  ViewController.h
//  avi
//
//  Created by Steve Suranie on 4/15/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>

#import "OAI_MailManager.h"
#import "OAI_States.h"
#import "OAI_Account.h"
#import "OAI_TitleBar.h"
#import "OAI_TitleScreen.h"
#import "OAI_FileManager.h"
#import "OAI_ColorManager.h"
#import "OAI_SplashScreen.h"
#import "OAI_TitleScreen.h"
#import "OAI_DataManager.h"
#import "OAI_PDFManager.h"
#import "OAI_States.h"
#import "OAI_Switch.h"

#import "OAI_ModalDisplay.h"
#import "OAI_NewContactForm.h"
#import "OAI_OperatingRoomForm.h"
#import "OAI_DataList.h"
#import "OAI_ContactList.h"
#import "OAI_ORList.h"
#import "OAI_LocationList.h"


#import "OAI_SimpleCheckbox.h"
#import "OAI_Table.h"
#import "OAI_SectionLabel.h"
#import "OAI_Label.h"
#import "OAI_TextView.h"
#import "OAI_TextField.h"
#import "OAI_ScrollView.h"
#import "OAI_Checkbox.h"
#import "OAI_DateTextField.h"
#import "OAI_SetTabOrder.h"


@interface ViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>{
    
    OAI_SplashScreen* appSplashScreen;
    OAI_ColorManager* colorManager;
    OAI_FileManager* fileManager;
    OAI_PDFManager* pdfManager;
    OAI_TitleBar* titleBarManager;
    OAI_TitleScreen* titleScreenManager;
    OAI_Account* accountManager;
    OAI_ScrollView* scrollManager;
    OAI_DataManager* dataManager;
    OAI_States* statesManager;
    OAI_MailManager* mailManager;
    OAI_SetTabOrder* tabManager;
    
    
    /*********Data************/
    NSMutableArray* arrSectionData;
    NSMutableArray* arrResultsData;
    NSMutableArray* arrAllElements;
    NSMutableArray* arrRequiredElements;
    NSMutableArray* arrSavedProjects;
    NSArray* arrStates;
    NSString* strSelectedState;
    NSString* projectNumber;
    
    /********Nav*************/
    UISegmentedControl* scNav;
    UISegmentedControl* scSubSections;
    OAI_ScrollView* svSubSections;
    CGPoint myScrollViewOrigiOffSet;
    
    OAI_ModalDisplay* vAddContact;
    OAI_ModalDisplay* vGetContacts;
    OAI_ModalDisplay* vAddProcedureRoom;
    OAI_ModalDisplay* vSavedProjects;
    
    UIDatePicker* datePicker;
    NSDate* thisDate;
    
    NSInteger nextTag;
    
}

@property (nonatomic, retain) NSArray* arrElements;
@property (nonatomic, retain) NSMutableArray* arrMasterTabOrder;

- (void) buildSectionElements : (NSArray*) arrThisSectionElements : (UIView*) vSectionElements : (NSString*) strThisSection;

- (float) getMaxLaeblWidth : (NSArray*) arrThisSectionElements : (NSString*) strThisSection;

- (void) resizeSegmentedControlSegments : (int) myControl;

- (void) scrollToView : (UISegmentedControl*) myControl;

- (void) scrollToViewFromData:(int) pageIndex;

- (void) scrollToSubSection : (UISegmentedControl*) myControl;

- (void) buttonManager : (UIButton*) myButton;

- (void) animationManager : (OAI_ModalDisplay*) vThisModal : (UIView*) vThisView;

- (void) saveData : (UIButton*) myButton;

- (void) emailData : (UIButton*) myButton;

- (void) displayData : (NSDictionary* ) dictThisProject;

- (void) displayContacts : (NSDictionary*) dictContacts;

- (void) getProjectNumber;

- (void) resetData : (UIButton*) myButton;

- (void) datePickerValueChanged : (id) myDatePicker;

- (void) showSavedProject : (UIButton*) myButton; 



@end
