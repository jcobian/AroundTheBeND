//
//  PostCommentViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/19/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
@interface PostCommentViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *myImageView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *postCommentButton;
@property(nonatomic) BOOL isPlaceholderText;


@property(strong,nonatomic) PFFile *myPfFile;
@property(strong,nonatomic) NSString *pictureId;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;


@end
