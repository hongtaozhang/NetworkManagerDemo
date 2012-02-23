//
//  ViewController.h
//  NetworkManagerDemo
//
//  Created by Eugene Pankratov on 21.02.12.
//  Copyright (c) 2012 pankratov.net.ua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiromoRequestDelegate.h"

@interface ViewController : UIViewController <UITextFieldDelegate, AiromoRequestDelegate>

@property (nonatomic, retain) IBOutlet UIButton *buttonStart;
@property (nonatomic, retain) IBOutlet UITextField *textAppName;
@property (nonatomic, retain) IBOutlet UIView *shadowView;
@property (nonatomic, retain) IBOutlet UITextView *log;

- (IBAction)onStartAction:(id)sender;

@end
