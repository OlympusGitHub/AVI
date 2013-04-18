//
//  OAI_MailManger.m
//  avi
//
//  Created by Steve Suranie on 4/17/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_MailManager.h"

@implementation OAI_MailManager

+(OAI_MailManager *)sharedMailManager {
    
    static OAI_MailManager* sharedMailManager;
    
    @synchronized(self) {
        
        if (!sharedMailManager)
            
            sharedMailManager = [[OAI_MailManager alloc] init];
        
        return sharedMailManager;
        
    }
    
}

- (NSMutableString*) composeMailBody {
    
    NSString* strEvenRowColor = @"#eee";
    NSString* strOddRowColor = @"#FFDDA9";
    
    NSDictionary* dictProject = [_dictProjectData objectForKey:@"Project Data"];
    NSDictionary* dictContacts = [_dictProjectData objectForKey:@"Contacts"];
    NSDictionary* dictProcedureRooms = [_dictProjectData objectForKey:@"Procedure Rooms"];
    NSDictionary* dictLocations = [_dictProjectData objectForKey:@"Locations"];
    
    NSMutableString* strMailBody = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<div><p style=\"font-weight:900; color:#666; font-size:24px; font-family:Helvetica, Arial, sans-serif\">Site Integration Report for %@</p></div>", _strProjectNumber]];
    
    [strMailBody appendString:@"<div><table width=644>"];
    [strMailBody appendString:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Project Data</td></tr>"];
    
    //project info
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Project Number:</td><td <td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Project Number:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Inspection Date:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Inspection Date:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Prepared By:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Prepared By:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Revised Date:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Revised Date:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Revised By:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Revised By:"]]];
    
    //ENDOALPHA Soltuion
    [strMailBody appendString:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">ENDOALPHA Solution</td></tr>"];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">ENDOALPHA Control:</td><td></td></tr>", strEvenRowColor ]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">AVP:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@" AVP"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">UCES:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@" UCES"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">UCES+:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@" UCES+"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">ENDOALPHA Alpha Video:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">SD Recording:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@" SD Recording"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">HD Recording:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@" HD Recording"]]];
    
    //hospital information
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Hospital Information:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Hospital Name:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Hospital  Name:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Street:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Address:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">City:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"City:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">State:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"State"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Zip:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Zip:"]]];
    
    //endo alpha  control
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">ENDOALPHA Control:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Cabeling length does not exceed approx 130ft. between AV equipment to AVP Rack:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Cabeling length does not exceed approx 130ft. between AV equipment to AVP Rack:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Hospital representative agreed to cable:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Hospital representative agreed to cable:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Placement of AVP agreed by hospital representative in accordance to installation manual:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Placement of AVP agreed by hospital representative in accordance to installation manual:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Placement of Touch Panels agreed by hospital:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Placement of Touch Panels agreed by hospital:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Audio and Video interfaces requirements and specifications have been discussed:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Audio and Video interfaces requirements and specifications have been discussed:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Data interfaces requirements and specifications have been discussed:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Data interfaces requirements and specifications have been discussed:"]]];
    
     [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Other pre-installation requirements checked:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Other pre-installation requirements checked:"]]];
    
    //video
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Video:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Pre-installation requirements checked:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Pre-installation requirements checked:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Cabling route agreed:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Cabling route agreed:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Placement of Recording Device agreed by hospital:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Placement of Recording Device agreed by hospital:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Video interfaces requirements and specifications have been discussed:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Video interfaces requirements and specifications have been discussed:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Data interfaces requirements and specifications have been discussed:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Data interfaces requirements and specifications have been discussed:"]]];
    
    
    //BOOM company  
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Boom Company:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Site was inspected by boom company:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Site was inspected by boom company:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Type of Boom (Model Number):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Type of Boom (Model Number):"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Tentative Install Dates:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Tentative Install Dates:"]]];
    
    //BOOM company
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Safety:</td><td></td></tr>"]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Constructon:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Constructon:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Is Olympus Required For Tear Out:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Is Olympus Required For Tear Out:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Safety glasses required:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Safety glasses required:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Safety shoes required:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Safety shoes required:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Hard hat required:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Hard hat required:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Hearing protection required:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictProject objectForKey:@"Hearing protection required:"]]];
    
    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Scrubs required:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictProject objectForKey:@"Scrubs required:"]]];
    
    [strMailBody appendString:@"</table></div>"];
    
    [strMailBody appendString:@"<p><div><table width=644>"];
    [strMailBody appendString:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Contact Data</td></tr>"];
    
    for(NSString* strThisContact in dictContacts) {
        
        NSDictionary* dictThisContact = [dictContacts objectForKey:strThisContact];
        
        //get the contact info
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Contact Name:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisContact objectForKey:@"Contact Name"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Contact Title:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisContact objectForKey:@"Contact Title"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Contact Phone:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisContact objectForKey:@"Contact Phone"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Contact Email:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisContact objectForKey:@"Contact Email"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Contact Phone:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisContact objectForKey:@"Main Contact"]]];
        
        [strMailBody appendString:@"<tr height=10><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">&nbsp;</td></tr>"];
        
    }
    
    [strMailBody appendString:@"</table></div>"];
    
    [strMailBody appendString:@"<p><div><table width=644>"];
    [strMailBody appendString:@"<tr><td colspan=\"2\" style=\"background:#666; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Procedure Rooms</td></tr>"];
    
    for(NSString* strThisProRoom in dictProcedureRooms) {
        
        NSDictionary* dictThisRoom = [dictProcedureRooms objectForKey:strThisProRoom];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Procedure Room ID:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"Procedure Room ID"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Length (ft):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisRoom objectForKey:@"Length (ft)"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Width (ft):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"Width (ft)"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">True Ceiling Height (ft):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisRoom objectForKey:@"True Ceiling Height (ft)"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">False Ceiling Height (ft):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"False Ceiling Height (ft)"]]];
        
        
        int ceilingID = [[dictThisRoom objectForKey:@"OR Building"] intValue];
        NSString* strCeiling;
        if (ceilingID == 0) {
            strCeiling = @"Hatch";
        } else if (ceilingID == 1) {
            strCeiling = @"Drop Ceiling";
        } else if (ceilingID == 2) {
            strCeiling = @"Sealed";
        }
            
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Ceiling:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, strCeiling]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">OR Building:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"OR Building"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">OR Number:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisRoom objectForKey:@"OR Number"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Number of Monitors:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"Number of Monitors"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Types of Monitors:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisRoom objectForKey:@"Types of Monitors"]]];
        
        [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Wall Location:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisRoom objectForKey:@"Wall Location"]]];
        
        
        //get any matching locations for this OR
        for(NSString* strThisLocation in dictLocations) {
            
            NSDictionary* dictThisLocation = [dictLocations objectForKey:strThisLocation];
            
            NSString* strThisLocationOR = [dictThisLocation objectForKey:@"Operating Room ID"];
            
            if ([strThisLocationOR isEqualToString:strThisProRoom]) {
                
                NSString* strThisLocationID = [dictThisLocation objectForKey:@"Location ID"];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td colspan=\"2\" style=\"background:#999; color:#eee; padding:3px; font-weight: 900; font-size:20px;\">Location %@ for Procedure Room %@</td></tr>", strThisLocationID, strThisProRoom]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Location ID:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisLocation objectForKey:@"Location ID"]]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Other Location Building:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisLocation objectForKey:@"Other Location Building"]]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Floor:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisLocation objectForKey:@"Floor"]]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Department:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisLocation objectForKey:@"Department"]]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Name of Room:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisLocation objectForKey:@"Name of Room"]]];
                
                [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Distance From OR (ft):</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisLocation objectForKey:@"Distance From OR (ft)"]]];
                
                
                if([[dictThisLocation objectForKey:@"Signal Connection_checkbox"] isEqualToString:@"YES"]) {
                    
                    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Signal Connection:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisLocation objectForKey:@"Signal Connection_type"]]];
                }
                
                if([[dictThisLocation objectForKey:@"Network_checkbox"] isEqualToString:@"YES"]) {
                    
                    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">Network:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strOddRowColor, strOddRowColor, [dictThisLocation objectForKey:@"Network_type"]]];
                }
                
                if([[dictThisLocation objectForKey:@"AV Equipment_checkbox"] isEqualToString:@"YES"]) {
                    
                    [strMailBody appendString:[NSString stringWithFormat:@"<tr><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">AV Equipment:</td><td style=\"background:%@; color:#666; font-size:14px font-weight:200; padding:2px; font-family: Helvetica, Arial, sans-serif;\">%@</td></tr>", strEvenRowColor, strEvenRowColor, [dictThisLocation objectForKey:@"AV Equipment_type"]]];
                }
                
            }
        }
        
        
    }
    
    [strMailBody appendString:@"</table></div>"];
    
    //NSLog(@"%@", dictLocations);
    return strMailBody;
    
}


@end
