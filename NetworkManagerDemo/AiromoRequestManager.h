//
//  AiromoRequestManager.h
//  Airomo
//
//  Created by Eugene Pankratov on 20.02.12.
//  Copyright (c) 2012 airupt.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoRequestDelegate.h"
#import "Global.h"

@interface AiromoRequestManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
	NSObject<AiromoRequestDelegate>* _delegate;
    AiromoRequestStatus _status;
    AiromoRequestTags _tag;
    NSDate *_lastActivityTime;
    NSTimeInterval _timeoutValue;
    NSTimer *_timeoutTimer;
	NSError *_connectionError;
	NSMutableData *_receivedData;
    NSString *_urlString;
    NSString *_queryString;
	NSURLConnection *_urlConnection;
}

@property (nonatomic, assign) NSObject<AiromoRequestDelegate>* delegate;
@property (nonatomic, assign) AiromoRequestStatus status;
@property (nonatomic, assign) AiromoRequestTags tag;
@property (nonatomic, retain) NSDate *lastActivityTime;
@property (nonatomic, assign) NSTimeInterval timeoutValue;
@property (nonatomic, retain) NSError *connectionError;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *queryString;

// Initialization
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithURLString:(NSString *)urlString andDelegate:(id)delegate;

// Get requests
- (void)sendEmptyPostRequest;
- (void)sendPostRequest:(NSString *)queryString;
- (void)sendPostRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params;

// Get requests
- (void)sendEmptyGetRequest;
- (void)sendGetRequest:(NSString *)queryString;
- (void)sendGetRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params;

// Cancel request
- (void)cancelRequest;

// Returns JSON-encoded response
- (id)encodedResponse;

@end
