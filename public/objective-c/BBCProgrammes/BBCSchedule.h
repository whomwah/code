//
//  BBCSchedule.h
//
//  Created by Duncan Robertson on 18/12/2008.
//  Copyright 2008 Whomwah. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BBCService;
@class BBCBroadcast;

@interface BBCSchedule : NSObject {
  float expectedLength;
  
  NSMutableData *receivedData;
  NSXMLDocument *xmlDocument;
  
  NSDate *lastUpdated;
  NSString *serviceKey;
  NSString *outletKey;
  NSArray *broadcasts;
  
  BBCBroadcast *currentBroadcast;
  BBCService *service;
}

@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSArray *broadcasts;
@property (nonatomic, retain) BBCService *service;

- (id)initUsingService:(NSString *)sv outlet:(NSString *)ol;
- (BBCSchedule *)fetchScheduleForDate:(NSDate *)date;
- (NSURL *)buildUrlForDate:(NSDate *)date;
- (void)fetch:(NSURL *)url;
- (NSString *)broadcastDisplayTitleForIndex:(int)index;
- (NSString *)currentBroadcastDisplayTitle;
- (void)setServiceData;
- (void)setBroadcastData;
- (BBCBroadcast *)currBroadcast;
- (BBCBroadcast *)nextBroadcast;
- (BBCBroadcast *)prevBroadcast;

// delagates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
