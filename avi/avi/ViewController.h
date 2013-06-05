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
    OAI_ModalDisplay* vGetSavedRooms;
    
    UIDatePicker* datePicker;
    NSDate* thisDate;
    
    NSInteger nextTag;
    
    NSDictionary* dictAttachedData;
    
}

@property (nonatomic, retain) NSArray* arrElements;
@property (nonatomic, retain) NSMutableArray* arrMasterTabOrder;

/**
 Takes an array containing a dictionary for each element for each section and builds out the element based on the data in the dictionary - i.e. textfield, checkbox, switch (segemented control). Takes 3 objects, NSArray, UIView and NSString.
 @param NSArray containing the section element dictionaries
 @param UIView the view (within the main scroll view) to display the elements in
 @param NSString the section title
*/

- (void) buildSectionElements : (NSArray*) arrThisSectionElements : (UIView*) vSectionElements : (NSString*) strThisSection;

/**
 Takes an array containing a dictionary for each element for each section, pulls each element for the section and determines the width of the label for that elements. If the width is greater than the current maximum label width it is then the new maximum label width.
 @param NSArray containing the section element dictionaries
 @param NSString the section title
 @returns float the maximum label width for this section
 */

- (float) getMaxLaeblWidth : (NSArray*) arrThisSectionElements : (NSString*) strThisSection;

/**
 Takes a segemnted control and resizes each indexed item (tab) of that control by font and font size.
 @param NSSegmentedControl 
 */

- (void) resizeSegmentedControlSegments : (int) myControl;

/**
 Takes a segemnted control, gets the selected index item, then scrolls a scroll view to the same index page.
 @param NSSegmentedControl
 */

- (void) scrollToView : (UISegmentedControl*) myControl;

/**
 Takes a integer, then scrolls a NSScroll to the corresponding offset that matches that index.
 @param int
 */

- (void) scrollToViewFromData:(int) pageIndex;

/**
 Takes a segemnted control, gets the selected index item, then scrolls a scroll view to the same index page.
 @param NSSegmentedControl
 */


- (void) scrollToSubSection : (UISegmentedControl*) myControl;

/**
 Takes a UIButton and performs actions on modal windows based on the tag number of the UIButton
 @param UIButton
*/

- (void) buttonManager : (UIButton*) myButton;

/**
 Takes either a OAI_MOdalDisplay or a UIView. If passing OAI_ModalDisplay set UIView to nil or vice versa. Animates (displays) the passed object.
 @param OAI_ModalDisplay
 @param UIView
 */

- (void) animationManager : (OAI_ModalDisplay*) vThisModal : (UIView*) vThisView;

/**
 Takes a UIButton (Save Button). Validates the user entered data. If data passes validation it is saved to a plist stored within a directory that has the project number name. 
 @param UIButton
 */

- (void) saveData : (UIButton*) myButton;

/**
 Takes a UIButton (Email Button). Validates the user entered data. If data passes validation it is converted to HTML and embedded in an email message, the data is also converted to a PDF document. All stored plist data is compiled into one plist. The plist and PDF document are attached to the email message. 
 @param UIButton
 */

- (void) emailData : (UIButton*) myButton;

/**
 Takes a NSDictionary (saved project data) and a BOOL (needsAnimation). Loads saved data into site inspection report form. If BOOL == YES, closes any modal displays that are open.
 @param NSDictionary
 @param BOOL
 */

- (void) displayData : (NSDictionary* ) dictThisProject : (BOOL) needsAnimation;

/**
 Takes a NSDictionary (saved contact data) and populates the contact list with the names of the contacts.
 @param NSDictionary
 */

- (void) displayContacts : (NSDictionary*) dictContacts;

/**
 Searches through all the elements of the app, looking for the textfield holding the project number. If textfield has value retrieves it and stores the value in the app.
 
 */

- (void) getProjectNumber;

/**
 Takes a UIButton (Reset Button) and resets all the elements in the app.
 @param UIButton
 */

- (void) resetData : (UIButton*) myButton;

/**
 Takes a id (myDatePicker - object that launches the date picker - in this case it is a textfield). Displays the datepicker and on change of value populates the associated textfield with the date selected.
 @param id
 */

- (void) datePickerValueChanged : (id) myDatePicker;

/**
 Takes a UIButton (load projects) and displays the saved projects in the documents directory.
 @param UIButton
 */

- (void) showSavedProject : (UIButton*) myButton;

/**
 Takes a NSDictionary (saved rooms) and displays the saved rooms for the project.
 @param NSDictionary
 */

- (void) displaySavedRooms : (NSDictionary* ) dictSavedRooms;

/**
 Takes uploaded project data (from email attachment) and checks to see if the project already exists. If so, ask the user if they want to over write the existing project with the new data. If project does not exists calls the parseAttachedData method.
 @param NSDictionary
 */

- (void) examineAttachedData;

/**
 Loads the project data (from email attachment) into the app.
*/
- (void) parseAttachedData; 




@end
