//
//  ActivityIndicator.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 21.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
// 

#import <QuartzCore/QuartzCore.h>
#import "ActivityIndicator.h"
#import "Global.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

static ActivityIndicator *currentIndicator = nil;
static float defaultDelay = 0.6;

@interface ActivityIndicator (PrivateMethods)

- (void)persist;
- (void)hidden;

@end

@implementation ActivityIndicator

@synthesize centerMessageLabel = _centerMessageLabel;
@synthesize subMessageLabel = _subMessageLabel;
@synthesize spinner = _spinner;

+ (ActivityIndicator *)currentIndicator
{
	if (currentIndicator == nil)
	{
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		
		CGFloat width = 160;
		CGFloat height = 160;
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
										  round(keyWindow.bounds.size.height/2 - height/2),
										  width,
										  height);
		
		currentIndicator = [[ActivityIndicator alloc] initWithFrame:centeredFrame];

		currentIndicator.backgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		currentIndicator.opaque = NO;
		currentIndicator.alpha = 0;
		currentIndicator.layer.borderColor  = [UIColor lightGrayColor].CGColor;
		currentIndicator.layer.borderWidth  = 2.0;
		currentIndicator.layer.cornerRadius = 10;
        currentIndicator.layer.shadowColor  = [UIColor blackColor].CGColor;
        currentIndicator.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        currentIndicator.layer.shadowOpacity = 0.60;
		
		currentIndicator.userInteractionEnabled = NO;
		currentIndicator.autoresizesSubviews = YES;
		currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
		
		[currentIndicator setProperRotation:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:currentIndicator
												 selector:@selector(setProperRotation)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
	}
	
	return currentIndicator;
}

#pragma mark -

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[_centerMessageLabel release];
	[_subMessageLabel release];
	[_spinner release];
	
	[super dealloc];
}

#pragma mark Creating Message

- (void)show
{	
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	if ([self superview] != keyWindow) {
		CGFloat width = 160;
		CGFloat height = 160;
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
										  round(keyWindow.bounds.size.height/2 - height/2),
										  width,
										  height);

        [self setFrame:centeredFrame];
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)setDelay:(float)delay
{
    defaultDelay = delay;
}

- (void)hideAfterDelay
{
	[self performSelector:@selector(hide) withObject:nil afterDelay:defaultDelay];
}

- (void)hide
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)persist
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.1];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)hidden
{
	if (currentIndicator.alpha > 0)
		return;
	
	//[currentIndicator removeFromSuperview];
	//currentIndicator = nil;
}

- (void)displayActivity:(NSString *)message
{		
	[self setSubMessage:message];
	[self showSpinner];	
	
	[_centerMessageLabel removeFromSuperview];
	self.centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
}

- (void)displayCompleted:(NSString *)message
{	
	[self setCenterMessage:@"✓"];
	[self setSubMessage:message];
	
	[_spinner removeFromSuperview];
	self.spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
		
	[self hideAfterDelay];
}

- (void)displayFailed:(NSString *)message
{
	[self setCenterMessage:@"✘"];
	[self setSubMessage:message];
	
	[_spinner removeFromSuperview];
	self.spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay];
}

- (void)setCenterMessage:(NSString *)message
{	
	if (message == nil && _centerMessageLabel != nil)
		self.centerMessageLabel = nil;

	else if (message != nil)
	{
		if (_centerMessageLabel == nil)
		{
			self.centerMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, round(self.bounds.size.height/2 - 25),self.bounds.size.width - 24, 50)] autorelease];
			_centerMessageLabel.backgroundColor = [UIColor clearColor];
			_centerMessageLabel.opaque = NO;
			_centerMessageLabel.textColor = [UIColor whiteColor];
			_centerMessageLabel.font = [UIFont boldSystemFontOfSize:40];
			_centerMessageLabel.textAlignment = UITextAlignmentCenter;
			_centerMessageLabel.shadowColor = [UIColor darkGrayColor];
			_centerMessageLabel.shadowOffset = CGSizeMake(1,1);
			_centerMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:_centerMessageLabel];
		}
		
		_centerMessageLabel.text = message;
	}
}

- (void)setSubMessage:(NSString *)message
{	
	if (message == nil && _subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil)
	{
		if (_subMessageLabel == nil)
		{
			self.subMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,self.bounds.size.height-45,self.bounds.size.width-24,30)] autorelease];
			_subMessageLabel.backgroundColor = [UIColor clearColor];
			_subMessageLabel.opaque = NO;
			_subMessageLabel.textColor = [UIColor whiteColor];
			_subMessageLabel.font = [UIFont boldSystemFontOfSize:17];
			_subMessageLabel.textAlignment = UITextAlignmentCenter;
			_subMessageLabel.shadowColor = [UIColor darkGrayColor];
			_subMessageLabel.shadowOffset = CGSizeMake(1,1);
			_subMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:_subMessageLabel];
		}
		
		_subMessageLabel.text = message;
	}
}
	 
- (void)showSpinner
{	
	if (_spinner == nil)
	{
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

		_spinner.frame = CGRectMake(round(self.bounds.size.width/2 - _spinner.frame.size.width/2),
								round(self.bounds.size.height/2 - _spinner.frame.size.height/2),
								_spinner.frame.size.width,
								_spinner.frame.size.height);		
	}
	
	[self addSubview:self.spinner];
	[self.spinner startAnimating];
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

- (void)setProperRotation:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
	
	if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(180));
		
	else if (orientation == UIInterfaceOrientationPortrait)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(0)); 
	
	else if (orientation == UIInterfaceOrientationLandscapeLeft)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(-90));	
	
	else if (orientation == UIInterfaceOrientationLandscapeRight)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(90));
	
	if (animated)
		[UIView commitAnimations];
}


@end
