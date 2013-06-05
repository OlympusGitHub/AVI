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

@synthesize strTableTitle, projectNumber;

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
    
    [self generatePdfWithFilePath:pdfFileName];
    
}

- (void) generatePdfWithFilePath : (NSString* ) strFileName {

    UIGraphicsBeginPDFContextToFile(strFileName, CGRectZero, nil);

    BOOL done = NO;
    
    NSDictionary* dictProject = [_dictPDFData objectForKey:@"Project Data"];
    NSDictionary* dictProcedureRooms = [_dictPDFData objectForKey:@"Procedure Rooms"];
    NSDictionary* dictContacts = [_dictPDFData objectForKey:@"Contacts"];
    NSDictionary* dictLocations = [_dictPDFData objectForKey:@"Locations"];

    //set up our font styles
    headerFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    contentFont = [UIFont fontWithName:@"Helvetica" size:11.0];

    //set up constraints and frames
    pageConstraint = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);

    lineWidth = 0.0;

    NSArray* arrSections = [[NSArray alloc] initWithObjects:@"Site Information", @"ENDOALPHA Solution", @"Hospital Information", @"Pre-Install Checks", @"Misc. Info.", @"Procedure Rooms", @"Contacts", nil];

    NSArray* arrInfoFields = [[NSArray alloc] initWithObjects:@"Project Number:", @"Inspection Date:", @"Prepared By:", @"Revised Date:", @"Revised By:",nil];
    NSArray* arrENDOALPHAFields = [[NSArray alloc] initWithObjects:@"AVP", @"UCES", @"UCES+", @"SD Recording", @"HD Recording", nil];
    NSArray* arrHospitalFields = [[NSArray alloc] initWithObjects:@"Hospital  Name:", @"Address:", @"City:", @"State", @"Zip:", nil];

    NSArray* arrENDOALPHAControl = [[NSArray alloc] initWithObjects:@"Cabling length does not exceed approx 130ft. between AV equipment to AVP Rack:", @"Hospital representative agreed to cable:", @"Placement of AVP agreed by hospital representative in accordance to installation manual:", @"Placement of Touch Panels agreed by hospital:", @"Audio and Video interfaces requirements and specifications have been discussed:", @"Data interfaces requirements and specifications have been discussed:", @"Other pre-installation requirements checked:", @"ENDOALPHA_Control_Comments", nil];
    NSArray* arrENDOALPHAVideo = [[NSArray alloc] initWithObjects:@"Pre-installation requirements checked:", @"Cabling route agreed:", @"Placement of Recording Device agreed by hospital:", @"Video interfaces requirements and specifications have been discussed:", @"Data interfaces requirements and specifications have been discussed:", @"ENDOALPHA_Video_Comments", nil];
    NSArray* arrBoomCompany = [[NSArray alloc] initWithObjects: @"Site was inspected by boom company:", @"Type of Boom (Model Number):", @"Tentative Install Dates:", @"Boom_Company_Comments", nil];
    NSArray* arrSafety = [[NSArray alloc] initWithObjects:@"Construction:", @"Is Olympus Required For Tear Out:", @"Safety glasses required:", @"Safety shoes required:", @"Hard hat required:", @"Hearing protection required:", @"Scrubs required:", @"Safety_Comments", nil];
    NSArray* arrDocuments = [[NSArray alloc] initWithObjects:@"2D Floor Plan:", @"Electrical Installation Scheme:", @"Facility Drawing:", @"Other:", nil];
    NSArray* arrPreInstallSections = [[NSArray alloc] initWithObjects:@"ENDOALPHA", @"Video", @"Boom Company", @"Safety", @"Documents", nil];

    NSArray* arrORField = [[NSArray alloc] initWithObjects:@"Length (ft)", @"Width (ft)",  @"True Ceiling Height (ft)", @"False Ceiling Height (ft)", @"Ceiling:", @"Procedure Room Bldg.", @"Procedure Room Floor", @"Procedure Room Dept.", @"Procedure Room No.", @"Monitors", @"Wall Location", nil];

    NSArray* arrLocatonFields = [[NSArray alloc] initWithObjects:@"Location ID", @"Other Location Building", @"Floor", @"Department", @"Name of Room", @"Distance From OR (ft)", @"Signal Connection", @"Network", @"AV Equipment", nil];

    NSArray* arrContactFields = [[NSArray alloc] initWithObjects:@"Contact Name", @"Contact Phone", @"Contact Email", @"Contact Title", @"Main Contact", nil];

    NSArray* arrPreInstallFields = [[NSArray alloc] initWithObjects: arrENDOALPHAControl, arrENDOALPHAVideo, arrBoomCompany, arrSafety, arrDocuments, nil];

    NSArray* arrAllSections = [[NSArray alloc] initWithObjects:arrInfoFields, arrENDOALPHAFields, arrHospitalFields, arrPreInstallFields, nil];

    do {
        
        //O logo
        UIImage* imgLogo = [UIImage imageNamed:@"OA_img_logo_pdf.png"];
        
        /*************************COVER PAGE*********************************/
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //add the olympus logo to top of page
        CGRect imgLogoFrame = CGRectMake(312-(imgLogo.size.width/2), (pageSize.height/3), imgLogo.size.width, imgLogo.size.height);
        [self drawImage:imgLogo :imgLogoFrame];
        
        NSString* strPDFTitle = [NSString stringWithFormat:@"AVI Site Inspection Report for %@", projectNumber];
        textColor = [colorManager setColor:8 :16 :123];
        CGSize PDFTitleSize = [strPDFTitle sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
        CGRect PDFTitleFrame = CGRectMake((pageSize.width/2)-(PDFTitleSize.width/2), imgLogoFrame.origin.y + imgLogoFrame.size.height + 50.0, PDFTitleSize.width, PDFTitleSize.height);
        [self drawText:strPDFTitle :PDFTitleFrame :headerFont :textColor :1];
        
        /*************************OTHER PAGES*********************************/
        
        //start new page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        
        //set a content height holder
        contentHeight = kBorderInset;
        newPage = NO;
        
        textY = 40.0;
        textX = kMarginInset;
        
        for(int i=0; i<arrSections.count; i++) {
            
            /*********************ADD THE SECTION HEADERS*********************/
            if (textY > 700.0) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
                textY = 40.0;
            }
            
            NSString* strSiteInfo = [arrSections objectAtIndex:i];
            bgRectColor = [colorManager setColor:192 :205 :255];
            [self makeDivider:strSiteInfo :bgRectColor];
            
            if (i>3) {
                textY = textY + 12.0;
            }
            
            /*********************ADD THE SECTION DATA**************************/
            
            //get the right dictionary to use
            BOOL isContact = NO;
            BOOL isRoom = NO;
            NSDictionary* dictSectionData;
            if ([strSiteInfo isEqualToString:@"Procedure Rooms"]) {
                dictSectionData = dictProcedureRooms;
                isRoom = YES;
            } else if ([strSiteInfo isEqualToString:@"Contacts"]) {
                isContact = YES;
                dictSectionData = dictContacts;
            } else {
                dictSectionData = dictProject;
            }
            
            if (isContact) {
                
                //loop through the contacts
                for(NSString* strContactKey in dictContacts) {
                    
                    NSDictionary* dictThisContact = [dictContacts objectForKey:strContactKey];
                    
                    [self makeRow:arrContactFields :dictThisContact];
                    
                }
                
            } else if (isRoom) {
                
                //loop through the rooms
                for(NSString* strRoomKey in dictProcedureRooms) {
                    
                    //add room title
                    /*************room title***********************/
                    
                    [self makeDivider:strRoomKey:[colorManager setColor:204.0 :204.0 :204.0]];
                    
                    /*************room data***********************/
                    
                    NSDictionary* dictThisRoom = [dictProcedureRooms objectForKey:strRoomKey];
                    
                    //loop through the room data array
                    [self makeRow:arrORField :dictThisRoom];
                    
                    //check if the room has any location data
                    for(NSString* strLocationKey in dictLocations) {
                        
                        NSDictionary* dictThisLocation = [dictLocations objectForKey:strLocationKey];
                        NSString* strLocationParent = [dictThisLocation objectForKey:@"Operating Room ID"];
                        if ([strLocationParent isEqualToString:strRoomKey]) {
                            
                            textY = textY + 10.0;
                            [self makeRow:arrLocatonFields :dictThisLocation];
                        }
                    }
                    
                    
                    //increment y to account for end of room
                    textY = textY + 20.0;
                    if (textY > 700.0) {
                        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
                        textY = 40.0;
                        
                    }
                }
                
            } else {
                
                if(i<4) {
                    
                    NSArray* arrThisSectionData = [arrAllSections objectAtIndex:i];
                    
                    if(![strSiteInfo isEqualToString:@"Pre-Install Checks"]) {
                        [self makeRow:arrThisSectionData :dictSectionData];
                    } else {
                        
                        for(int x=0; x<arrPreInstallSections.count; x++) {
                            
                            NSString* strSubSectionHeader = [arrPreInstallSections objectAtIndex:x];
                            
                            [self makeDivider:strSubSectionHeader:[colorManager setColor:204.0 :204.0 :204.0]];
                            
                            //set the section data
                            NSArray* arrSubsections = [arrThisSectionData objectAtIndex:x];
                            
                            [self makeRow:arrSubsections :dictProject];
                        }
                        
                    }
                    
                    textY = textY + 30;
                    
                }
                
            }
        }
        
        //keep at bottom
        done = YES;
        
    } while (!done);

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();

}

