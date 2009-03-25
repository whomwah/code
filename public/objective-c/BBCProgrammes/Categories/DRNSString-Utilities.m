//
//  DRNSString-Utilities.m
//
//  Created by Duncan Robertson on 10/06/2008.
//  Copyright 2008 Whomwah. All rights reserved.
//

#import "DRNSString-Utilities.h"

@implementation NSString (Utilities)

+ (NSString *)stringForXPath:(NSString *)xp ofNode:(NSXMLNode *)n
{
    NSError *error;
    NSArray *nodes = [n nodesForXPath:xp error:&error];
    if (!nodes) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return nil;
    }
    if ([nodes count] == 0) {
        return nil;
    } else {
        return [[nodes objectAtIndex:0] stringValue];
    }
}

@end
