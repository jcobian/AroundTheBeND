//
//  EventViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

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
   // self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar.topItem.leftBarButtonItem setTarget:self];
    [self.navigationController.navigationBar.topItem.leftBarButtonItem setAction:@selector(exit:)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

        
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    [self.eventDescriptionTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [self loadImage];
    
   
    
    [self.eventNameButton setTitle:self.eventNameString forState:UIControlStateNormal];

    [self.eventDescriptionTextView setText:self.description];
    [self.eventDescriptionTextView setEditable:NO];
    [self.eventDescriptionTextView setTextColor:[UIColor lightGrayColor]];
    
    
    
    self.name = [[NSString alloc] init];
    self.address = [[NSString alloc] init];
    self.phone = [[NSString alloc] init];
    self.website = [[NSString alloc] init];
    self.location = [[CLLocation alloc] init];



    self.eventNameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.eventNameButton.titleLabel.minimumScaleFactor = .1;

    self.imageFileNames = [[NSMutableArray alloc] init];
    self.numImageViewsList = [[NSMutableArray alloc] init];
    self.imageObjectIds = [[NSMutableArray alloc] init];
    self.captionsArray = [[NSMutableArray alloc] init];

    self.createdAtArray = [[NSMutableArray alloc] init];
    
    self.myImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked)];
    [self.myImageView addGestureRecognizer:tapGesture];


    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];

    if (self.hasCoupon == YES) {
        [self.seeCouponButton setUserInteractionEnabled:YES];
        [self.seeCouponButton setHidden:NO];
    }
    

    

}
-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
}
-(void)startSpinningWheel {
    [self.eventNameButton setUserInteractionEnabled:NO];
    [self.myImageView setUserInteractionEnabled:NO];
    [self.picturesButton setUserInteractionEnabled:NO];
    
    [self.spinningWheel startAnimating];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.eventNameButton setUserInteractionEnabled:YES];
    [self.myImageView setUserInteractionEnabled:YES];
    [self.picturesButton setUserInteractionEnabled:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)imageClicked {
    [self startSpinningWheel];
    [self goToInfo];
    
}
-(void)loadImage {
    PFQuery *query = [PFQuery queryWithClassName:IMAGE_TABLE_NAME];
    [query whereKey:IMAGE_COLUMN_OBJID equalTo:self.placeObjId];
    
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] > 0) {
                PFObject *obj = [objects objectAtIndex:0];
                self.myImageView.file = obj[IMAGE_COLUMN_IMAGE];
                [self.myImageView loadInBackground];
            }
        }
        else {
            NSLog(@"Error: %@",error);
        }
    }];
}
-(void)addKey:(NSString *)key toArray:(NSMutableArray *)arr WithPFObject:(PFObject *)obj WithNilOption:(NSObject *)nilOption{
    if(obj[key]) {
        [arr addObject:obj[key]];
    }
    else {
        [arr addObject:nilOption];
    }
}
- (IBAction)pictureButtonPressed:(id)sender {
    [self startSpinningWheel];
    
    [self.imageFileNames  removeAllObjects];
    [self.createdAtArray  removeAllObjects];
    [self.numImageViewsList removeAllObjects];
    [self.imageObjectIds removeAllObjects];
    [self.captionsArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:EVENT_IMAGE_TABLE_NAME];
    [query whereKey:EVENT_IMAGE_COLUMN_EVENT_ID equalTo:self.specialObjId];
    [query orderByDescending:EVENT_IMAGE_NUM_VIEWS];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] > 0) {
                for(PFObject *obj in objects) {
                    /*
                    [self.imageFileNames addObject:obj[EVENT_IMAGE_COLUMN_IMAGE]];
                    [self.numImageViewsList addObject:obj[EVENT_IMAGE_NUM_VIEWS]];
                    [self.imageObjectIds addObject:obj.objectId];
                    [self.createdAtArray addObject:obj.createdAt];
                    [self.captionsArray addObject:obj[EVENT_IMAGE_CAPTION]];
                     */
                    
                    [self addKey:EVENT_IMAGE_COLUMN_IMAGE toArray:self.imageFileNames WithPFObject:obj WithNilOption:nil];
                   // UIImage *im = (UIImage *)obj[IMAGE_COLUMN_IMAGE];
                    //[self.imageFileNames addObject:im];
                    [self addKey:EVENT_IMAGE_NUM_VIEWS toArray:self.numImageViewsList WithPFObject:obj WithNilOption:[NSNumber numberWithInt:0]];
                    [self.imageObjectIds addObject:obj.objectId];
                    [self.createdAtArray addObject:obj.createdAt];
                    [self addKey:EVENT_IMAGE_CAPTION toArray:self.captionsArray WithPFObject:obj WithNilOption:@""];



                }

                
            }
            
            //now find the actual event's location b/c need it in case u want to take a picture 
            PFQuery *locationQuery = [PFQuery queryWithClassName:COMPANY_TABLE_NAME];
            [locationQuery getObjectInBackgroundWithId:self.placeObjId block:^(PFObject *object, NSError *error) {
                if(!error) {
                    PFGeoPoint *geoPoint = object[COMPANY_COLUMN_GEOPOINT];
                    self.location = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                    [self performSegueWithIdentifier:@"goToPictures" sender:self];
                }
                else {
                    NSLog(@"Error: %@",error);
                }
                
            }];
           
           

        
        }
        
    }];
    
    

}
-(void)goToInfo {
    PFQuery *query = [PFQuery queryWithClassName:COMPANY_TABLE_NAME];
    [query whereKey:COMPANY_COLUMN_NAME equalTo:self.eventNameString];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] > 0) {
                PFObject *pfObject = [objects objectAtIndex:0];
                self.name = pfObject[COMPANY_COLUMN_NAME];
                self.address = pfObject[COMPANY_COLUMN_ADDRESS];
                self.phone = pfObject[COMPANY_COLUMN_PHONE];
                self.website = pfObject[COMPANY_COLUMN_WEBSITE];
                PFGeoPoint *geoPoint = pfObject[COMPANY_COLUMN_GEOPOINT];
                self.location = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                [self performSegueWithIdentifier:@"goToInfo" sender:self];
            }
        }
        else {
            NSLog(@"Error: %@",error);
        }
        
        
    }];
