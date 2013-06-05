//
//  OAI_PDFManager.h
//  EUS Calculator
//
//  Created by Steve Suranie on 2/11/13.
//  Copyright (c) 2013 Olympus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "OAI_ColorManager.h"
#import "OAI_StringManager.h"

#define kBorderInset            72.0
#define kBorderWidth            1.0
#define kMarginInset            72.0
#define kLineWidth              1.0

@interface OAI_PDFManager : NSObject {
    
    OAI_ColorManager* colorManager;
    OAI_StringManager* stringManager;
    
    UIFont* headerFont;
    UIFont* contentFont;
    
    CGSize pageConstraint;
    CGRect sectionFrame;
    CGSize sectionConstraint;
    
    
    //set up a color holder
    UIColor* textColor;
    UIColor* bgRectColor;
    float contentHeight;
    float textY;
    float textX;
    BOOL newPage;
    
    NSString* strThisKey;
    NSString* strThisValue;
    
    //set up a line width holder
    float lineWidth;
    CGPoint bgRectStartPoint;
    CGPoint bgRectEndPoint;


}

@property (nonatomic, retain) NSString* strTableTitle;
@property (nonatomic, retain) NSMutableDictionary* dictPDFData;
@property (nonatomic, retain) NSString* projectNumber;

+(OAI_PDFManager* )sharedPDFManager;

- (void) makePDF : (NSString*) fileName : (NSDictionary*) results;

- (void) generatePdfWithFilePath : (NSString* ) strFileName;

- (void) drawText : (NSString* ) textToDraw : (CGRect) textFrame : (UIFont*) textFont : (UIColor*) myTextColor : (int) textAlignment;

- (void) drawImage : (UIImage*) imageToDraw : (CGRect) imageFrame;

- (void) drawLine : (float) myLineWidth : (UIColor*) lineColor : (CGPoint) startPoint : (CGPoint) endPoint;

- (void) drawBorder : (UIColor*) borderColor :  (CGRect) rectFrame;

- (float) getStringHeight : (NSString* ) stringToMeasure : (float) widthConstraint : (UIFont*) thisFont;

- (float) getMaxHeaderHeight : (NSArray*) headers : (UIFont*) font ;

- (void) setHeaderText : (NSArray*) headers : (UIFont*) font : (float) headerX : (float) headerY : (float) headerW : (float) headerH : (UIColor*) myTextColor;

- (void) buildAlternatingTableRows : (NSArray*) rowHeaders : (UIColor* ) color1 : (UIColor* ) color2 : (float) rowX : (float) rowY : (float) endRowX : (float) endRowY : (float) myLineWidth;

- (void) setRowText : (NSArray* ) rowCellContents : (float) strX : (float) strY : (float) strW : (float) strH : (UIColor*) myTextColor : (UIFont*) font;

- (NSArray* ) gatherCellData : (NSDictionary*) theResults : (NSString* ) key;

- (BOOL) checkContentHeight : (float) elementHeight;

- (NSArray*) compareData : (NSString*) strFromArray : (NSDictionary*) dictSection : (int) dataType;

- (float) displayKeyValue : (NSString*) myKey : (NSString*) myValue : (float) myX : (float) myY;

- (void) makeNewPage;

- (void) makeRow : (NSArray*) myArray : (NSDictionary*) myDictionary;

- (void) makeDivider : (NSString*) strDivider : (UIColor*) clrDivider;

@end
