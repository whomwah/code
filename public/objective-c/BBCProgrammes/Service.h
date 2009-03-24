//
//  Service.h
//
//  Created by Duncan Robertson on 06/01/2009.
//  Copyright 2009 Whomwah. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Service : NSObject {
  NSString *key;
  NSString *title;
  NSString *desc;
  NSString *outletKey;
  NSString *outletTitle;
  NSString *outletDesc;
}

@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *outletKey;
@property(nonatomic, copy) NSString *outletTitle;
@property(nonatomic, copy) NSString *outletDesc;

- (NSString *)displayTitle;
- (id)initUsingServiceXML:(NSArray *)data;

@end
