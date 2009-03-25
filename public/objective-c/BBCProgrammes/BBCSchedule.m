//
//  Schedule.m
//
//  Created by Duncan Robertson on 18/12/2008.
//  Copyright 2008 Whomwah. All rights reserved.
//

#import "BBCBroadcast.h"
#import "BBCService.h"
#import "BBCSchedule.h"
#import "DRNSString-Utilities.h"

#define API_URL @"http://www.bbc.co.uk/%@programmes/schedules%@%@.xml";

@implementation BBCSchedule

@synthesize lastUpdated, service, broadcasts;

- (id)init
{
  [self dealloc];
  @throw [NSException exceptionWithName:@"DSRBadInitCall" 
                                 reason:@"Initialize BBCSchedule with initUsingService:outlet:" 
                               userInfo:nil];
  return nil;
}

- (id)initUsingService:(NSString *)sv outlet:(NSString *)ol;
{
  if (![super init])
    return nil;
  
  outletKey = ol;
  serviceKey = sv;
  
  return self;
}

- (BBCSchedule *)fetchScheduleForDate:(NSDate *)date
{
  [self fetch:[self buildUrlForDate:date]];
  return self;
}

- (NSURL *)buildUrlForDate:(NSDate *)date
{
  NSString *api = API_URL;
  NSString *serviceStr = @"", *outletStr = @"", *dateStr = @"", *urlStr;

  if (outletKey)
    outletStr = [NSString stringWithFormat:@"/%@", outletKey];
  
  if (serviceKey)
    serviceStr = [NSString stringWithFormat:@"%@/", serviceKey];
  
  if (date)
    dateStr = [date descriptionWithCalendarFormat:@"/%Y/%m/%d" timeZone:nil locale:nil];
  
  urlStr = [NSString stringWithFormat:api, serviceStr, outletStr, dateStr];
  NSLog(@"schedule: %@", urlStr);
  return [NSURL URLWithString:urlStr];
}

- (void)fetch:(NSURL *)url
{
  NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];

  NSURLConnection * theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  if (theConnection) {
    receivedData = [[NSMutableData data] retain];
  } else {
    [theConnection release];
    NSLog(@"download failed!");
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [receivedData setLength:0];
  expectedLength = [response expectedContentLength];
  NSLog(@"Yay, we got a response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [receivedData appendData:data];
  float percentComplete = ([receivedData length]/expectedLength)*100.0;
  NSLog(@"data is being fetched: %1.0f%%", percentComplete);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  [connection release];
  [receivedData release];
  
  NSLog(@"Connection failed! Error - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSLog(@"Finished! Received %d bytes of data", [receivedData length]);
  NSError *error;
  
  NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:receivedData options:0 error:&error];
  
  if (error != nil) {
    NSLog(@"An Error occured reading the schedule: %@", error);
  }
  
  xmlDocument = doc;
  [self setServiceData];
  [self setBroadcastData];
  [self setLastUpdated:[NSDate date]];
  
  [doc release];
  [connection release];
  [receivedData release];
}

- (void)setServiceData
{
  NSError *error;
  NSArray *data = [xmlDocument nodesForXPath:@".//schedule/service" error:&error];
  
  if (error != nil)
    NSLog(@"An Error occured: %@", error);
  
  BBCService *s = [[BBCService alloc] initUsingServiceXML:data];
  [self setService:s];
  [s release];
}

#pragma mark broadcasts

- (void)setBroadcastData
{
  NSError *error;
  NSArray *data = [xmlDocument nodesForXPath:@".//schedule/*/broadcasts/broadcast" error:&error];
  if (error != nil)
    NSLog(@"An Error occured: %@", error);
  
  NSMutableArray *temp = [NSMutableArray array];
  
  for (NSXMLNode *broadcast in data) {    
    BBCBroadcast *b = [[BBCBroadcast alloc] initUsingBroadcastXML:broadcast];
    [temp addObject:b];
    [b release];
  }
  
  [self setBroadcasts:temp];
}

- (BBCBroadcast *)currBroadcast
{
  NSDate *now = [NSDate date];
  
  for (BBCBroadcast *broadcast in broadcasts) {
    if (([now compare:[broadcast bStart]] == NSOrderedDescending) && 
        ([now compare:[broadcast bEnd]] == NSOrderedAscending)) {
      return broadcast;
    }
  }
  return nil;
}

- (BBCBroadcast *)nextBroadcast
{
  int index = [broadcasts indexOfObject:[self currBroadcast]];
  
  if (index != NSNotFound && index+1 <= [broadcasts count]) {
    index++;
  }
  
  return [broadcasts objectAtIndex:index];
}

- (BBCBroadcast *)prevBroadcast
{
  int index = [broadcasts indexOfObject:[self currBroadcast]];
  
  if (index != NSNotFound && index-1 >= 0) {
    index++;
  }
  
  return [broadcasts objectAtIndex:index];
}

- (NSString *)broadcastDisplayTitleForIndex:(int)index
{
  BBCBroadcast *bc = [[self broadcasts] objectAtIndex:index];
  if (!bc)
    return service.desc;

  return [NSString stringWithFormat:@"%@ - %@", [service displayTitle], [bc displayTitle]];
}

- (NSString *)currentBroadcastDisplayTitle
{
  if ([self currBroadcast]) {
    int index = [broadcasts indexOfObject:[self currBroadcast]];
    return [self broadcastDisplayTitleForIndex:index];
  } else {
    return [service displayTitle]; 
  }
}

@end
