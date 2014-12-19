//
//  InfoViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/3/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyWebViewController.h"
#import "Constants.h"
@interface InfoViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;

@property (strong, nonatomic) IBOutlet UIButton *phoneNumberButton;

@property (strong, nonatomic) IBOutlet UIButton *websiteButton;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *address;
@property(strong,nonatomic) NSString *phone;
@property(strong,nonatomic) NSString *website;
@property(strong,nonatomic) CLLocation *location;




@end