/*
    if(appDelegate.selectedTag == 0) {
         // Retrieve the object by id
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                if([objects count] > 0) {
                    PFObject *pfObject = [objects objectAtIndex:0];
                    self.name = pfObject[BAR_COLUMN_NAME];
                    self.address = pfObject[BAR_COLUMN_ADDRESS];
                    self.phone = pfObject[BAR_COLUMN_PHONE];
                    self.website = pfObject[BAR_COLUMN_WEBSITE];
                    PFGeoPoint *geoPoint = pfObject[BAR_COLUMN_GEOPOINT];
                    self.location = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                    
                    [self performSegueWithIdentifier:@"goToInfo" sender:self];
                }
            }
            else {
                NSLog(@"Error: %@",error);
            }
            
            
        }];
    }
    else if (appDelegate.selectedTag == 1) {
        // Create the PFQuery
        PFQuery *query = [PFQuery queryWithClassName:RESTAURANT_TABLE_NAME];
        [query whereKey:RESTAURANT_COLUMN_NAME equalTo:self.eventNameString];
        query.limit = 1;
        // Retrieve the object by id
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                if([objects count] > 0) {
                    PFObject *pfObject = [objects objectAtIndex:0];
                    self.name = pfObject[RESTAURANT_COLUMN_NAME];
                    self.address = pfObject[RESTAURANT_COLUMN_ADDRESS];
                    self.phone = pfObject[RESTAURANT_COLUMN_PHONE];
                    self.website = pfObject[RESTAURANT_COLUMN_WEBSITE];
                    PFGeoPoint *geoPoint = pfObject[RESTAURANT_COLUMN_GEOPOINT];
                    self.location = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                    
                    [self performSegueWithIdentifier:@"goToInfo" sender:self];
                }
            }
            else {
                NSLog(@"Error: %@",error);
            }
            
        }];
        
    }

    */
}
- (IBAction)upDownButtonPressed:(id)sender {
    
}
- (IBAction)seeCouponPressed:(id)sender {
    [self performSegueWithIdentifier:@"goToCoupon" sender:self];
}

