//
//  SingleImageViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/18/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "SingleImageViewController.h"



@interface SingleImageViewController ()

@end

@implementation SingleImageViewController

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

    [self.commentsTableView setDelegate:self];
    [self.commentsTableView setDataSource:self];
    [self.commentsTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];


    self.captionTextView.text = self.caption;
    [self.captionTextView setTextColor:[UIColor lightGrayColor]];
    [self.captionTextView setUserInteractionEnabled:NO];
    self.myImageView.file = self.myPfFile;
    [self.myImageView loadInBackground];

    //[self.captionTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [self.captionTextView setBackgroundColor:[UIColor clearColor]];
    //[self.captionTextView adjustTextViewFontSize];
    
 
    
    self.spinningWheel = [[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinningWheel.center = self.view.center;
    [self.view addSubview:self.spinningWheel];
    
    self.commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];



    
}


-(void)viewWillAppear:(BOOL)animated {
    [self refreshComments];

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
    return [self.commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];

    // Configure the cell...
    UITextView *textView = (UITextView *)[cell viewWithTag:1];
    [textView setText:[self.commentsArray objectAtIndex:indexPath.row]];
    [textView setBackgroundColor:[UIColor clearColor] ];
    //[textView adjustTextViewFontSize];
    [textView setTextColor:[UIColor darkTextColor]];

    [textView setTextColor:[UIColor blackColor]];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    
    NSDate *postedDate = [self.commentsCreatedAtArray objectAtIndex:indexPath.row];
    //this will be in the past so multiply by -1 for calculations
    NSTimeInterval seconds = -1*[postedDate timeIntervalSinceNow];
    
    NSString *timeLabelStr = [self convertSecondsToLabel:seconds];
    [dateLabel setText:timeLabelStr];
    [dateLabel setTextColor:[UIColor blackColor]];

    
    //set date here
    return cell;
}
-(NSString *)convertSecondsToLabel:(NSTimeInterval)seconds {
    
    double minutes = seconds/60;
    if((int)minutes <60) {
        if(minutes <1) {
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
    [self.commentsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    
    
}
-(void)refreshComments {
    //fetch the comments

    PFQuery *commentQuery = [PFQuery queryWithClassName:COMMENT_TABLE_NAME];
    [commentQuery whereKey:COMMENT_COLUMN_PICTURE_ID equalTo:self.pictureId];
    [commentQuery orderByDescending:COMMENT_COLUMN_UPLOAD_TIME];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            [self.commentsArray removeAllObjects];
            [self.commentsCreatedAtArray removeAllObjects];
            for(PFObject *obj in objects) {
                //to send to single image vc
                [self.commentsArray addObject:obj[COMMENT_COLUMN_TEXT]];
                [self.commentsCreatedAtArray addObject:obj.createdAt];
            }
            [self.commentsTableView reloadData];
        }
        else {
            NSLog(@"Error: %@",error);
        }
        
        
    }];
}


- (IBAction)postCommentButtonPressed:(id)sender {
    [self startSpinningWheel];
    [self performSegueWithIdentifier:@"goToPostComment" sender:self];
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToPostComment"]) {
        PostCommentViewController *controller = (PostCommentViewController *)segue.destinationViewController;
        [controller setMyPfFile:self.myPfFile];
        [controller setPictureId:self.pictureId];
    }
    [self stopSpinningWheel];
}
/*

-(NSMutableArray *)commentsCreatedAtArray {
    if(!self.commentsCreatedAtArray) {
        self.commentsCreatedAtArray = [[NSMutableArray alloc] init];
    }
    return self.commentsCreatedAtArray;
}
-(NSMutableArray *)commentsArray {
    if(!self.commentsArray) {
        self.commentsArray = [[NSMutableArray alloc] init];
    }
    return self.commentsArray;
}
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
