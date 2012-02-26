//
//  AiromoRequestManager.h
//  Airomo
//
//  Created by Eugene Pankratov on 20.02.12.
//  Copyright (c) 2012 airupt.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoRequestDelegate.h"

typedef enum
{
    kAiromoRequestUnknownStatus = -1,
    kAiromoRequestSuccessfulyCompleted = 0,
    kAiromoRequestCanceled,
    kAiromoRequestTimedOut,
    kAiromoRequestInProgress,
    kAiromoRequestFailed
} AiromoRequestStatus;


@interface AiromoRequestManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
	NSObject<AiromoRequestDelegate>* _delegate;
    AiromoRequestStatus _status;
    NSDate *_lastActivityTime;
    NSTimeInterval _timeoutValue;
    NSTimer *_timeoutTimer;
	NSError *_connectionError;
	NSMutableData *_receivedData;
    NSString *_urlString;
	NSURLConnection *_urlConnection;
    
	id _target;
	SEL _action;
}

@property (nonatomic, assign) NSObject<AiromoRequestDelegate>* delegate;
@property AiromoRequestStatus status;
@property NSTimeInterval timeoutValue;
@property (nonatomic, retain) NSError *connectionError;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSString *urlString;

// Initialization
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithURLString:(NSString *)urlString andDelegate:(id)delegate;

// Get requests
- (void)sendEmptyPostRequest;
- (void)sendPostRequest:(NSString *)queryString;
- (void)sendPostRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params;
//- (void)sendPostRequest:(NSString *)queryString finishWithTarget:(id)target selector:(SEL)action;

// Get requests
- (void)sendEmptyGetRequest;
- (void)sendGetRequest:(NSString *)queryString;
- (void)sendGetRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params;
//- (void)sendGetRequest:(NSString *)queryString finishWithTarget:(id)target selector:(SEL)action;

// Cancel request
- (void)cancelRequest;

// Returns JSON-encoded response
- (id)encodedResponse;

@end
