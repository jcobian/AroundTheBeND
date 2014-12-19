//
//  ListViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

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
    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat verticalOffset = 10;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view.
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.tabBarController.delegate = self;
    self.currentWeekday = [[NSString alloc] init];
    [self setDayOFWeek];
    
    
    self.eventList = [[NSMutableArray alloc] init];
    
    //on first time, populate list when load, after that will get called in tabbar delegate method
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.firstTime == YES) {
       // [self.tabBarController setSelectedIndex:appDelegate.selectedTag];
        [self startSpinningWheel];
        [self populateEventList];
        appDelegate.firstTime = NO;
    
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    [self.mySegmentedControl setBackgroundColor:[UIColor darkGrayColor]];
    [self.mySegmentedControl setTintColor:[UIColor lightGrayColor]];
    [self.myTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    
   // [self.tabBarController.tabBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackishBackground.png"]]];
    self.tabBarController.tabBar.barTintColor =  [UIColor darkGrayColor];
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //[self testFacebookStuff];
    
    self.websitesArray = [[NSMutableArray alloc] init];
    self.fullURL = [[NSString alloc] init];
 
    self.canDisplayBannerAds = YES;
    [self.myBannerView setHidden:YES];
    [self.myBannerView setDelegate:self];
    
   
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed:NAV_BAR]
                             forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.shadowImage = [UIImage new];
    self.myNavigationBar.translucent = YES;


    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/*
-(void)testFacebookStuff {
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSLog(@"%@",name);
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}
 */
-(void)viewWillAppear:(BOOL)animated {
    [self.myTableView setUserInteractionEnabled:YES];
    [self.mySegmentedControl setUserInteractionEnabled:YES];
   
  
    

    
}

-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
    [self.myBannerView setDelegate:nil];
    [self.myBannerView setHidden:YES];

}
-(void)startSpinningWheel {
    [self.spinningWheel startAnimating];
    //[self.view addSubview:self.spinningWheel];
    [self.mySegmentedControl setUserInteractionEnabled:NO];
    [self.myTableView setUserInteractionEnabled:NO];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.mySegmentedControl setUserInteractionEnabled:YES];
    [self.myTableView setUserInteractionEnabled:YES];
    
}
#pragma mark - Banner View Delegate

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"loaded ad");
    [self.myBannerView setHidden:NO];

}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"will load ad");

}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    //NSLog(@"Error: %@",error);
    //NSLog(@"Error localized description: %@",[error localizedDescription]);
    [self.myBannerView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutPressed:(id)sender {
    if([PFUser currentUser]) {
        [PFUser logOut];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.firstTime = YES;
    appDelegate.selectedTag = 0;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void) populateEventList {
    
    [self.eventList removeAllObjects];
    [self.websitesArray removeAllObjects];
    [self.myTableView reloadData];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *companyQuery = [PFQuery queryWithClassName:COMPANY_TABLE_NAME];
    NSString *specialQueryTableName = [[NSString alloc] init];
    NSString *specialQueryWeekday = [[NSString alloc] init];
    NSString *specialQueryPointerString = [[NSString alloc] init];
    NSString *companyQueryPriority = [[NSString alloc] init];
    NSString *companyQueryName = [[NSString alloc] init];
    
    NSNumber *trueBool = [NSNumber numberWithBool:TRUE];

    companyQueryPriority = COMPANY_COLUMN_PRIORITY;
    companyQueryName = COMPANY_COLUMN_NAME;

    if (appDelegate.selectedTag == 0) {
        [companyQuery whereKey:COMPANY_IS_BAR equalTo:trueBool];
        specialQueryTableName = BAR_SPECIAL_TABLE_NAME;
        specialQueryWeekday = BAR_SPECIAL_COLUMN_DAY_OF_WEEK;
        specialQueryPointerString = BAR_SPECIAL_COLUMN_BAR_POINTER_STRING;
        
    }
    else if (appDelegate.selectedTag == 1)
    {
        [companyQuery whereKey:COMPANY_IS_RESTAURANT equalTo:trueBool];
        specialQueryTableName = RESTAURANT_SPECIAL_TABLE_NAME;
        specialQueryWeekday = RESTAURANT_SPECIAL_COLUMN_DAY_OF_WEEK;
        specialQueryPointerString = RESTAURANT_SPECIAL_COLUMN_RESTAURANT_POINTER_STRING;
        
    }
    else if (appDelegate.selectedTag == 2) {
        [self stopSpinningWheel];
        return;
        
    }
    else if (appDelegate.selectedTag == 3) {
        [self stopSpinningWheel];
        return;
    }
    PFQuery *specialQuery = [PFQuery queryWithClassName:specialQueryTableName];
    [specialQuery whereKey:specialQueryWeekday equalTo:self.currentWeekday];
    [companyQuery whereKey:PARSE_OBJECT_ID matchesKey:specialQueryPointerString inQuery:specialQuery];
    [companyQuery orderByDescending:companyQueryPriority];
    NSArray *keys = [[NSArray alloc] initWithObjects:companyQueryName,nil];
    [companyQuery selectKeys:keys];
    [companyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *obj in objects) {
                [self.eventList addObject:obj[companyQueryName]];
            }
            [self.myTableView reloadData];
            [self stopSpinningWheel];
            // [self.myTableView setUserInteractionEnabled:YES];
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

-(void)setDayOFWeek {
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
    [self.mySegmentedControl setSelectedSegmentIndex:weekday-1];
    
    switch (weekday) {
        case 1:
            self.currentWeekday = SUNDAY;
            break;
        case 2:
            self.currentWeekday = MONDAY;
            break;
        case 3:
            self.currentWeekday = TUESDAY;
            break;
        case 4:
            self.currentWeekday = WEDNESDAY;
            break;
        case 5:
            self.currentWeekday = THURSDAY;
            break;
        case 6:
            self.currentWeekday = FRIDAY;
            break;
        case 7:
        default:
            self.currentWeekday = SATURDAY;
            break;
    }
    
}

#pragma mark - Tab Bar Controller delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedTag = tabBarController.selectedIndex;
    [self startSpinningWheel];
    [self populateEventList];
    
    if(self.myBannerView.delegate == nil) {
        [self.myBannerView setDelegate:self];
        
        [self.myBannerView setHidden:YES];
        
    }
}





#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
    // Configure the cell...
    [cell.textLabel setText:[self.eventList objectAtIndex:indexPath.row]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.myTableView setUserInteractionEnabled:NO];

    [self startSpinningWheel];


    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventViewController *controller = (EventViewController*)[storyboard instantiateViewControllerWithIdentifier:@"EventVC"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
     //fetch event
    NSString *name = [self.eventList objectAtIndex:indexPath.row];
    [controller setEventNameString:name];
    [controller setCurrentDayOfWeek:self.currentWeekday];
    NSString *specialTableName = [[NSString alloc] init];
    NSString *specialColumnDayOfWeek = [[NSString alloc] init];
    NSString *specialColumnCompanyPointerString = [[NSString alloc] init];
    NSString *specialColumnDescription = [[NSString alloc] init];
    NSString *specialColumnNumPplGoing = [[NSString alloc] init];
    NSString *specialColumnNumViews = [[NSString alloc] init];
    NSString *specialColumnHasCoupon = [[NSString alloc] init];
    NSString *specialColumnCouponMessage = [[NSString alloc] init];



    PFQuery *companyQuery = [PFQuery queryWithClassName:COMPANY_TABLE_NAME];
    [companyQuery whereKey:COMPANY_COLUMN_NAME equalTo:name];

     if(appDelegate.selectedTag == 0) {
         specialTableName = BAR_SPECIAL_TABLE_NAME;
         specialColumnDayOfWeek = BAR_SPECIAL_COLUMN_DAY_OF_WEEK;
         specialColumnCompanyPointerString = BAR_SPECIAL_COLUMN_BAR_POINTER_STRING;
         specialColumnDescription = BAR_SPECIAL_COLUMN_DESCRIPTION;
         specialColumnNumPplGoing = BAR_SPECIAL_COLUMN_NUM_PPL_GOING;
         specialColumnNumViews = BAR_SPECIAL_COLUMN_VIEWS;
         specialColumnHasCoupon = BAR_SPECIAL_COLUMN_HAS_COUPON;
         specialColumnCouponMessage = BAR_SPECIAL_COLUMN_COUPON_MESSAGE;
         
    }
     else if (appDelegate.selectedTag == 1 ) {
         specialTableName = RESTAURANT_SPECIAL_TABLE_NAME;
         specialColumnDayOfWeek = RESTAURANT_SPECIAL_COLUMN_DAY_OF_WEEK;
         specialColumnCompanyPointerString = RESTAURANT_SPECIAL_COLUMN_RESTAURANT_POINTER_STRING;
         specialColumnDescription = RESTAURANT_SPECIAL_COLUMN_DESCRIPTION;
         specialColumnNumViews = RESTAURANT_SPECIAL_COLUMN_VIEWS;
         specialColumnHasCoupon = RESTAURANT_SPECIAL_COLUMN_HAS_COUPON;
         specialColumnCouponMessage = RESTAURANT_SPECIAL_COLUMN_COUPON_MESSAGE;
     
     }

    PFQuery *query = [PFQuery queryWithClassName:specialTableName];
    [query whereKey:specialColumnDayOfWeek equalTo:self.currentWeekday];
    [query whereKey:specialColumnCompanyPointerString matchesKey:PARSE_OBJECT_ID inQuery:companyQuery];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            PFObject *obj = [objects objectAtIndex:0];
            [controller setDescription:obj[specialColumnDescription]];
            if (specialColumnNumPplGoing != nil && appDelegate.selectedTag == 0) {
                //NSString *numPpl = [[NSString alloc] initWithFormat:@"%@",obj[specialColumnNumPplGoing]];
                //[controller setNumPplGoing:numPpl];
            }
            [controller setSpecialObjId:[obj objectId]];
            [controller setPlaceObjId:obj[specialColumnCompanyPointerString]];
            
            [self updateNumViewsOnObject:obj withKey:specialColumnNumViews];
            //check for coupon
            BOOL hasCoupon = [obj[specialColumnHasCoupon] boolValue];
            [controller setHasCoupon:hasCoupon];
            if (hasCoupon == YES) {
                [controller setCouponMessage:obj[specialColumnCouponMessage]];
            }
            
            UINavigationController *theNavController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self stopSpinningWheel];
            // present
            [self presentViewController:theNavController animated:YES completion:nil];
        }
        else {
            NSLog(@"Error: %@",error);
        }
    }];

    //update company num views
    NSArray *keys = [[NSArray alloc] initWithObjects:COMPANY_COLUMN_VIEWS, nil];
    [companyQuery selectKeys:keys];
    [companyQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self updateNumViewsOnObject:object withKey:COMPANY_COLUMN_VIEWS];
    }];

  
 
}

