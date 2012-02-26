//
//  AMClient.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 24.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import "AMClient.h"

static AMClient *currentClient;

@interface AMClient (PrivateMethods)
- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
@end

@implementation AMClient

@synthesize email = _email;
@synthesize password = _password;
@synthesize authToken = _authToken;
@synthesize apnsToken = _apnsToken;
@synthesize rememberme = _rememberme;
@synthesize tag = _tag;
@synthesize request = _request;
@synthesize delegate = _delegate;

+ (AMClient*)currentClient
{
    if (currentClient == nil) {
        currentClient = [[AMClient alloc] initWithDelegate:nil];
    }
    return currentClient;
}

+ (AMClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (currentClient == nil) {
        currentClient = [[AMClient alloc] initWithDelegate:delegate];
    }
    return currentClient;
}

- (void)dealloc
{
    [_apnsToken release];
    [_authToken release];
    [_email release];
    [_password release];
    [_request release];
    [super dealloc];
}

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (self = [super init]) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @"", @"airomoToken",
                                                                 @"", @"airomoUserEmail",
                                                                 @"", @"airomoPassword",
                                                                 [NSDate date], @"airomoTokenStamp",
                                                                 nil]];
        self.delegate = delegate;
    }
    return self;
}

- (void)authWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self.email = email;
    self.password = password;

    if (self.request) {
        self.request = nil;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"email", self.password, @"password", nil];
    _request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    self.tag = kClientTagAuth;
    [self.request sendPostRequest:@"auth/password" withJSONParams:params];
}

- (void)startFacebookToken:(NSString*)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token, @"token", nil];

    if (self.request) {
        self.request = nil;
    }
    _request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    self.tag = kClientTagFacebookAuth;
    [self.request sendGetRequest:@"auth/facebook" withJSONParams:params];
}

- (void)signup:(NSString *)email password:(NSString *)password
{
    self.email = email;
    self.password = password;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"username", self.password, @"password", nil];

    if (self.request) {
        self.request = nil;
    }
    _request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    self.tag = kClientTagSignup;
    [self.request sendPostRequest:@"signup" withJSONParams:params];
}

- (void)logout
{
    self.email = @"";
    self.password = @"";
    self.authToken = @"";
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

