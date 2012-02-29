//
//  AiromoQueuedClient.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 24.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import "AiromoQueuedClient.h"

static AiromoQueuedClient *currentBaseClient;

@interface AiromoQueuedClient (PrivateMethods)

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;

@end

@implementation AiromoQueuedClient

@synthesize queue      = _queue;
@synthesize delegate   = _delegate;

+ (AiromoQueuedClient *)currentClient
{
    if (currentBaseClient == nil) {
        currentBaseClient = [[AiromoQueuedClient alloc] initWithDelegate:nil];
    }
    return currentBaseClient;
}

+ (AiromoQueuedClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (currentBaseClient == nil) {
        currentBaseClient = [[AiromoQueuedClient alloc] initWithDelegate:delegate];
    }
    return currentBaseClient;
}

- (void)dealloc
{
    [_queue release];
    [super dealloc];
}

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if ((self = [super init]) != nil) {
        _queue = [[NSMutableArray alloc] init];
        self.delegate = delegate;
    }
    return self;
}

- (void)sendUniversalRequest:(NSDictionary *)params andTag:(AiromoRequestTags)tag
{
    AiromoRequestManager *request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    request.tag = tag;
    [self.queue addObject:request];

    // Choose the request depending on tag
    switch (tag) {
        case kRequestTagAuth:
            [request sendPostRequest:@"auth/password" withJSONParams:params];
            break;
        case kRequestTagFacebookAuth:
            [request sendGetRequest:@"auth/facebook" withJSONParams:params];
            break;
        case kRequestTagSignup:
            [request sendPostRequest:@"signup" withJSONParams:params];
            break;
            
        default:
            break;
    }
    [request release];
}

- (NSUInteger)aliveRequests
{
    NSUInteger alive = 0;
    for (AiromoRequestManager *request in self.queue) {
        if (request.status == kAiromoRequestInProgress) {
            alive++;
        }
    }
    return alive;
}

#pragma mark - AiromoRequestDelegate methods

- (void)requestDataRecieved:(id)request
{
//    AILOG(@"Data received");
}

- (void)requestFailed:(id)request
{
    AiromoRequestManager *netMan = (AiromoRequestManager *) request;
    AILOG(@"%@", [netMan.connectionError localizedDescription]);
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[netMan.connectionError localizedDescription], kDataPayloadErrorKey,
                          [NSNumber numberWithInt:netMan.tag], kDataPayloadTagKey,
                          [NSDictionary dictionary], kDataPayloadKey,
                          netMan.urlString, kDataPayloadUrlKey,
                          netMan.queryString, kDataPayloadQueryKey,
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

- (void)requestFinished:(id)request
{
    AiromoRequestManager *netMan = (AiromoRequestManager *) request;
    AILOG(@"%@", netMan.encodedResponse);
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:@"", kDataPayloadErrorKey,
                          [NSNumber numberWithInt:netMan.tag], kDataPayloadTagKey,
                          netMan.encodedResponse, kDataPayloadKey,
                          netMan.urlString, kDataPayloadUrlKey,
                          netMan.queryString, kDataPayloadQueryKey,
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

- (void)requestTimeoutExceeded:(id)request
{
    AiromoRequestManager *netMan = (AiromoRequestManager *) request;
    AILOG(@"Timeout excceeded");
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:@"timeout", kDataPayloadErrorKey,
                          [NSNumber numberWithInt:netMan.tag], kDataPayloadTagKey,
                          [NSDictionary dictionary], kDataPayloadKey,
                          netMan.urlString, kDataPayloadUrlKey,
                          netMan.queryString, kDataPayloadQueryKey,
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

@end
