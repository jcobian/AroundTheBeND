//
//  PictureViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

	// Do any additional setup after loading the view.
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
    [self.myTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];

    
    self.imagePicker = [[UIImagePickerController alloc]init];
    [self.imagePicker setAllowsEditing:NO];
    [self.imagePicker setDelegate:self];
    
    self.imageFile = [[PFFile alloc] init];
    self.commentsArray = [[NSMutableArray alloc] init];
    self.commentsCreatedAtArray = [[NSMutableArray alloc] init];

    self.pictureId = [[NSString alloc] init];
    self.caption = [[NSString alloc] init];

    self.locationManger = [[CLLocationManager alloc] init];
    [self.locationManger setDelegate:self];
    self.locationManger.desiredAccuracy = 1;
    
    self.imageToUpload = [[UIImage alloc] init];
    self.imageData = [[NSData alloc] init];
    
    self.firstTimeHere = YES;
    
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];



    
}

-(void)viewWillAppear:(BOOL)animated {
    if(self.firstTimeHere == NO) {
        [self refreshImagesAndViews];
    }

    
}
-(void)viewWillDisappear:(BOOL)animated {
    self.firstTimeHere = NO;
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
}

-(void)startSpinningWheel {
    [self.myTableView setUserInteractionEnabled:NO];
    [self.takePictureButton setUserInteractionEnabled:NO];
    [self.spinningWheel startAnimating];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.myTableView setUserInteractionEnabled:YES];
    [self.takePictureButton setUserInteractionEnabled:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pictureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"imageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];
    [[cell textLabel] setTextColor:[UIColor lightGrayColor]];

    //ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    PFImageView *imageView = (PFImageView *)[cell viewWithTag:1];
    imageView.file = [self.pictureList objectAtIndex:indexPath.row];
    [imageView loadInBackground];
     
     
    /*
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UIImage *theImage = (UIImage *)[self.pictureList objectAtIndex:indexPath.row];
    CGSize size = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    [imageView setImage:[theImage resizedImage:size interpolationQuality:kCGInterpolationDefault]];
     */
    
    UILabel *numLikes = (UILabel *)[cell viewWithTag:2];
    NSString *likes = [NSString stringWithFormat:@"%@",[self.numPictureViews objectAtIndex:indexPath.row]];
    [numLikes setText:likes];
    [numLikes setTextColor:[UIColor lightGrayColor]];

    
    
    NSDate *postedDate = [self.createdAtArray objectAtIndex:indexPath.row];
    //this will be in the past so multiply by -1 for calculations
    NSTimeInterval seconds = -1*[postedDate timeIntervalSinceNow];
    
    NSString *timeLabelStr = [self convertSecondsToLabel:seconds];
    UILabel *postedAgoLabel = (UILabel *)[cell viewWithTag:3];
    [postedAgoLabel setText:timeLabelStr];
    [postedAgoLabel setTextColor:[UIColor darkGrayColor]];
    
    UITextView *captionTextView = (UITextView *)[cell viewWithTag:4];
    [captionTextView setText:[self.captionsArray objectAtIndex:indexPath.row]];
    [captionTextView setTextColor:[UIColor lightGrayColor]];
    //[captionTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [captionTextView setBackgroundColor:[UIColor clearColor]];
    //[captionTextView adjustTextViewFontSize];

    
    
    return cell;
}
-(NSString *)convertSecondsToLabel:(NSTimeInterval)seconds {

    double minutes = seconds/60;
    if((int)minutes <60) {
        if(minutes < 1) {
            return @"Now";
        }
        return [NSString stringWithFormat:@"%d min ago",(int)minutes];
    }
    double hours = minutes/60;
    if((int)hours<24) {
        return [NSString stringWithFormat:@"%d hr ago",(int)hours];

    }
    double days = hours/24;
    if((int)days<7) {
        if(days == 1) {
            return [NSString stringWithFormat:@"%d day ago",(int)days];

        }
        return [NSString stringWithFormat:@"%d days ago",(int)days];
    }
    return @"+1 week ago";
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self startSpinningWheel];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //to send to single iamge vc
    self.imageFile = [self.pictureList objectAtIndex:indexPath.row];

    NSString *imageObjId = [self.pictureObjectIds objectAtIndex:indexPath.row];
    //to send to single image vc
    self.pictureId = imageObjId;
    self.caption = [self.captionsArray objectAtIndex:indexPath.row];
    
    //TODO +1 to num views on parse with obj id above
    PFQuery *query = [PFQuery queryWithClassName:EVENT_IMAGE_TABLE_NAME];
    [query getObjectInBackgroundWithId:imageObjId block:^(PFObject *object, NSError *error) {
        if(!error) {
            NSNumber *views = object[EVENT_IMAGE_NUM_VIEWS];
            int v = [views intValue];
            views = [NSNumber numberWithInt:v +1];
            [object setObject:views forKey:EVENT_IMAGE_NUM_VIEWS];
            [object saveInBackground];
        }
        else {
            NSLog(@"Error: %@",error);
        }
    }];
    
    
    

    //fetch the comments
    [self.commentsArray removeAllObjects];
    [self.commentsCreatedAtArray removeAllObjects];
    PFQuery *commentQuery = [PFQuery queryWithClassName:COMMENT_TABLE_NAME];
    [commentQuery whereKey:COMMENT_COLUMN_PICTURE_ID equalTo:imageObjId];
    [commentQuery orderByDescending:COMMENT_COLUMN_UPLOAD_TIME];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for(PFObject *obj in objects) {
                //to send to single image vc
                [self.commentsArray addObject:obj[COMMENT_COLUMN_TEXT]];
                [self.commentsCreatedAtArray addObject:obj.createdAt];
            }
          
            
            //perform segue
            [self performSegueWithIdentifier:@"goToSingleImage" sender:self];
        }
    }];
    

    
    //so that when you come back the images are updated
    [self refreshImagesAndViews];
    //make sure u don't try to access the arrays here cause they will be out of order
    
    
    
    
    
    
}