- (void) makeDivider : (NSString*) strDivider : (UIColor*) clrDivider {
    
    textY = textY + 10.0;
    
    bgRectColor = clrDivider;
    bgRectStartPoint = CGPointMake(textX,textY);
    bgRectEndPoint = CGPointMake(pageSize.width-(textX), textY);
    lineWidth = kLineWidth*20;
    [self drawLine:lineWidth:bgRectColor:bgRectStartPoint:bgRectEndPoint];
    
    textY = textY - 8.0;
    
    sectionConstraint = [strDivider sizeWithFont:headerFont constrainedToSize:pageConstraint lineBreakMode:NSLineBreakByWordWrapping];
    sectionFrame = CGRectMake(textX, textY, sectionConstraint.width, sectionConstraint.height);
    textColor = [colorManager setColor:66.0 :66.0 :66.0];
    [self drawText:strDivider :sectionFrame :headerFont:textColor:0];
    
    textY = textY + 20.0;
    
}

- (void) makeRow : (NSArray*) myArray : (NSDictionary*) myDictionary {
    
    for(int i=0; i<myArray.count; i++) {
        
        NSArray* arrKeyValue;
        
        arrKeyValue = [self compareData:[myArray objectAtIndex:i] :myDictionary:0];
        
        strThisKey = [arrKeyValue objectAtIndex:0];
        strThisValue = [arrKeyValue objectAtIndex:1];
        
        //display the key/values
        float thisHeight = [self displayKeyValue:strThisKey :strThisValue:textX:textY];
        
        //add padding to key/values with just one line
        if (thisHeight == 15.0) {
            thisHeight = 17.0;
        } else if (thisHeight == 30) {
            thisHeight = 32.0;
        }
        
        //increment content height
        contentHeight = contentHeight + thisHeight;
        
        //increment y, reset x
        textY = textY + thisHeight;
        textX = kMarginInset;
        
        if (textY > 700.0) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            textY = 40.0;
        }
        
    }
    
}

