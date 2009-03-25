//
//  DRNSString-Utilities.h
//
//  Created by Duncan Robertson on 10/06/2008.
//  Copyright 2008 Whomwah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString ( Utilities )

// Pass an NSXMLNode and an XPath string
// and return an NSString as a result
+ (NSString *)stringForXPath:(NSString *)xp ofNode:(NSXMLNode *)n;

@end
