//
//  MyFBLoginViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/6/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "MyFBLoginViewController.h"

@interface MyFBLoginViewController ()

@end

@implementation MyFBLoginViewController

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

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:FACEBOOK_BUTTON_IMAGE] forState:UIControlStateNormal];
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:FACEBOOK_BUTTON_DOWN_IMAGE] forState:UIControlStateSelected];

    [self.facebookButton setHidden:YES];
    [self.pleaseLoginLabel setHidden:YES];
    [self.facebookButton setUserInteractionEnabled:NO];
    
    //[self.myImageView setImage:[UIImage imageNamed:LOGO]];
    

}

/*
-(void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User already logged in");
        [self goToListVC];
        
    }
    
}
 */
-(void)viewDidAppear:(BOOL)animated {
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User already logged in");
        [self goToListVC];
        
    } else {
        [self.facebookButton setHidden:NO];
        [self.pleaseLoginLabel setHidden:NO];
        [self.facebookButton setUserInteractionEnabled:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToListVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListViewController *controller = (ListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
    [self presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)guestButtonPressed:(id)sender {
    NSLog(@"User signed in as guest");
    [self goToListVC];
}

#pragma mark - Login mehtods
- (IBAction)loginButtonPressed:(id)sender {
    // Set permissions required from the facebook user account
    //NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    NSArray *permissionsArray = @[ @"basic_info"];

    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.spinningWheel stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            [self goToListVC];
        } else {
            NSLog(@"User with facebook logged in!");
            [self goToListVC];
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
    
    [self.spinningWheel startAnimating]; // Show loading indicator until login is finished
}


- (IBAction)infoButtonPressed:(id)sender {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InfoDisclaimerViewController *controller = (InfoDisclaimerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"InfoDisclaimerVC"];
        [self presentViewController:controller animated:YES completion:nil];
        
        
    
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
