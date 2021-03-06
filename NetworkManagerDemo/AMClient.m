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
//- (void)doTempCall:(NSString *)url;

@end

@implementation AMClient

@synthesize email      = _email;
@synthesize password   = _password;
@synthesize authToken  = _authToken;
@synthesize apnsToken  = _apnsToken;
@synthesize rememberme = _rememberme;
@synthesize queue      = _queue;
@synthesize delegate   = _delegate;

+ (AMClient *)currentClient
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
    [_queue release];
    [super dealloc];
}

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if ((self = [super init]) != nil) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 @"", @"airomoToken",
                                                                 @"", @"airomoUserEmail",
                                                                 @"", @"airomoPassword",
                                                                 [NSDate date], @"airomoTokenStamp",
                                                                 nil]];
        _queue = [[NSMutableArray alloc] init];
        self.delegate = delegate;
    }
    return self;
}

- (void)authWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self.email = email;
    self.password = password;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"email", self.password, @"password", nil];
    AiromoRequestManager *request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    request.tag = kRequestTagAuth;
    [self.queue addObject:request];
    [request sendPostRequest:@"auth/password" withJSONParams:params];
    [request release];
}

- (void)startFacebookToken:(NSString*)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token, @"token", nil];
    AiromoRequestManager *request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    request.tag = kRequestTagFacebookAuth;
    [self.queue addObject:request];
    [request sendGetRequest:@"auth/facebook" withJSONParams:params];
    [request release];
}

- (void)signup:(NSString *)email password:(NSString *)password
{
    self.email = email;
    self.password = password;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"username", self.password, @"password", nil];
    AiromoRequestManager *request = [[AiromoRequestManager alloc] initWithURLString:AIROMO_URL andDelegate:self];
    request.tag = kRequestTagSignup;
    [self.queue addObject:request];
    [request sendPostRequest:@"signup" withJSONParams:params];
    [request release];
}

- (void)logout
{
    self.email = @"";
    self.password = @"";
    self.authToken = @"";
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

//- (void)doTempCall:(NSString *)url
//{
//    AiromoRequestManager *request = [[AiromoRequestManager alloc] initWithURLString:@"https://pankratov.net.ua/~eugene/test/" andDelegate:self];
//    request.tag = kRequestTagTemp;
//    [self.queue addObject:request];
//    [request sendGetRequest:url];
//    [request release];
//}

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