-(void)addKey:(NSString *)key toArray:(NSMutableArray *)arr WithPFObject:(PFObject *)obj WithNilOption:(NSObject *)nilOption{
    if(obj[key]) {
        [arr addObject:obj[key]];
    }
    else {
        [arr addObject:nilOption];
    }
}

//KEEP CONCURRENCY WITH QUERY IN PICTURE BUTTON PRESSED
-(void) refreshImagesAndViews {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_IMAGE_TABLE_NAME];
    [query whereKey:EVENT_IMAGE_COLUMN_EVENT_ID equalTo:self.eventId];

    [query orderByDescending:EVENT_IMAGE_NUM_VIEWS];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            [self.pictureList removeAllObjects];
             [self.pictureObjectIds removeAllObjects];
             [self.numPictureViews removeAllObjects];
             [self.createdAtArray removeAllObjects];
            [self.captionsArray removeAllObjects];
            if([objects count] > 0) {
                for(PFObject *obj in objects) {
                   /*
                    [self.pictureList addObject:obj[EVENT_IMAGE_COLUMN_IMAGE]];
                    [self.numPictureViews addObject:obj[EVENT_IMAGE_NUM_VIEWS]];
                    [self.pictureObjectIds addObject:obj.objectId];
                    [self.createdAtArray addObject:obj.createdAt];
                    [self.captionsArray addObject:obj[EVENT_IMAGE_CAPTION]];
                    */
                    [self addKey:EVENT_IMAGE_COLUMN_IMAGE toArray:self.pictureList WithPFObject:obj WithNilOption:nil];
                    [self addKey:EVENT_IMAGE_NUM_VIEWS toArray:self.numPictureViews WithPFObject:obj WithNilOption:[NSNumber numberWithInt:0]];
                    [self.pictureObjectIds addObject:obj.objectId];
                    [self.createdAtArray addObject:obj.createdAt];
                    [self addKey:EVENT_IMAGE_CAPTION toArray:self.captionsArray WithPFObject:obj WithNilOption:@""];

                    
                }
                
                
            }
            [self.myTableView reloadData];

        }
        else {
            NSLog(@"Error: %@",error);
        }
        
        
        
    }];
}
- (NSInteger)currentHour
{
    // In practice, these calls can be combined
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    
    return [components hour];
}
-(BOOL)checkIfItIsToday {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.selectedTag == 0 || appDelegate.selectedTag == 1) {
        
        NSString *todaysWeekday = [[NSString alloc] init];

        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        NSInteger weekday = [comps weekday];
        //weekday -> 1-sunday, 7 - sunday
        //segmented control -> 0 sunday 6->saturday
        
        //if before 4am, make it the previus night
        NSInteger hour = [self currentHour];
        if(hour < 4) {
            weekday = weekday -1;
            if(weekday == 0) {
                weekday = 7;
            }
        }
        
        switch (weekday) {
            case 1:
                todaysWeekday = SUNDAY;
                break;
            case 2:
                todaysWeekday = MONDAY;
                break;
            case 3:
                todaysWeekday = TUESDAY;
                break;
            case 4:
                todaysWeekday = WEDNESDAY;
                break;
            case 5:
                todaysWeekday = THURSDAY;
                break;
            case 6:
                todaysWeekday = FRIDAY;
                break;
            case 7:
            default:
                todaysWeekday = SATURDAY;
                break;
        }
        
        if([todaysWeekday isEqualToString:self.currentDayOfWeek]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        //TODO: this would be for sports and other; do some check here to see if the current date is equal to the event date
        return YES;
    }
    
    return YES;
    
}
-(void)checkIfAtLocation {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You must enable location services in Settings in order to prove you are at the event" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self.locationManger startUpdatingLocation];
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManger stopUpdatingLocation];
    [self stopSpinningWheel];
    CLLocation *loc = [locations lastObject];
   // NSLog(@"Loc of event at lat = %lf, long = %lf",self.eventLocation.coordinate.latitude,self.eventLocation.coordinate.longitude);
    CLLocation *locationOfEvent = [[CLLocation alloc] initWithLatitude:self.eventLocation.coordinate.latitude longitude:self.eventLocation.coordinate.longitude];
    if([loc distanceFromLocation:locationOfEvent] <= 500) {
        //bring up camera
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot take picture here" message:@"You are not at this event. You must be at the event to take a picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
}




