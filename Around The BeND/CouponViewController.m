//
//  CouponViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 7/11/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "CouponViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    [self.couponMessageTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [self.couponMessageTextView setEditable:NO];
    [self.couponMessageTextView setTextColor:[UIColor lightGrayColor]];
    [self.couponMessageTextView setText:self.couponMessage];
    
    [self.eventNameButton setTitle:self.companyName forState:UIControlStateNormal];
    [self.dayOfWeekLabel setText:self.dayOfWeek];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//so that text view isnt at the middle?
-(BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
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
