//
//  UploadImageViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/25/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "UploadImageViewController.h"

@interface UploadImageViewController ()

@end

@implementation UploadImageViewController

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

    [self.captionTextView setDelegate:self];
    self.captionTextView.textColor = [UIColor lightGrayColor];
    [self.captionTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    
    self.captionTextView.text = @"Write a comment...";
    self.isPlaceholderText = YES;

/*
    self.myImageView.file = [PFFile fileWithData:self.imageData];
    //[self.myImageView loadInBackground];
    [self.myImageView loadInBackground:^(UIImage *image, NSError *error) {
        if(error) {
            NSLog(@"Error: %@",error);
        }
        else {
            NSLog(@"Success");
        }
    }];
 */
    [self.myImageView setImage:self.image];
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    if([self.spinningWheel isAnimating]) {
        [self stopSpinningWheel];
    }
}

-(void)startSpinningWheel {
    [self.captionTextView setUserInteractionEnabled:NO];
    [self.shareButton setUserInteractionEnabled:NO];
    [self.spinningWheel startAnimating];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.captionTextView setUserInteractionEnabled:YES];
    [self.shareButton setUserInteractionEnabled:YES];
    
}

- (IBAction)shareButtonPressed:(id)sender {

    [self startSpinningWheel];
    [self uploadImage:self.imageData];

}
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
            
            //upload caption
            if(self.captionTextView.text.length > 0 && self.isPlaceholderText == NO) {
                [eventPhoto setObject:self.captionTextView.text forKey:EVENT_IMAGE_CAPTION];
                
            }
            

            
            [eventPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                    NSLog(@"Image saved");
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your photo has been posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alertView show];
                    //reloads all images from the server
                    //[self reloadImages]
                    //[self refreshImagesAndViews];
                    
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
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self stopSpinningWheel];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (IBAction)backgroundButtonPressed:(id)sender {
    [self.captionTextView resignFirstResponder];
}

#pragma mark - Text View Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([self.captionTextView.text isEqualToString:@"Write a comment..."]){
        self.captionTextView.text = @"";
    }
    self.captionTextView.textColor = [UIColor whiteColor];
    self.isPlaceholderText = NO;
    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.captionTextView.text.length == 0){
        self.captionTextView.textColor = [UIColor lightGrayColor];
        self.captionTextView.text = @"Write a comment...";
        self.isPlaceholderText = YES;
        [self.captionTextView resignFirstResponder];
    }
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
