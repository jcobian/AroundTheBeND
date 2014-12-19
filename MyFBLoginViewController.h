//
//  MyFBLoginViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/6/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "InfoDisclaimerViewController.h"
#import "Constants.h"
@interface MyFBLoginViewController : UIViewController
@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UILabel *pleaseLoginLabel;

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@end
