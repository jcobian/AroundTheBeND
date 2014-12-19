//
//  InfoViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/3/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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

    [self.nameLabel setText:self.name];
    [self.nameLabel adjustsFontSizeToFitWidth];
    
    if(self.address) {
        [self.addressButton setTitle:self.address forState:UIControlStateNormal];
    }
    else {
        [self.addressButton setHidden:YES];
    }
    
    if(self.phone) {
        [self.phoneNumberButton setTitle:self.phone forState:UIControlStateNormal];
    }
    else {
        [self.phoneNumberButton setHidden:YES];
    }
    
    if(self.website) {
    [self.websiteButton setTitle:self.website forState:UIControlStateNormal];
    }
    else {
        [self.websiteButton setHidden:YES];
    }
    
    [self.myMapView setDelegate:self];
    CLLocationCoordinate2D coord = {.latitude =  self.location.coordinate.latitude, .longitude =  self.location.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
    MKCoordinateRegion region = {coord, span};
    
    [self.myMapView setRegion:region];
    
    MKPinAnnotationView *annotation = [[MKPinAnnotationView alloc] init];
    [annotation setPinColor:MKPinAnnotationColorGreen];
    annotation.annotation = [[MKPointAnnotation alloc] init];
    [annotation setAnimatesDrop:YES];
    [annotation.annotation setCoordinate:self.location.coordinate];
    [self.myMapView addAnnotation:annotation.annotation];
    

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)phoneButtonPressed:(id)sender {
    
    NSString *phNo = self.phone;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
 
}
- (IBAction)websiteButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"goToWebViewFromEvent" sender:self];
}
- (IBAction)addressButtonPressed:(id)sender {
    UIAlertView *ask = [[UIAlertView alloc] initWithTitle:@"Continue to maps" message:@"Would you like to get directions to this location via Apple Maps?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [ask show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    {
        
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass     respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate =
            CLLocationCoordinate2DMake(self.location.coordinate.latitude,self.location.coordinate.longitude);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:self.address];
            
            // Set the directions mode to "Driving"
            // Can use MKLaunchOptionsDirectionsModeWalking instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey :   MKLaunchOptionsDirectionsModeDriving };
            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }
        
        
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToWebViewFromEvent"]) {
        MyWebViewController *controller = (MyWebViewController *)segue.destinationViewController;
        [controller setFullURL:self.website];

        
    }
}
/*
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
-(CLLocation *)location {
    if(!self.location) {
        self.location = [[CLLocation alloc] init];
    }
    return self.location;
}
 */


@end
