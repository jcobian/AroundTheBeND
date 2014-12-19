//
//  InfoDisclaimerViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/16/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <MessageUI/MessageUI.h>
@interface InfoDisclaimerViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *disclaimerTextView;
@property (strong, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavBar;

@end
