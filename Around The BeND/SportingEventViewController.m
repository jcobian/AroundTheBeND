//
//  SportingEventViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/15/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "SportingEventViewController.h"

@interface SportingEventViewController ()

@end

@implementation SportingEventViewController

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
    
    [self.navigationController.navigationBar.topItem.leftBarButtonItem setTarget:self];
    [self.navigationController.navigationBar.topItem.leftBarButtonItem setAction:@selector(exit:)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    [self.descriptionTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    
    
    
    [self.sportNameButton setTitle:self.teamNameString forState:UIControlStateNormal];
    
    [self.descriptionTextView setText:self.description];
    [self.descriptionTextView setEditable:NO];
    [self.descriptionTextView setTextColor:[UIColor lightGrayColor]];
    
    [self.locationLabel setText:self.locationStr];
    [self.timeLabel setText:self.timeStr];
    
    
    
    self.sportNameButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.sportNameButton.titleLabel.minimumScaleFactor = .1;
    

 
    
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    self.eventGeoPoint = [[CLLocation alloc] init];
    

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
}
-(void)startSpinningWheel {
    [self.spinningWheel startAnimating];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    
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
    [query whereKey:EVENT_IMAGE_COLUMN_EVENT_ID equalTo:self.sportingEventObjId];
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
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if(appDelegate.selectedTag == 2) {
                PFQuery *locationQuery = [PFQuery queryWithClassName:SPORT_TABLE_NAME];
                [locationQuery getObjectInBackgroundWithId:self.sportingEventObjId block:^(PFObject *object, NSError *error) {
                    if(!error) {
                        PFGeoPoint *geoPoint = object[SPORT_COLUMN_GEOPOINT];
                        self.eventGeoPoint = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                        [self performSegueWithIdentifier:@"goToPicturesFromSports" sender:self];
                    }
                    else {
                        NSLog(@"Error: %@",error);
                    }
                    
                }];
            }
            else if (appDelegate.selectedTag == 3) {
                PFQuery *locationQuery = [PFQuery queryWithClassName:OTHER_TABLE_NAME];
                [locationQuery getObjectInBackgroundWithId:self.sportingEventObjId block:^(PFObject *object, NSError *error) {
                    if(!error) {
                        PFGeoPoint *geoPoint = object[OTHER_COLUMN_GEOPOINT];
                        self.eventGeoPoint = [[CLLocation alloc] initWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
                        [self performSegueWithIdentifier:@"goToPicturesFromSports" sender:self];
                    }
                    else {
                        NSLog(@"Error: %@",error);
                    }
                    
                }];
                
            }
        
            
            
        }
        
    }];
    
    
    
}
- (IBAction)sportTeamButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"goToWebViewFromSportOther" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToPicturesFromSports"]) {
        PictureViewController *controller = (PictureViewController *)segue.destinationViewController;
        [controller setEventId:self.sportingEventObjId];
        [controller setPictureList:self.imageFileNames];
        [controller setNumPictureViews:self.numImageViewsList];
        [controller setPictureObjectIds:self.imageObjectIds];
        [controller setCreatedAtArray:self.createdAtArray];
        [controller setEventLocation:self.eventGeoPoint];
        [controller setCaptionsArray:self.captionsArray];
        
        
    }
    else if ([segue.identifier isEqualToString:@"goToWebViewFromSportOther"]) {
        MyWebViewController *controller = (MyWebViewController *)segue.destinationViewController;
        [controller setFullURL:self.fullURL];

    }

  
    [self stopSpinningWheel];
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
