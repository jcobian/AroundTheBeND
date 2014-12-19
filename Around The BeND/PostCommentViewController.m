//
//  PostCommentViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/19/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "PostCommentViewController.h"

@interface PostCommentViewController ()

@end

@implementation PostCommentViewController

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

    self.myImageView.file = self.myPfFile;
    [self.myImageView loadInBackground];
    
    [self.commentTextView setDelegate:self];
    self.commentTextView.textColor = [UIColor lightGrayColor];
    [self.commentTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];

    self.commentTextView.text = @"Write a comment...";
    self.isPlaceholderText = YES;
    
    
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
    [self.commentTextView setUserInteractionEnabled:NO];
    [self.postCommentButton setUserInteractionEnabled:NO];
    [self.spinningWheel startAnimating];
    
}
-(void)stopSpinningWheel {
    [self.spinningWheel stopAnimating];
    [self.commentTextView setUserInteractionEnabled:YES];
    [self.postCommentButton setUserInteractionEnabled:YES];
    
    
    
}

- (IBAction)postCommentButtonPressed:(id)sender {
    [self startSpinningWheel];
     if(self.commentTextView.text.length > 0 && self.isPlaceholderText == NO) {
     PFObject *obj = [PFObject objectWithClassName:COMMENT_TABLE_NAME];
     obj[COMMENT_COLUMN_TEXT] = self.commentTextView.text;
     obj[COMMENT_COLUMN_PICTURE_ID] = self.pictureId;
     [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             if(succeeded) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your comment has been posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alertView show];
             }
             else {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alertView show];
             
                NSLog(@"Error: %@",error);
                 
                 
             }
         
         }];

     
     }
     else {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Please place a comment before posting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [alertView show];
     }
     

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self stopSpinningWheel];
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (IBAction)backgroundButtonPressed:(id)sender {
    [self.commentTextView resignFirstResponder];
}

#pragma mark - Text View Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.commentTextView.text = @"";
    self.commentTextView.textColor = [UIColor lightGrayColor];
    self.isPlaceholderText = NO;
    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.commentTextView.text.length == 0){
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.text = @"Write a comment...";
        self.isPlaceholderText = YES;
        [self.commentTextView resignFirstResponder];
    }
}
/*
-(PFFile *)myPfFile {
    if(!self.myPfFile) {
        self.myPfFile = [[PFFile alloc] init];
    }
    return self.myPfFile;
}
-(NSString *)pictureId {
    if(!self.pictureId) {
        self.pictureId = [[NSString alloc] init];
    }
    return self.pictureId;
}
*/
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
