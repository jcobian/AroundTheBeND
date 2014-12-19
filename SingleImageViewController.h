//
//  SingleImageViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/18/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "PostCommentViewController.h"

@interface SingleImageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet PFImageView *myImageView;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) IBOutlet UIButton *postCommentButton;

@property(strong,nonatomic) NSMutableArray *commentsArray;

@property(strong,nonatomic) NSMutableArray *commentsCreatedAtArray;

@property(strong,nonatomic) PFFile *myPfFile;
@property(strong,nonatomic) NSString *pictureId;
@property(strong,nonatomic) NSString *caption;

@property (strong, nonatomic) IBOutlet UITextView *captionTextView;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;





@end