- (NSArray*) compareData : (NSString*) strFromArray : (NSDictionary*) dictSection : (int) dataType {
    
    
    for(NSString* strThisDataKey in dictSection) {
        
        if([strFromArray isEqualToString:strThisDataKey]) {
            
            NSString* strThisDataValue;
            if (![strFromArray isEqualToString:@"Monitors"]) { 
                strThisDataValue = [dictSection objectForKey:strThisDataKey];
            } else {
                
                NSMutableString* strMonitors = [[NSMutableString alloc] init];
                NSArray* arrMonitors = [dictSection objectForKey:strThisDataKey];
                
                if (arrMonitors.count > 0) { 
                    for(int i=0; i<arrMonitors.count; i++) {
                        
                        if (i<arrMonitors.count-1) { 
                            [strMonitors appendString:[NSString stringWithFormat:@"%@, ", [arrMonitors objectAtIndex:i]]];
                        } else {
                            [strMonitors appendString:[NSString stringWithFormat:@"%@ ", [arrMonitors objectAtIndex:i]]];
                        }
                    }
                    
                    strThisDataValue = strMonitors;
                    
                } else {
                    strThisDataValue = @"No Entry";
                }
            }
            
            //convert ceiling index to string
            if ([strFromArray isEqualToString:@"Ceiling:"]) {
                
                int ceilingInt = [strThisDataValue intValue];
                if (ceilingInt == 0) {
                    strThisDataValue = @"Hatch";
                } else if (ceilingInt == 1) {
                    strThisDataValue = @"Drop Ceiling";
                } else if (ceilingInt == 2) {
                    strThisDataValue = @"Sealed";
                } else if (ceilingInt == -1) {
                    strThisDataValue = @"No Entry";
                }
            }
            
            NSArray* arrDataToReturn = [[NSArray alloc] initWithObjects:strThisDataKey, strThisDataValue, nil];
            
            return arrDataToReturn;
            
        } else {
            
            //NSLog(@"%@::%@", strThisKey, strFromArray);
        }
    }
    
    return nil;
    
}