-(void)updateNumViewsOnObject:(PFObject *)obj withKey:(NSString *)key{
    NSNumber *views = obj[key];
    int value = [views intValue];
    views = [NSNumber numberWithInt:value + 1];
    [obj setObject:views forKey:key];
    [obj saveEventually];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */
//TODO: DONT FORGET THE FOOD AND OTHER SEGMENT IS NOT CONNECTED TO THIS YET
- (IBAction)dayOfWeekChanged:(id)sender {
    
   // [self.myTableView setUserInteractionEnabled:NO];
    [self startSpinningWheel];
    
    NSInteger weekday = 0;
    //weekday -> 1-monday, 7 - sunday
    //segmented control -> 0 sunday 6->saturday
   weekday = self.mySegmentedControl.selectedSegmentIndex+1;
    
    switch (weekday) {
        case 1:
            self.currentWeekday = SUNDAY;
            break;
        case 2:
            self.currentWeekday = MONDAY;
            break;
        case 3:
            self.currentWeekday = TUESDAY;
            break;
        case 4:
            self.currentWeekday = WEDNESDAY;
            break;
        case 5:
            self.currentWeekday = THURSDAY;
            break;
        case 6:
            self.currentWeekday = FRIDAY;
            break;
        case 7:
        default:
            self.currentWeekday = SATURDAY;
            break;
    }
    [self populateEventList];
    
}
- (IBAction)infoButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoDisclaimerViewController *controller = (InfoDisclaimerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"InfoDisclaimerVC"];
    [self presentViewController:controller animated:YES completion:nil];

    
}
/*
-(NSMutableArray *)eventList {
    if(!self.eventList) {
        self.eventList = [[NSMutableArray alloc] init];
    }
    return self.eventList;
}
-(NSString *)currentWeekday {
    if(!self.currentWeekday) {
        self. currentWeekday = [[NSString alloc] init];
    }
    return self.currentWeekday;
}*/

#pragma mark - PFLogInViewControllerDelegate

/*
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];

    
    
    
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)facebookButtonTouched {
    [self.spinningWheel startAnimating];
    // The permissions requested from the user
   // NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
     NSArray *permissionsArray = @[ @"basic_info"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.spinningWheel stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self dismissViewControllerAnimated:YES completion:NULL];

            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            [self dismissViewControllerAnimated:YES completion:NULL];

            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
    
}

*/

@end
