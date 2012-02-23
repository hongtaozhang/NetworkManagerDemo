//
//  NSString+XMLExtensions.h
//  AppList
//
//  Created by Eugene Pankratov on 02.01.12.
//  Copyright 2012 airupt.com. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extensions)

+ (NSString *)encodeHTTPCharactersIn : (NSString *)source
{
    NSString *result = [NSString stringWithString:source];
    
    if ([result rangeOfString:@"@"].location != NSNotFound)
        result = [[result componentsSeparatedByString:@"@"] componentsJoinedByString:@"%40"];
    if ([result rangeOfString:@" "].location != NSNotFound)
        result = [[result componentsSeparatedByString:@" "] componentsJoinedByString:@"%20"];
    return result;
}

+ (NSString *)md5:(NSString *) source
{
    const char *cStr = [source UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
