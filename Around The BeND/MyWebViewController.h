//
//  MyWebViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/21/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property(strong,nonatomic) NSString *fullURL;
@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;

@end
