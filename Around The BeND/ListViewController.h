//
//  ListViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EventViewController.h"
#import <Parse/Parse.h>
#import "InfoDisclaimerViewController.h"
#import <iAd/iAd.h>
#import "Constants.h"


@interface ListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,PFLogInViewControllerDelegate,ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@property(strong,nonatomic) NSMutableArray *eventList;

@property (strong, nonatomic) IBOutlet UILabel *topLabel;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;

@property(nonatomic) NSInteger dayOfWeek;
@property(strong,nonatomic) NSString *currentWeekday;

@property(strong,nonatomic) NSMutableArray *websitesArray;
@property(strong,nonatomic) NSString *fullURL;
@property (strong, nonatomic) IBOutlet ADBannerView *myBannerView;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;

@end
