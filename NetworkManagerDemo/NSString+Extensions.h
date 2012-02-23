//
//  NSString+XMLExtensions.h
//  AppList
//
//  Created by Eugene Pankratov on 02.01.12.
//  Copyright 2012 airupt.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extensions)

+ (NSString *)encodeHTTPCharactersIn:(NSString *)source;
+ (NSString *)md5:(NSString *) source;

@end
