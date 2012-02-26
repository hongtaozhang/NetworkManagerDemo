//
//  AppCurlClient.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 26.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoRequestManager.h"
#import "AiromoRequestDelegate.h"
#import "AMDataReceiverDelegate.h"
#import "Global.h"

@interface AppCurlClient : NSObject <AiromoRequestDelegate> {
    AppCurlClientTags _tag;
    AiromoRequestManager *_request;
    NSObject<AMDataReceiverDelegate> *_delegate;
}

@property (nonatomic, assign) AppCurlClientTags tag;
@property (nonatomic, retain) AiromoRequestManager *request;
@property (nonatomic, assign) NSObject<AMDataReceiverDelegate> *delegate;

+ (AppCurlClient *)currentClient;
+ (AppCurlClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
- (void)findSuggestionForApp:(NSString *)appName;
- (void)quickSearchForApp:(NSString *)appName;

@end
