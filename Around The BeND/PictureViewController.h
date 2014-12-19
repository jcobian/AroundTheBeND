//
//  PictureViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ImageCell.h"
#import <CoreImage/CoreImage.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SingleImageViewController.h"
#import "UploadImageViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface PictureViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property(strong,nonatomic) NSMutableArray *pictureList;
@property(strong,nonatomic) NSMutableArray *numPictureViews;
@property(strong,nonatomic) NSMutableArray *pictureObjectIds;
@property(strong,nonatomic) NSMutableArray *createdAtArray;
@property(strong,nonatomic) NSMutableArray *captionsArray;

@property(strong,nonatomic) CLLocation *eventLocation;



@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property(strong,nonatomic) NSString *eventId;

//to send to single image vc
@property(strong,nonatomic) PFFile *imageFile;
@property(strong,nonatomic) NSMutableArray *commentsArray;
@property(strong,nonatomic) NSMutableArray *commentsCreatedAtArray;

@property(strong,nonatomic) NSString *pictureId;
@property(strong,nonatomic) NSString *caption;

@property(strong,nonatomic) NSString *currentDayOfWeek;

@property(strong,nonatomic) CLLocationManager *locationManger;

//to send to upload
@property(strong,nonatomic) UIImage *imageToUpload;
@property(strong,nonatomic) NSData *imageData;

@property(nonatomic) BOOL firstTimeHere;

@property(strong,nonatomic) UIActivityIndicatorView *spinningWheel;

@end
