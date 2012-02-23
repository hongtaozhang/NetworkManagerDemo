//
//  ActivityIndicator.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 21.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityIndicator : UIView
{
	UILabel *_centerMessageLabel;
	UILabel *_subMessageLabel;
	UIActivityIndicatorView *_spinner;
}

@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

+ (ActivityIndicator *)currentIndicator;

- (void)show;
- (void)setDelay:(float)delay;
- (void)hideAfterDelay;
- (void)hide;
- (void)displayActivity:(NSString *)message;
- (void)displayCompleted:(NSString *)message;
- (void)displayFailed:(NSString *)message;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;

@end
