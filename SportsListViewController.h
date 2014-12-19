//
//  SportsListViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/14/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "SportingEventViewController.h"
#import "InfoDisclaimerViewController.h"
#import <iAd/iAd.h>
@interface SportsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property(strong,nonatomic) NSMutableArray *startDatesArray;
@property(strong,nonatomic) NSMutableDictionary *dictOfArrays;
@property(strong,nonatomic) NSString *fullURL;
@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;

@end
