//
//  EventViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureViewController.h"
#import "InfoViewController.h"
#import "CouponViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "AppDelegate.h"

@interface EventViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *eventNameButton;

@property (strong, nonatomic) IBOutlet PFImageView *myImageView;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *picturesButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *myNavigationBar;
@property (strong, nonatomic) IBOutlet UIButton *upDownButton;
@property (strong, nonatomic) IBOutlet UILabel *staticPeopleGoingLabel;
@property (strong, nonatomic) IBOutlet UILabel *numPeopleGoingLabel;

@property(strong,nonatomic) NSString *eventNameString;
@property(strong,nonatomic) NSString *description;
//@property(strong,nonatomic) NSString *numPplGoing;
@property(strong,nonatomic) NSString *specialObjId; //this is of the special (BarSpecial, RestaurantSpeciaal)
@property(strong,nonatomic) NSString *placeObjId; //of the bar/restaurant
@property(nonatomic) BOOL userIsGoing;
@property(strong,nonatomic) NSString *couponMessage;
@property(nonatomic) BOOL hasCoupon;

//to send to infoVC
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *address;
@property(strong,nonatomic) NSString *phone;
@property(strong,nonatomic) NSString *website;
@property(strong,nonatomic) CLLocation *location;

//send to picture VC
@property (strong,nonatomic) NSMutableArray *imageFileNames;
@property (strong,nonatomic) NSMutableArray *numImageViewsList;
@property (strong,nonatomic) NSMutableArray *imageObjectIds;
@property (strong,nonatomic) NSMutableArray *createdAtArray;
@property (strong,nonatomic) NSMutableArray *captionsArray;

//send to webview
@property(strong,nonatomic) NSString *fullURL;


@property(strong,nonatomic) NSString *currentDayOfWeek;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;


@property (strong, nonatomic) IBOutlet UIButton *seeCouponButton;







@end
