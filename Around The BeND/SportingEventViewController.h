//
//  SportingEventViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/15/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "PictureViewController.h"
#import "MyWebViewController.h"
@interface SportingEventViewController : UIViewController
@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;
@property (strong, nonatomic) IBOutlet UIButton *sportNameButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property(strong,nonatomic) NSString *teamNameString;
@property(strong,nonatomic) NSString *description;
@property(strong,nonatomic) NSString *locationStr;
@property(strong,nonatomic) NSString *timeStr;

@property(strong,nonatomic) NSString *sportingEventObjId; //this is of the sporting event (BarSpecial, RestaurantSpeciaal)
@property(strong,nonatomic) CLLocation *eventGeoPoint;


@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

//send to picture VC
@property (strong,nonatomic) NSMutableArray *imageFileNames;
@property (strong,nonatomic) NSMutableArray *numImageViewsList;
@property (strong,nonatomic) NSMutableArray *imageObjectIds;
@property (strong,nonatomic) NSMutableArray *createdAtArray;
@property (strong,nonatomic) NSMutableArray *captionsArray;

//send to web view
@property(strong,nonatomic) NSString *fullURL;

@end
