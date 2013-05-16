//
//  OAI_PDFManager.m
//  EUS Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import "OAI_PDFManager.h"

@implementation OAI_PDFManager {
    
    CGSize pageSize;
}

@synthesize strTableTitle, dictResults, projectNumber;

+(OAI_PDFManager *)sharedPDFManager {
    
    static OAI_PDFManager* sharedPDFManager;
    
    @synchronized(self) {
        
        if (!sharedPDFManager)
            
            sharedPDFManager = [[OAI_PDFManager alloc] init];
        
        return sharedPDFManager;
        
    }
    
}

-(id)init {
    return [self initWithAppID:nil];
}

-(id)initWithAppID:(id)input {
    if (self = [super init]) {
        
        /* perform your post-initialization logic here */
        colorManager = [[OAI_ColorManager alloc] init];
        stringManager = [[OAI_StringManager alloc] init];
    }
    return self;
}

- (void) makePDF : (NSString*) fileName : (NSDictionary*) results {
    
    pageSize = CGSizeMake(612, 792);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", projectNumber, fileName]];
    
    [self generatePdfWithFilePath:pdfFileName:results];
    
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath : (NSDictionary*) results {
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    BOOL done = NO;
    
    do {
        
        //set up dictionaries
        //NSLog(@"%@", results);
        NSDictionary* dictProject = [results objectForKey:@"Project Data"];
        NSDictionary* dictOR = [results objectForKey:@"Procedure Rooms"];
        NSDictionary* dictLocations = [results objectForKey:@"Locations"];
        NSDictionary* dictContacts = [results objectForKey:@"Contacts"];
        
        /*//had to do this here because there's some glitch with the dict and the ceiling entry
        NSString* strCeiling;
        for(NSString* strThisKey in dictOR) {
            if ([strThisKey isEqualToString:@"Ceiling:"]) {
                strCeiling = [dictOR objectForKey:strThisKey];
            }
        }*/
        
        //get hospital name
        //NSString* strHospitalName = [dictProject objectForKey:@"Hospital  Name:"];
        
        //set up our font styles
        UIFont* headerFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        UIFont* contentFont = [UIFont fontWithName:@"Helvetica" size:9.0];
        
        
        //set up a some constraints
        CGSize pageConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
        CGSize col1Constraint = CGSizeMake(300.0, 999.0);
        CGSize col2Constraint = CGSizeMake(100.0, 999.0);
        CGSize contactConstraint = CGSizeMake(200.0, 999.0);
        
        NSString* strSection;
        CGRect sectionFrame;
        CGSize sectionConstraint;
        float textY;
        float textX;
        
        //set up a color holder
        UIColor* textColor;
        UIColor* bgRectColor;
        
        //set up a line width holder
        float lineWidth;
        CGPoint bgRectStartPoint;
        CGPoint bgRectEndPoint;
        
        //set up data fields
        //NSArray* arrSections = [[NSArray alloc] initWithObjects:@"Site Information", @"ENDOALPHA Solution", @"Hospital Information", @"Pre-Install Checklist", nil];
        NSArray* arrInfoFields = [[NSArray alloc] initWithObjects:@"Project Number:", @"Inspection Date:", @"Prepared By:", @"Revised Date:", @"Revised By:",nil];
        NSArray* arrENDOALPHAFields = [[NSArray alloc] initWithObjects:@"AVP", @"UCES", @"UCES+", @"SD Recording", @"HD Recording", nil];
        NSArray* arrHospitalFields = [[NSArray alloc] initWithObjects:@"Hospital  Name:", @"Address:", @"City:", @"State", @"Zip:", nil];
        
        NSArray* arrENDOALPHAControl = [[NSArray alloc] initWithObjects:@"Cabling length does not exceed approx 130ft. between AV equipment to AVP Rack:", @"Hospital representative agreed to cable:", @"Placement of AVP agreed by hospital representative in accordance to installation manual:", @"Placement of Touch Panels agreed by hospital:", @"Audio and Video interfaces requirements and specifications have been discussed:", @"Data interfaces requirements and specifications have been discussed:", @"Other pre-installation requirements checked:", @"ENDOALPHA_Control_Comments", nil];
        NSArray* arrENDOALPHAVideo = [[NSArray alloc] initWithObjects:@"Pre-installation requirements checked:", @"Cabling route agreed:", @"Placement of Recording Device agreed by hospital:", @"Video interfaces requirements and specifications have been discussed:", @"Data interfaces requirements and specifications have been discussed:", @"ENDOALPHA_Video_Comments", nil];
        NSArray* arrBoomCompany = [[NSArray alloc] initWithObjects: @"Site was inspected by boom company:", @"Type of Boom (Model Number):", @"Tentative Install Dates:", @"Boom_Company_Comments", nil];
        NSArray* arrSafety = [[NSArray alloc] initWithObjects:@"Construction:", @"Is Olympus Required For Tear Out:", @"Safety glasses required:", @"Safety shoes required:", @"Hard hat required:", @"Hearing protection required:", @"Scrubs required:", @"Safety_Comments", nil];
        NSArray* arrDocuments = [[NSArray alloc] initWithObjects:@"2D Floor Plan:", @"Electrical Installation Scheme:", @"Facility Drawing:", @"Other:", nil];
        NSArray* arrPreInstallSections = [[NSArray alloc] initWithObjects:@"ENDOALPHA", @"Video", @"Boom Company", @"Safety", @"Documents", nil];
        
        NSArray* arrORField = [[NSArray alloc] initWithObjects:@"Length (ft)", @"Width (ft)",  @"True Ceiling Height (ft)", @"False Ceiling Height (ft)", @"Ceiling:", @"Procedure Room Bldg.", @"Procedure Room Floor", @"Procedure Room Dept.", @"Procedure Room No.", @"Number of Monitors", @"Types of Monitors", @"Wall Location", nil];
        
        NSArray* arrLocatonFields = [[NSArray alloc] initWithObjects:@"Location ID", @"Other Location Building", @"Floor", @"Department", @"Name of Room", @"Distance From OR (ft)", @"Signal Connection", @"Network", @"AV Equipment", nil];
        
        NSArray* arrContactFilds = [[NSArray alloc] initWithObjects:@"Contact Name", @"Contact Phone", @"Contact Email", @"Contact Title", @"Main Contact", nil];
        
        NSArray* arrPreInstallFields = [[NSArray alloc] initWithObjects: arrENDOALPHAControl, arrENDOALPHAVideo, arrBoomCompany, arrSafety, arrDocuments, nil];

        //O logo
        UIImage* imgLogo = [UIImage imageNamed:@"OA_img_logo_pdf.png"];
        
        /*************************COVER PAGE*********************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add the olympus logo to top of page
        CGRect imgLogoFrame = CGRectMake(312-(imgLogo.size.width/2), (pageSize.height/3), imgLogo.size.width, imgLogo.size.height);
        [self drawImage:imgLogo :imgLogoFrame];
        
        NSString* strPDFTitle = [NSString stringWithFormat:@"AVI Site Inspection Report for \n%@", projectNumber];
        textColor = [colorManager setColor:8 :16 :123];
        CGSize PDFTitleSize = [strPDFTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect PDFTitleFrame = CGRectMake((pageSize.width/2)-(PDFTitleSize.width/2), imgLogoFrame.origin.y + imgLogoFrame.size.height + 50.0, PDFTitleSize.width, PDFTitleSize.height);
        [self drawText:strPDFTitle :PDFTitleFrame :headerFont :textColor :1];
        
        
        /*********************PAGE 1****************************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add page title
        NSString* strPageTitle = [NSString stringWithFormat:@"Site Integration Checklist for \n%@", projectNumber];
        CGSize pageTitleSize = [strPageTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect pageTitleFrame = CGRectMake((pageSize.width/2)-(pageTitleSize.width/2), 30.0, pageTitleSize.width, pageTitleSize.height);
        textColor = [colorManager setColor:8 :16 :123];
        [self drawText:strPageTitle :pageTitleFrame :headerFont:textColor:1];
        
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,pageTitleFrame.origin.y+pageTitleFrame.size.height + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), pageTitleFrame.origin.y+pageTitleFrame.size.height + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        NSString* strSiteInfo = @"Site Information";
        sectionConstraint = [strSiteInfo sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSiteInfo :sectionFrame :headerFont:textColor:0];
        
        textY = sectionFrame.origin.y + sectionFrame.size.height + 10.0;
        textX = kMarginInset + 5.0;
        for(int i=0; i<arrInfoFields.count; i++) {
            
            
            NSString* strKey = [arrInfoFields objectAtIndex:i];
            NSString* strValue = [dictProject objectForKey:strKey];
            
            //draw key
            CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strKey :keyFrame :contentFont:textColor:0];
            
            //change x
            textX = 400.0;
            
            //draw value
            CGSize valueSize = [strValue sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strValue :valueFrame :contentFont:textColor:0];
            
            //increment y
            textY = textY + 30.0;
            
            //reset x
            textX = kMarginInset+5.0;
        }
        
        //HOSPITAL INFORMATION
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        strSection = @"Hospital Information";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        
        textY = sectionFrame.origin.y + sectionFrame.size.height + 10.0;
        textX = kMarginInset + 5.0;
        for(int i=0; i<arrENDOALPHAFields.count; i++) {
            
            NSString* strKey = [arrHospitalFields objectAtIndex:i];
            NSString* strValue = [dictProject objectForKey:strKey];
            
            //draw key
            CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strKey :keyFrame :contentFont:textColor:0];
            
            //change x
            textX = 400.0;
            
            //draw value
            CGSize valueSize = [strValue sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strValue :valueFrame :contentFont:textColor:0];
            
            //increment y
            textY = textY + 30.0;
            
            //reset x
            textX = kMarginInset+5.0;
        }
        
        //CONTACT INFORMATION
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        strSection = @"Contact Information";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        textY = textY + 30.0;
        for(NSString* strThisContact in dictContacts) {
            
            NSDictionary* thisContactData = [dictContacts objectForKey:strThisContact];
            
            //add yellow background for pre install sections
            bgRectColor = [colorManager setColor:249 :234 :195];
            bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
            bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
            lineWidth = kLineWidth*20;
            [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
            
            //add section title
            strSection = [NSString stringWithFormat:@"Contact Data: %@", strThisContact];
            sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strSection :sectionFrame :headerFont:textColor:0];
            
            textY = textY + 45.0;
            for(int i=0; i<arrContactFilds.count; i++) {
                
                NSString* strKey = [arrContactFilds objectAtIndex:i];
                NSString* strValue = [thisContactData objectForKey:strKey];
                
                //draw key
                CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strKey :keyFrame :contentFont:textColor:0];
                
                //change x
                textX = 400.0;
                
                //draw value
                CGSize valueSize = [strValue sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strValue :valueFrame :contentFont:textColor:0];
                
                //increment y
                textY = textY + 20.0;
                
                //reset x
                textX = kMarginInset+5.0;
            }
        }
        
        //page 3
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        textY = kBorderInset;

        
        //ENDOALPHA SOLUTION
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        strSection = @"ENDOALPHA Solution";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        
        textY = sectionFrame.origin.y + sectionFrame.size.height + 10.0;
        textX = kMarginInset + 5.0;
        for(int i=0; i<arrENDOALPHAFields.count; i++) {
            
            NSString* strKey = [arrENDOALPHAFields objectAtIndex:i];
            NSString* strValue = [dictProject objectForKey:strKey];
            
            //draw key
            CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strKey :keyFrame :contentFont:textColor:0];
            
            //change x
            textX = 400.0;
            
            //draw value
            CGSize valueSize = [strKey sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strValue :valueFrame :contentFont:textColor:0];
            
            //increment y
            textY = textY + 30.0;
            
            //reset x
            textX = kMarginInset+5.0;
        }
        
        //page 3
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        textY = kBorderInset;
        
        //PRE INSTALL CHECKLIST - top of page textY does not increment, others will
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        strSection = @"Pre-Install Checklist";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        for(int x=0; x<arrPreInstallSections.count; x++) {
            
            if (x<2) {
                CGSize pageConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
                
                //add yellow background for pre install sections
                bgRectColor = [colorManager setColor:249 :234 :195];
                bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
                bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
                lineWidth = kLineWidth*20;
                [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
                
                //add section title
                strSection = [arrPreInstallSections objectAtIndex:x];
                sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
                sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strSection :sectionFrame :headerFont:textColor:0];
                
                //show data
                NSArray* arrSectionData = [arrPreInstallFields objectAtIndex:x];
                
                //loop through data
                textY = textY+ 60;
                for(int y=0; y<arrSectionData.count; y++) {
                    
                    NSString* strKey = [arrSectionData objectAtIndex:y];
                    NSString* strValue = [dictProject objectForKey:strKey];
                    
                    //draw key
                    CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strKey :keyFrame :contentFont:textColor:0];
                    
                    //change x
                    textX = 400.0;
                    
                    //draw value
                    CGSize valueSize = [strKey sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strValue :valueFrame :contentFont:textColor:0];
                    
                    //increment y
                    textY = textY + 40.0;
                    
                    //reset x
                    textX = kMarginInset+5.0;
                    
                }
                
            } else if (x > 1) {
                
                //new page
                if (x==2) {
                    //page 4
                    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
                    textY = kBorderInset;
                }
                
                //add yellow background for pre install sections
                bgRectColor = [colorManager setColor:249 :234 :195];
                bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
                bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
                lineWidth = kLineWidth*20;
                [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
                
                //add section title
                strSection = [arrPreInstallSections objectAtIndex:x];
                sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
                sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strSection :sectionFrame :headerFont:textColor:0];
                
                //show data
                NSArray* arrSectionData = [arrPreInstallFields objectAtIndex:x];
                
                //loop through data
                textY = textY+ 60;
                for(int y=0; y<arrSectionData.count; y++) {
                    
                    NSString* strKey = [arrSectionData objectAtIndex:y];
                    NSString* strValue = [dictProject objectForKey:strKey];
                    
                    //draw key
                    CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strKey :keyFrame :contentFont:textColor:0];
                    
                    //change x
                    textX = 400.0;
                    
                    //draw value
                    CGSize valueSize = [strKey sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strValue :valueFrame :contentFont:textColor:0];
                    
                    //increment y
                    textY = textY + 30.0;
                    
                    //reset x
                    textX = kMarginInset+5.0;
                }
            }
            
            
        }
        
        //page 5
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        textY = kBorderInset;
        
        //OR INFORMATION
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        strSection = @"Operating Room Information";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        textY = textY + 30.0;
        for(NSString* strThisOR in dictOR) {
            
            NSDictionary* thisORData = [dictOR objectForKey:strThisOR];
            
            //add yellow background for pre install sections
            bgRectColor = [colorManager setColor:249 :234 :195];
            bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
            bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
            lineWidth = kLineWidth*20;
            [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
            
            //add section title
            strSection = [NSString stringWithFormat:@"Operating Room: %@", strThisOR];
            sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strSection :sectionFrame :headerFont:textColor:0];
            
            textY = textY + 45.0;
            for(int i=0; i<arrORField.count; i++) {
             
                NSString* strKey = [arrORField objectAtIndex:i];
                NSString* strValue = [thisORData objectForKey:strKey];
                
                if ([strKey isEqualToString:@"Ceiling:"]) {
                    if ([strValue isEqualToString:@"0"]) {
                        strValue = @"Hatch";
                    } else if ([strValue isEqualToString:@"1"]) {
                        strValue = @"Drop Ceiling";
                    } else if ([strValue isEqualToString:@"2"]) {
                        strValue = @"Sealed";
                    }
                }
                                
                
                //draw key
                CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strKey :keyFrame :contentFont:textColor:0];
                
                //change x
                textX = 400.0;
                
                //draw value
                CGSize valueSize = [strValue sizeWithFont:headerFont constrainedToSize:contactConstraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strValue :valueFrame :contentFont:textColor:0];
                
                //increment y
                textY = textY + 20.0;
                
                //reset x
                textX = kMarginInset+5.0;
            }
        }
        
        if (dictLocations.count > 0) {
            
            //page 6
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            textY = kBorderInset;
        
            //Location INFORMATION
            bgRectColor = [colorManager setColor:192 :205 :255];
            bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
            bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
            lineWidth = kLineWidth*20;
            [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
            
            //add section title
            strSection = @"Location Information";
            sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strSection :sectionFrame :headerFont:textColor:0];
            
            textY = textY + 30.0;
            for(NSString* strThisLocation in dictLocations) {
                
                NSDictionary* thisLocationData = [dictLocations objectForKey:strThisLocation];
                
                //add yellow background for pre install sections
                bgRectColor = [colorManager setColor:249 :234 :195];
                bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
                bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
                lineWidth = kLineWidth*20;
                [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
                
                //add section title
                strSection = [NSString stringWithFormat:@"Location Room: %@", strThisLocation];
                sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
                sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strSection :sectionFrame :headerFont:textColor:0];
                
                textY = textY + 45.0;
                for(int i=0; i<arrLocatonFields.count; i++) {
                    
                    NSString* strKey = [arrLocatonFields objectAtIndex:i];
                    NSString* strValue = [thisLocationData objectForKey:strKey];
                    
                    //draw key
                    CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strKey :keyFrame :contentFont:textColor:0];
                    
                    //change x
                    textX = 400.0;
                    
                    //draw value
                    CGSize valueSize = [strKey sizeWithFont:headerFont constrainedToSize:col2Constraint lineBreakMode:NSLineBreakByWordWrapping];
                    CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                    textColor = [colorManager setColor:66.0 :66.0 :66.0];
                    [self drawText:strValue :valueFrame :contentFont:textColor:0];
                    
                    //increment y
                    textY = textY + 20.0;
                    
                    //reset x
                    textX = kMarginInset+5.0;
                }
            }
        }
        
        //page 7
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        textY = kBorderInset;
        
        //CONTACT INFORMATION
        bgRectColor = [colorManager setColor:192 :205 :255];
        bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
        bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
        lineWidth = kLineWidth*20;
        [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
        
        //add section title
        /*strSection = @"Contact Information";
        sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
        textColor = [colorManager setColor:66.0 :66.0 :66.0];
        [self drawText:strSection :sectionFrame :headerFont:textColor:0];
        
        textY = textY + 30.0;
        for(NSString* strThisContact in dictContacts) {
            
            NSDictionary* thisContactData = [dictContacts objectForKey:strThisContact];
            
            //add yellow background for pre install sections
            bgRectColor = [colorManager setColor:249 :234 :195];
            bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
            bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
            lineWidth = kLineWidth*20;
            [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
            
            //add section title
            strSection = [NSString stringWithFormat:@"Contact Data: %@", strThisContact];
            sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strSection :sectionFrame :headerFont:textColor:0];
            
            textY = textY + 45.0;
            for(int i=0; i<arrContactFilds.count; i++) {
                
                NSString* strKey = [arrContactFilds objectAtIndex:i];
                NSString* strValue = [thisContactData objectForKey:strKey];
                
                //draw key
                CGSize keySize = [strKey sizeWithFont:headerFont constrainedToSize:col1Constraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect keyFrame = CGRectMake(textX, textY, keySize.width, keySize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strKey :keyFrame :contentFont:textColor:0];
                
                //change x
                textX = 350.0;
                
                //draw value
                CGSize valueSize = [strValue sizeWithFont:headerFont constrainedToSize:contactConstraint lineBreakMode:NSLineBreakByWordWrapping];
                CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
                textColor = [colorManager setColor:66.0 :66.0 :66.0];
                [self drawText:strValue :valueFrame :contentFont:textColor:0];
                
                //increment y
                textY = textY + 20.0;
                
                //reset x
                textX = kMarginInset+5.0;
            }
        }*/
        
        //misc. inof
        
        NSString* strMiscInfo = [dictProject objectForKey:@"Miscellaneous Info:"];
        
        if (strMiscInfo != nil) { 
            NSLog(@"ok");
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            textY = kBorderInset;
            
            //MISC INFORMATION
            bgRectColor = [colorManager setColor:192 :205 :255];
            bgRectStartPoint = CGPointMake(kMarginInset,textY + 30.0);
            bgRectEndPoint = CGPointMake(pageSize.width-(kMarginInset), textY + 30.0);
            lineWidth = kLineWidth*20;
            [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
            
            //add section title
            strSection = @"Miscellaneous Information";
            sectionConstraint = [strSection sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            sectionFrame = CGRectMake(kMarginInset+5.0, bgRectStartPoint.y-8.0, sectionConstraint.width, sectionConstraint.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strSection :sectionFrame :headerFont:textColor:0];
            
            textY = textY + 50.0;
            
            //draw value
            CGSize valueSize = [strMiscInfo sizeWithFont:contentFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect valueFrame = CGRectMake(textX, textY, valueSize.width, valueSize.height);
            textColor = [colorManager setColor:66.0 :66.0 :66.0];
            [self drawText:strMiscInfo :valueFrame :contentFont:textColor:0];
            
        }

        done = YES;
        
    } while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}

#pragma mark - Drawing Methods

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) textColor : (int) textAlignment {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, textColor.CGColor);
    
    int myTextAlignment = textAlignment;
    
    [textToDraw drawInRect:textFrame withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:myTextAlignment];
}

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame  {
    
   [imageToDraw drawInRect:imageFrame];
}

- (void) drawLine : (float) lineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint  {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, lineWidth);
    CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void) drawBorder : (UIColor*) borderColor :  (CGRect) rectFrame {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, kBorderWidth);
    CGContextStrokeRect(currentContext, rectFrame);
    
}

