//
//  CouponViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 7/11/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface CouponViewController : UIViewController
@property (strong,nonatomic) NSString *companyName;
@property (strong,nonatomic) NSString *dayOfWeek;
@property (strong,nonatomic) NSString *couponMessage;
@property (strong, nonatomic) IBOutlet UILabel *dayOfWeekLabel;
@property (strong, nonatomic) IBOutlet UIButton *eventNameButton;
@property (strong, nonatomic) IBOutlet UITextView *couponMessageTextView;
@end
