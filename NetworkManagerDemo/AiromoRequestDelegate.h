//
//  AiromoRequestDelegate.h
//  Airomo
//
//  Created by Eugene Pankratov on 20.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AiromoRequestDelegate

@optional

- (void)requestDataRecieved:(id)request;
- (void)requestFailed:(id)request;
- (void)requestFinished:(id)request;
- (void)requestTimeoutExceeded:(id)request;

@end
