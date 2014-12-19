//
//  UploadImageViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/25/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
@interface UploadImageViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property(nonatomic) BOOL isPlaceholderText;
//received from Picture VC
@property(strong,nonatomic) UIImage *image;
@property(strong,nonatomic) NSData *imageData;
@property(strong,nonatomic) NSString *eventId;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;


@end
