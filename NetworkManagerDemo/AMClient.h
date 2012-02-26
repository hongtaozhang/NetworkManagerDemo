//
//  AMClient.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 24.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoRequestManager.h"
#import "AiromoRequestDelegate.h"
#import "AMDataReceiverDelegate.h"
#import "Global.h"

@interface AMClient : NSObject <AiromoRequestDelegate> {
    NSString *_email;
    NSString *_password;

    // airomo access token
    NSString *_authToken;
    // APNS token
    NSString *_apnsToken;
    BOOL _rememberme;

    // Networking stuff
    AMClientTags _tag;
    AiromoRequestManager *_request;
    NSObject<AMDataReceiverDelegate> *_delegate;
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *apnsToken;
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, assign) BOOL rememberme;
@property (nonatomic, assign) AMClientTags tag;
@property (nonatomic, retain) AiromoRequestManager *request;
@property (nonatomic, assign) NSObject<AMDataReceiverDelegate> *delegate;

+ (AMClient *)currentClient;
+ (AMClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
- (void)authWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)startFacebookToken:(NSString*)token;
- (void)signup:(NSString*)username password:(NSString*)password;
- (void)logout;

@end
