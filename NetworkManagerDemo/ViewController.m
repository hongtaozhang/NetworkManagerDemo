//
//  ViewController.m
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 21.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "Global.h"
#import "AMClient.h"
#import "AMClient2.h"
#import "AppCurlClient.h"

@interface ViewController (PrivateMethods)

- (void)addLogMessage:(NSString *)message;

@end

@implementation ViewController

@synthesize buttonStart = _buttonStart;
@synthesize textAppName = _textAppName;
@synthesize shadowView  = _shadowView;
@synthesize log         = _log;
@synthesize quickSearchSwitch = _quickSearchSwitch;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_buttonStart release];
    [_textAppName release];
    [_shadowView release];
    [_log release];
    [_quickSearchSwitch release];
    [super dealloc];
}

- (void)addLogMessage:(NSString *)message
{
    NSString *oldText = [_log text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [_log setText:[NSString stringWithFormat:@"[%@]: %@\n==============================\n%@",
                   [dateFormatter stringFromDate:[NSDate date]], message, oldText]];
    [dateFormatter release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ActivityIndicator currentIndicator] setDelay:1.3];
    [_textAppName setPlaceholder:@"app name"];

    [_shadowView setClipsToBounds:NO];
    [_shadowView setBackgroundColor:[UIColor clearColor]];
    [_shadowView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [_shadowView.layer setCornerRadius:8.0];
    [_shadowView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_shadowView.layer setBorderWidth:2.0f];
    
    [_shadowView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_shadowView.layer setShadowOpacity:1.0];
    [_shadowView.layer setShadowRadius:3.0];
    [_shadowView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    [_log setEditable:NO];
    [_log setText:[NSString stringWithFormat:@"You're running on %@", isPad() ? @"iPad" : @"iPhone"]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UITextFeildDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onStartAction:_buttonStart];
    return YES;
}

#pragma mark - Actions

- (void)doDefaultRequest
{
    [self addLogMessage:@"Client is being connected"];
    [[ActivityIndicator currentIndicator] displayActivity:@"Performing query..."];
    [[AMClient2 currentClientDelegate:self] authWithEmail:@"spreg@i.ua" andPassword:@"12345"];
//    [[AMClient2 currentClientDelegate:self] startFacebookToken:@"someleveytoken"];

//    [[AMClient currentClientDelegate:self] authWithEmail:@"spreg@i.ua" andPassword:@"12345"];
//    [[AMClient currentClientDelegate:self] doTempCall:@"test0.php"];
//    [[AMClient currentClientDelegate:self] doTempCall:@"test1.php"];
//    [[AMClient currentClientDelegate:self] doTempCall:@"test2.php"];
}

- (IBAction)onStartAction:(id)sender
{
    [_textAppName resignFirstResponder];

    NSString *appName = [_textAppName text];
    if (appName == nil || [appName length] == 0) {
        [[ActivityIndicator currentIndicator] setCenterMessage:@"You should specify app name first."];
        [[ActivityIndicator currentIndicator] setSubMessage:@"Trying default URL in 3 seconds"];
        [[ActivityIndicator currentIndicator] show];
        [self performSelector:@selector(doDefaultRequest) withObject:nil afterDelay:3];
    } else {
        [[ActivityIndicator currentIndicator] displayActivity:@"Performing query..."];
        if ([self.quickSearchSwitch isOn]) {
            [self addLogMessage:@"Query is being executed"];
            [[AppCurlClient currentClientDelegate:self] quickSearchForApp:appName];
        } else {
            [self addLogMessage:@"Parce process name query being executed"];
            [[AppCurlClient currentClientDelegate:self] findSuggestionForApp:appName];
        }
    }
}

#pragma mark - Data receiver delegate

- (void)dataReceivedWithData:(NSDictionary *)object
{
    NSString *string = [NSString stringWithFormat:@"Received object: %@", object];
    [self addLogMessage:string];
    NSUInteger count = [[AMClient currentClient] aliveRequests];
    if (count > 0) {
        [[ActivityIndicator currentIndicator] displayActivity:[NSString stringWithFormat:@"%u queries are still active...", count]];
    }
    else {
        [[ActivityIndicator currentIndicator] displayCompleted:@"Finished"];
    }
}

@end
