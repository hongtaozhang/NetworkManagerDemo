//
//  AMClient2.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 29.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoQueuedClient.h"

@interface AMClient2 : AiromoQueuedClient {
    NSString *_email;
    NSString *_password;
    
    // airomo access token
    NSString *_authToken;
    // APNS token
    NSString *_apnsToken;
    BOOL _rememberme;
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *apnsToken;
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, assign) BOOL rememberme;

+ (AMClient2 *)currentClient;
+ (AMClient2 *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
- (void)authWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)startFacebookToken:(NSString *)token;
- (void)signup:(NSString *)username email:(NSString *)email password:(NSString *)password;
- (void)logout;

@end