#pragma mark - Data Gather

- (float) getStringHeight : (NSString* ) stringToMeasure : (float) widthConstraint : (UIFont*) thisFont {
    
    CGSize stringConstraint = CGSizeMake(widthConstraint, 9999.0);
    CGSize stringSize = [stringToMeasure sizeWithFont:thisFont constrainedToSize:stringConstraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return stringSize.height;
    
}

- (float) getMaxHeaderHeight : (NSArray*) headers : (UIFont*) font {
    
    //set a max height for the headers
    float maxHeaderH = 0.0;
    
    for(int i=0; i<headers.count; i++) {
        
        float thisConstraint;
        
        if (i==0) {
            thisConstraint = 140.0;
        } else {
            thisConstraint = (pageSize.width-(kMarginInset*2))/2;
        }
        
        float thisStringHeight = [self getStringHeight:[headers objectAtIndex:i] :thisConstraint:font];
        
        if (thisStringHeight > maxHeaderH) {
            maxHeaderH = thisStringHeight;
        }
    }
    
    return maxHeaderH;

}

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) textColor {
    
    for(int i=0; i<headers.count; i++) {
        
        NSString* strThisHeader = [headers objectAtIndex:i];
        
        if (i>0) {
            headerX = headerX + headerW + 5.0;
            
            if (headerW == 140.0) { 
                headerW = 200.0;
            } else if (headerW == 80.0) {
                if (i>1) { 
                    headerW = 140.0;
                    headerX = headerX + 15.0;
                }
            } else if (headerW == 240.0) {
                headerW = 124.0;
            }
        }
        
        CGRect thisHeaderFrame = CGRectMake(headerX, headerY, headerW, headerH);
        [self drawText:strThisHeader :thisHeaderFrame :font:textColor:0];
    }
}

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) lineWidth {
    
    for(int i=0; i<rowHeaders.count; i++) {
    
        //build a row
        UIColor* rowColor;
        if (i%2) {
            rowColor = color1;
        } else {
            rowColor = color2;
        }
    
        if(i>0) {
            rowY = rowY + 40.0;
            endRowY = endRowY + 40.0;
        }
        
        CGPoint rowStartPoint = CGPointMake(rowX, rowY);
        CGPoint rowEndPoint = CGPointMake(endRowX, endRowY);
        [self drawLine:lineWidth:rowColor:rowStartPoint:rowEndPoint];
        
    }

    
}

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) textColor : (UIFont*) font {
    
    for(int r=0; r<rowCellContents.count; r++) {
        
        NSString* thisRowItem = [rowCellContents objectAtIndex:r];
        
        if (r>0) {
            
            //increment x
            strX = strX + strW + 5.0;
            
            if (strW == 140) { 
                //change row w
                strW = 200.0;
            } else if (strW == 80 && r>1) {
                strW = 140.0;
                strX = strX + 15.0;
            }
        }
        
        CGRect thisRowCellFrame = CGRectMake(strX, strY, strW, strH);
        [self drawText:thisRowItem :thisRowCellFrame :font:textColor:0];
        
    }

    
}

- (NSArray* ) gatherCellData : (NSDictionary*) theResults : (NSString* ) key {
    
    //set up an array to hold the keys to pul from theResults
    NSMutableArray* keyArray = [[NSMutableArray alloc] init];
    for(int i=0; i<3; i++) {
        [keyArray addObject:[NSString stringWithFormat:@"%@ Year %i", key, i+1]];
    }
    
    
    
    //loop through results
    for(NSString* thisKey in theResults) {
     
        if([thisKey hasPrefix:key]) {
            NSArray* thisRowCellData = [[NSArray alloc] initWithObjects:[theResults objectForKey:[keyArray objectAtIndex:0]], [theResults objectForKey:[keyArray objectAtIndex:1]], [theResults objectForKey:[keyArray objectAtIndex:2]],nil];
            
            return thisRowCellData;
        }
        
    }
    
    
    NSArray* thisRowCellData;
    return thisRowCellData;
    
}

@end
