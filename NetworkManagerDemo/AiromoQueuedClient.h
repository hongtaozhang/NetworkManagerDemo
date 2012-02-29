//
//  AiromoQueuedClient.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 28.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiromoRequestManager.h"
#import "AiromoRequestDelegate.h"
#import "AMDataReceiverDelegate.h"
#import "Global.h"

@interface AiromoQueuedClient : NSObject <AiromoRequestDelegate> {
    // Networking requests queue
    NSMutableArray *_queue;
    NSObject<AMDataReceiverDelegate> *_delegate;
}

@property (nonatomic, retain) NSMutableArray *queue;
@property (nonatomic, assign) NSObject<AMDataReceiverDelegate> *delegate;

+ (AiromoQueuedClient *)currentClient;
+ (AiromoQueuedClient *)currentClientDelegate:(NSObject<AMDataReceiverDelegate> *)delegate;
- (void)sendUniversalRequest:(NSDictionary *)params andTag:(AiromoRequestTags)tag;
- (NSUInteger)aliveRequests;

@end