- (IBAction)eventNameButtonPressed:(id)sender {
    [self startSpinningWheel];
    [self goToInfo];
    
    

    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToPictures"]) {
        PictureViewController *controller = (PictureViewController *)segue.destinationViewController;
        [controller setEventId:self.specialObjId];
        [controller setPictureList:self.imageFileNames];
        [controller setNumPictureViews:self.numImageViewsList];
        [controller setPictureObjectIds:self.imageObjectIds];
        [controller setCreatedAtArray:self.createdAtArray];
        [controller setCurrentDayOfWeek:self.currentDayOfWeek];
        [controller setEventLocation:self.location];
        [controller setCaptionsArray:self.captionsArray];

        
    }
    else if ([segue.identifier isEqualToString:@"goToInfo"]) {
        InfoViewController *controller = (InfoViewController *)segue.destinationViewController;
        [controller setName:self.name];
        [controller setAddress:self.address];
        [controller setPhone:self.phone];
        [controller setWebsite:self.website];
        [controller setLocation:self.location];
        
        
    }
    else if ([segue.identifier isEqualToString:@"goToCoupon"]) {
        CouponViewController *controller = (CouponViewController *)segue.destinationViewController;
        [controller setCouponMessage:self.couponMessage];
        [controller setCompanyName:self.eventNameString];
        [controller setDayOfWeek:self.currentDayOfWeek];
    }
    [self stopSpinningWheel];
}
//so that text view isnt at the middle?
-(BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

/*
-(CLLocation *)location {
    if(!self.location) {
        self.location = [[CLLocation alloc] init];
    }
    return self.location;
}
-(NSMutableArray *)imageFileNames {
    if(!self.imageFileNames) {
        self.imageFileNames = [[NSMutableArray alloc] init];
    }
    return  self.imageFileNames;
}
-(NSMutableArray *)numImageViewsList {
    if(!self.numImageViewsList) {
        self.numImageViewsList = [[NSMutableArray alloc] init];
    }
    return  self.numImageViewsList;
}
-(NSMutableArray *)imageObjectIds {
    if(!self.imageObjectIds) {
        self.imageObjectIds = [[NSMutableArray alloc] init];
    }
    return  self.imageObjectIds;
}
-(NSMutableArray *)createdAtArray {
    if(!self.createdAtArray) {
        self.createdAtArray = [[NSMutableArray alloc] init];
    }
    return  self.createdAtArray;
}
-(NSString *)eventNameString {
    if(!self.eventNameString) {
        self.eventNameString = [[NSString alloc] init];
    }
    return self.eventNameString;
    
}
-(NSString *)description {
    if(!self.description) {
        self.description = [[NSString alloc] init];
    }
    return self.description;
    
}
-(NSString *)numPplGoing {
    if(!self.numPplGoing) {
        self.numPplGoing = [[NSString alloc] init];
    }
    return self.numPplGoing;
    
}
-(NSString *)specialObjId {
    if(!self.specialObjId) {
        self.specialObjId = [[NSString alloc] init];
    }
    return self.specialObjId;
    
}
-(NSString *)placeObjId {
    if(!self.placeObjId) {
        self.placeObjId = [[NSString alloc] init];
    }
    return self.placeObjId;
    
}
-(NSString *)name {
    if(!self.name) {
        self.name = [[NSString alloc] init];
    }
    return self.name;
    
}
-(NSString *)address {
    if(!self.address) {
        self.address = [[NSString alloc] init];
    }
    return self.address;
    
}
-(NSString *)phone {
    if(!self.phone) {
        self.phone = [[NSString alloc] init];
    }
    return self.phone;
    
}
-(NSString *)website {
    if(!self.website) {
        self.website = [[NSString alloc] init];
    }
    return self.website;
    
}
-(NSString *)currentDayOfWeek {
    if(!self.currentDayOfWeek) {
        self.currentDayOfWeek = [[NSString alloc] init];
    }
    return self.currentDayOfWeek;
    
}
 */


@end