- (float) displayKeyValue : (NSString*) myKey : (NSString*) myValue : (float) myX : (float) myY {
    
    //display key
    CGSize keyConstraint = [myKey sizeWithFont:headerFont constrainedToSize:CGSizeMake(300.0, pageSize.height) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect keyFrame = CGRectMake(myX, myY, keyConstraint.width, keyConstraint.height);
    textColor = [colorManager setColor:66.0 :66.0 :66.0];
    [self drawText:myKey :keyFrame :contentFont:textColor:0];
    
    //display value
    myX = 420.0;
    CGSize valueConstraint = [myValue sizeWithFont:headerFont constrainedToSize:CGSizeMake(300, pageSize.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    float frameHeight = 0.0;
    if (valueConstraint.height > keyConstraint.height) {
        frameHeight = valueConstraint.height;
    } else {
        frameHeight = keyConstraint.height;
    }
    
    CGRect valueFrame = CGRectMake(myX, myY, valueConstraint.width+50.0, frameHeight);
    textColor = [colorManager setColor:66.0 :66.0 :66.0];
    [self drawText:myValue :valueFrame :contentFont:textColor:0];
    
    
    
    //increase content height
    return frameHeight;
    
}


#pragma mark - Drawing Methods

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) myTextColor : (int) textAlignment {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, myTextColor.CGColor);
    
    int myTextAlignment = textAlignment;
    
    [textToDraw drawInRect:textFrame withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:myTextAlignment];
}

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame  {
    
   [imageToDraw drawInRect:imageFrame];
}

- (void) drawLine : (float) myLineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint  {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, myLineWidth);
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

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) myTextColor {
    
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
        [self drawText:strThisHeader :thisHeaderFrame :font:myTextColor:0];
    }
}

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) myLineWidth {
    
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
        [self drawLine:myLineWidth:rowColor:rowStartPoint:rowEndPoint];
        
    }

    
}

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) myTextColor : (UIFont*) font {
    
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
        [self drawText:thisRowItem :thisRowCellFrame :font:myTextColor:0];
        
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

#pragma mark - Check content height

- (BOOL) checkContentHeight : (float) elementHeight {
    
    
    if (elementHeight > pageSize.height - 500.0) {
        return YES;
    }
    
    return NO;
    
}

- (void) makeNewPage {
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    textY = kBorderInset;
    contentHeight = kMarginInset;
    
}


@end
