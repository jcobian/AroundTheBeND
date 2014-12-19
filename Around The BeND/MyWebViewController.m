//
//  MyWebViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/21/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSString *fullURL = @"http://conecode.com";
    //NSString *testURL = @"http://google.com";
    NSLog(@"URL is %@",self.fullURL);
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    [self startSpinningWheel];
    [self.myWebView setDelegate:self];
    //[self.navigationController.navigationBar.topItem setTitle:self.fullURL];
    NSURL *url = [NSURL URLWithString:self.fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:requestObj];
}
-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
}
-(void)startSpinningWheel {
    //[self.spinningWheel startAnimating];

    
}
-(void)stopSpinningWheel {
    //[self.spinningWheel stopAnimating];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"started load");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopSpinningWheel];
    NSLog(@"finished load");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error %@",[error localizedDescription]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
