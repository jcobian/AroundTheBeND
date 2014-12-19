//
//  SportsListViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/14/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "SportsListViewController.h"

@interface SportsListViewController ()

@end

@implementation SportsListViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    [self.myTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    
    self.tabBarController.tabBar.barTintColor =  [UIColor darkGrayColor];
    
       
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    self.startDatesArray = [[NSMutableArray alloc] init];
    self.dictOfArrays = [[NSMutableDictionary alloc] init];
    
    self.fullURL = [[NSString alloc] init];
    

    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed:NAV_BAR]
                               forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.shadowImage = [UIImage new];
    self.myNavigationBar.translucent = YES;
    
   


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
        
    }
}
-(void)startSpinningWheel {
    [self.spinningWheel startAnimating];
    //[self.view addSubview:self.spinningWheel];
    [self.myTableView setUserInteractionEnabled:NO];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.myTableView setUserInteractionEnabled:YES];
    
}


-(void)grabOtherEvents {
    [self startSpinningWheel];
    self.startDatesArray = [[NSMutableArray alloc] init];
    self.dictOfArrays = [[NSMutableDictionary alloc] init];
    PFQuery *sportsQuery = [PFQuery queryWithClassName:OTHER_TABLE_NAME];
    __block NSNumber *dictKey = [[NSNumber alloc] initWithInt:0]; //very first time it will be incremented so set to -1

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //convert utc time to south bend time
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps2 = [NSDateComponents new];
    comps2.hour = -4;
    currentDate = [calendar dateByAddingComponents:comps2 toDate:currentDate options:0];
    
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 7;
    NSDate *sevenDays = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [sportsQuery whereKey:OTHER_COLUMN_DATE lessThanOrEqualTo:sevenDays];
    [sportsQuery whereKey:OTHER_COLUMN_DATE greaterThanOrEqualTo:currentDate];
    
    [sportsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            
            if([objects count] >0) {
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                PFObject *object = [objects objectAtIndex:0];
                
                [self.startDatesArray addObject:object[OTHER_COLUMN_DATE_STR]];
                for(PFObject *obj in objects) {
                    if([self.startDatesArray containsObject:obj[OTHER_COLUMN_DATE_STR]] == NO) {
                        [self.startDatesArray addObject:obj[OTHER_COLUMN_DATE_STR]];
                        [self.dictOfArrays setObject:tempArray forKey:dictKey];
                        tempArray = [[NSMutableArray alloc] init];
                        int value = [dictKey intValue];
                        dictKey = [NSNumber numberWithInt:value + 1];
                    }
                    [tempArray addObject:obj];
                    
                }
                //add the last array to the dictionary of arrays
                [self.dictOfArrays setObject:tempArray forKey:dictKey];
                
                [self stopSpinningWheel];
                [self.myTableView reloadData];
            }
            else {
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No Upcoming Sporting Events" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                //[alertView show];
                NSLog(@"No upcoming other events");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No Upcoming Other Events" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [self stopSpinningWheel];
            }
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self stopSpinningWheel];
        }
        
        
    }];
    
}
-(NSString *)getCurrentDate {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    NSLog(@"%@",[formatter stringFromDate:now]); //--> 9/9/11 11:54 PM
    NSDate *currentDate = [[NSDate alloc] init];
    currentDate = [formatter dateFromString:[formatter stringFromDate:now]];
    return [formatter stringFromDate:now];
    //return currentDate;
}
-(void)grabSportsEvents {
    [self startSpinningWheel];
    self.startDatesArray = [[NSMutableArray alloc] init];
    self.dictOfArrays = [[NSMutableDictionary alloc] init];
    PFQuery *sportsQuery = [PFQuery queryWithClassName:SPORT_TABLE_NAME];
    __block NSNumber *dictKey = [[NSNumber alloc] initWithInt:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    //convert utc time to south bend time
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps2 = [NSDateComponents new];
    comps2.hour = -4;
    currentDate = [calendar dateByAddingComponents:comps2 toDate:currentDate options:0];
    
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 7;
    NSDate *sevenDays = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [sportsQuery whereKey:SPORT_COLUMN_DATE lessThanOrEqualTo:sevenDays];
    [sportsQuery whereKey:SPORT_COLUMN_DATE greaterThanOrEqualTo:currentDate];
    [sportsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            if([objects count] >0) {
                NSLog(@"got objects");
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                PFObject *object = [objects objectAtIndex:0];
        
                [self.startDatesArray addObject:object[SPORT_COLUMN_DATE_STR]];
                for(PFObject *obj in objects) {
                    if([self.startDatesArray containsObject:obj[SPORT_COLUMN_DATE_STR]] == NO) {
                        [self.startDatesArray addObject:obj[SPORT_COLUMN_DATE_STR]];
                        [self.dictOfArrays setObject:tempArray forKey:dictKey];
                        tempArray = [[NSMutableArray alloc] init];
                        int value = [dictKey intValue];
                        dictKey = [NSNumber numberWithInt:value + 1];
                        NSDate *eventDate = obj[SPORT_COLUMN_DATE];
                        NSLog(@"Event date for  %@ is %@",obj[SPORT_COLUMN_TEAM],eventDate);
                    }
                    [tempArray addObject:obj];
                    
                }
                //add the last array to the dictionary of arrays
                [self.dictOfArrays setObject:tempArray forKey:dictKey];
                
                [self stopSpinningWheel];
                [self.myTableView reloadData];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No Upcoming Sporting Events" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [self stopSpinningWheel];
            }
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self stopSpinningWheel];
        }
        
        
    }];
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
- (IBAction)logoutPressed:(id)sender {
    if([PFUser currentUser]) {
        [PFUser logOut];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.firstTime = YES;
    appDelegate.selectedTag = 0;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.startDatesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[NSNumber alloc] initWithLong:section];
    return [[self.dictOfArrays objectForKey:key] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *key = [[NSNumber alloc] initWithLong:indexPath.section];
 
    
    
    static NSString *CellIdentifier = @"sportsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
    // Configure the cell...
    NSArray *currentArray = [self.dictOfArrays objectForKey:key];

    PFObject *obj = [currentArray objectAtIndex:indexPath.row];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.selectedTag == 2) {
        [cell.textLabel setText:obj[SPORT_COLUMN_TEAM]];

        
    }
    else if (appDelegate.selectedTag == 3) {
        [cell.textLabel setText:obj[OTHER_COLUMN_NAME]];

        
    }
    
    
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self startSpinningWheel];

    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSNumber *key = [[NSNumber alloc] initWithLong:indexPath.section];
    NSArray *currentArray = [self.dictOfArrays objectForKey:key];
    PFObject *object = [currentArray objectAtIndex:indexPath.row];
    
    
    
    
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SportingEventViewController *controller = (SportingEventViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SportingEventVC"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.selectedTag == 2) {
        [controller setTeamNameString:object[SPORT_COLUMN_TEAM]];
        [controller setDescription:object[SPORT_COLUMN_DESCRIPTION]];
        [controller setLocationStr:object[SPORT_COLUMN_LOCATION]];
        [controller setTimeStr:object[SPORT_COLUMN_START_TIME]];
        [controller setFullURL:object[SPORT_COLUMN_WEBSITE]];

        [controller setSportingEventObjId:[object objectId]];
        
    }
    else if (appDelegate.selectedTag == 3) {
        [controller setTeamNameString:object[OTHER_COLUMN_NAME]];
        [controller setDescription:object[OTHER_COLUMN_DESCRIPTION]];
        [controller setLocationStr:object[OTHER_COLUMN_LOCATION]];
        [controller setTimeStr:object[OTHER_COLUMN_START_TIME]];
        [controller setFullURL:object[OTHER_COLUMN_WEBSITE]];


        [controller setSportingEventObjId:[object objectId]];
        
    }


    
    UINavigationController *theNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self stopSpinningWheel];
    // present
    [self presentViewController:theNavController animated:YES completion:nil];
    
    
    
    
    
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[NSString alloc]init];
    title=@"";
    for(int i=0;i<self.startDatesArray.count;i++)
    {
        if(section==i)
        {
            title = [self.startDatesArray objectAtIndex:i];
        }
    }
    
    
    
    return title;
}
- (IBAction)infoButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoDisclaimerViewController *controller = (InfoDisclaimerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"InfoDisclaimerVC"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - Tab Bar Controller delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedTag = tabBarController.selectedIndex;
    if(appDelegate.selectedTag == 2) {
        [self grabSportsEvents];
        
    }
    else if (appDelegate.selectedTag == 3) {
        [self grabOtherEvents];
        
    }
    


}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



@end