- (IBAction)takePicturePressed:(id)sender {
    [self startSpinningWheel];
    if([self checkIfItIsToday]) {
        
        [self checkIfAtLocation];
      
        
        
    }
    //not current day
    else {
        [self stopSpinningWheel];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot take picture today" message:@"This event is not today. You must be at the event to take a picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }

}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self startSpinningWheel];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"X is %f, Y is %f",image.size.width,image.size.height);


    //saves the image
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    self.firstTimeHere = YES; //hack. this picture VC will slightly appear but we don't want to refresh everything cause on our wway to upload image screen
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
   // NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    self.imageData = UIImageJPEGRepresentation(smallImage, 0.05f);

   // self.imageToUpload = [PFFile fileWithData:self.imageData];
    self.imageToUpload = smallImage;

    
    self.firstTimeHere = NO;
    [self performSegueWithIdentifier:@"goToUploadImage" sender:self];

    

    
}
 


/*

-(void)uploadImage:(NSData *)imageData {
    
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *eventPhoto = [PFObject objectWithClassName:EVENT_IMAGE_TABLE_NAME];
            [eventPhoto setObject:imageFile forKey:EVENT_IMAGE_COLUMN_IMAGE];
            [eventPhoto setObject:self.eventId forKey:EVENT_IMAGE_COLUMN_EVENT_ID];
            NSNumber *zero = [[NSNumber alloc] initWithInt:0];
            [eventPhoto setObject:zero forKey:EVENT_IMAGE_NUM_VIEWS];
            
            [eventPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                    NSLog(@"Image saved");
                    
                    //reloads all images from the server
                    //[self reloadImages]
                    [self refreshImagesAndViews];
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToSingleImage"]) {
        SingleImageViewController *controller = (SingleImageViewController *)segue.destinationViewController;
        [controller setMyPfFile:self.imageFile];
        [controller setCommentsArray:self.commentsArray];
        [controller setPictureId:self.pictureId];
        [controller setCaption:self.caption];
        [controller setCommentsCreatedAtArray:self.commentsCreatedAtArray];
    }
    else if([segue.identifier isEqualToString:@"goToUploadImage"]) {
        UploadImageViewController *controller = (UploadImageViewController *)segue.destinationViewController;
        [controller setImage:self.imageToUpload];
        [controller setEventId:self.eventId];
        [controller setImageData:self.imageData];
        
    }
    [self stopSpinningWheel];
}
/*
-(UIImagePickerController *)imagePicker {
    if(!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
    }
    return self.imagePicker;
}
-(NSString *)eventId {
    if(!self.eventId) {
        self.eventId = [[NSString alloc] init];
    }
    return self.eventId;
}
-(NSString *)pictureId {
    if(!self.pictureId) {
        self.pictureId = [[NSString alloc] init];
    }
    return self.pictureId;
}
-(NSString *)currentDayOfWeek {
    if(!self.currentDayOfWeek) {
        self.currentDayOfWeek = [[NSString alloc] init];
    }
    return self.currentDayOfWeek;
}
-(PFFile *)imageFile {
    if(!self.imageFile) {
        self.imageFile = [[PFFile alloc] init];
    }
    return self.imageFile;
}

-(CLLocation *)eventLocation {
    if(!self.eventLocation) {
        self.eventLocation = [[CLLocation alloc] init];
    }
    return self.eventLocation;
}
-(CLLocationManager *)locationManger {
    if(!self.locationManger) {
        self.locationManger = [[CLLocationManager alloc] init];
    }
    return self.locationManger;
}
-(NSMutableArray *)pictureList {
    if(!self.pictureList) {
        self.pictureList = [[NSMutableArray alloc] init];
    }
    return self.pictureList;
}
-(NSMutableArray *)numPictureViews {
    if(!self.numPictureViews) {
        self.numPictureViews = [[NSMutableArray alloc] init];
    }
    return self.numPictureViews;
}
-(NSMutableArray *)pictureObjectIds {
    if(!self.pictureObjectIds) {
        self.pictureObjectIds = [[NSMutableArray alloc] init];
    }
    return self.pictureObjectIds;
}
-(NSMutableArray *)createdAtArray {
    if(!self.createdAtArray) {
        self.createdAtArray = [[NSMutableArray alloc] init];
    }
    return self.createdAtArray;
}
-(NSMutableArray *)commentsArray {
    if(!self.commentsArray) {
        self.commentsArray = [[NSMutableArray alloc] init];
    }
    return self.commentsArray;
}
-(NSMutableArray *)commentsCreatedAtArray {
    if(!self.commentsCreatedAtArray) {
        self.commentsCreatedAtArray = [[NSMutableArray alloc] init];
    }
    return self.commentsCreatedAtArray;
}
 */
@end
