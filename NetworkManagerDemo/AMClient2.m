//
//  AMClient2.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 29.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import "AMClient2.h"

static AMClient2 *aCurrentClient;

@interface AMClient2 (PrivateMethods)

- (id)initWithDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;

@end

@implementation AMClient2

@synthesize email      = _email;
@synthesize password   = _password;
@synthesize authToken  = _authToken;
@synthesize apnsToken  = _apnsToken;
@synthesize rememberme = _rememberme;

+ (AMClient2 *)currentClient
{
    if (aCurrentClient == nil) {
        aCurrentClient = [[AMClient2 alloc] initWithDelegate:nil];
    }
    return aCurrentClient;
}

+ (AMClient2 *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate
{
    if (aCurrentClient == nil) {
        aCurrentClient = [[AMClient2 alloc] initWithDelegate:delegate];
    }
    return aCurrentClient;
}

- (void)dealloc
{
    [_apnsToken release];
    [_authToken release];
    [_email release];
    [_password release];
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
        self.delegate = delegate;
    }
    return self;
}

- (void)authWithEmail:(NSString *)email andPassword:(NSString *)password
{
    self.email = email;
    self.password = password;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"email", self.password, @"password", nil];
    [super sendUniversalRequest:params andTag:kRequestTagAuth];
}

- (void)startFacebookToken:(NSString*)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token, @"token", nil];
    [super sendUniversalRequest:params andTag:kRequestTagFacebookAuth];
}

- (void)signup:(NSString *)username email:(NSString *)email password:(NSString *)password
{
    self.email = email;
    self.password = password;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"email", username, @"username", self.password, @"password", nil];
    [super sendUniversalRequest:params andTag:kRequestTagSignup];
}

- (void)logout
{
    self.email = @"";
    self.password = @"";
    self.authToken = @"";
}


@end
