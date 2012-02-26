//
//  AppCurlClient.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 26.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import "AppCurlClient.h"

static AppCurlClient *currentClient;

@interface AppCurlClient (PrivateMethods)
- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
@end

@implementation AppCurlClient

@synthesize tag = _tag;
@synthesize request = _request;
@synthesize delegate = _delegate;

+ (AppCurlClient *)currentClient
{
    if (currentClient == nil) {
        currentClient = [[AppCurlClient alloc] initWithDelegate:nil];
    }
    return currentClient;
}

+ (AppCurlClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (currentClient == nil) {
        currentClient = [[AppCurlClient alloc] initWithDelegate:delegate];
    }
    return currentClient;
}

- (void)dealloc
{
    [_request release];
    [super dealloc];
}

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)findSuggestionForApp:(NSString *)appName
{
    if (self.request) {
        self.request = nil;
    }
    self.tag = kACClientTagGetApp;
    _request = [[AiromoRequestManager alloc] initWithURLString:APPCURL_API_URL andDelegate:self];
    [self.request sendGetRequest:[NSString stringWithFormat:APPCURL_PARCEPN_METHOD, appName]];
}

- (void)quickSearchForApp:(NSString *)appName
{
    if (self.request) {
        self.request = nil;
    }
    self.tag = kACClientTagQuickSearchApp;
    _request = [[AiromoRequestManager alloc] initWithURLString:APPCURL_API_URL andDelegate:self];
    [self.request sendGetRequest:[NSString stringWithFormat:APPCURL_MQS_METHOD, appName]];
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
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[netMan.connectionError localizedDescription], @"error",
                          [NSNumber numberWithInt:self.tag], @"tag",
                          [NSDictionary dictionary], @"payload",
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

- (void)requestFinished:(id)request
{
    AiromoRequestManager *netMan = (AiromoRequestManager *) request;
    AILOG(@"%@", netMan.encodedResponse);
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"error",
                          [NSNumber numberWithInt:self.tag], @"tag",
                          netMan.encodedResponse, @"payload",
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

- (void)requestTimeoutExceeded:(id)request
{
    AILOG(@"Timeout excceeded");
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:@"timeout", @"error",
                          [NSNumber numberWithInt:self.tag], @"tag",
                          [NSDictionary dictionary], @"payload",
                          nil];
    [self.delegate dataReceivedWithData:data];
    [data release];
}

@end
