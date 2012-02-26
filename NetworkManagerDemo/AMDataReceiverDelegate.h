//
//  AMDataReceiverDelegate.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 25.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDataReceiverDelegate <NSObject>

@required

- (void)dataReceivedWithData:(NSDictionary *)object; 

@end
