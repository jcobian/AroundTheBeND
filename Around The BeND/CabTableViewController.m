//
//  CabTableViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/4/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "CabTableViewController.h"

@interface CabTableViewController ()

@end

@implementation CabTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]]];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //shift the table view down so it doesn't hug the top
    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    self.phoneNumbers = [[NSMutableArray alloc] init];
    self.cabNames = [[NSMutableArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self getCabInfo];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getCabInfo {
    //TODO: ADD SPINNING WHEEL
    PFQuery *query = [PFQuery queryWithClassName:CAB_TABLE_NAME];
    //[query orderByDescending:CAB_COLUMN_PRIORITY];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"AAAAAAAHFJADLFJAFJ");
            NSLog(@"Here!! Error: %@",error);
        }
        else {
            for(PFObject *obj in objects) {
                [self.cabNames addObject:obj[CAB_COLUMN_NAME]];
                [self.phoneNumbers addObject:obj[CAB_COLUMN_PHONE]];
            }
            [self.tableView reloadData];
        }

    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.cabNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cabCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    [[cell textLabel] setTextColor:[UIColor lightGrayColor]];

    // Configure the cell...
    [cell.textLabel setText:[self.cabNames objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *phoneNumber = [self.phoneNumbers objectAtIndex:indexPath.row];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        
        [[UIApplication sharedApplication] openURL:phoneUrl];
        PFQuery *query = [PFQuery queryWithClassName:CAB_TABLE_NAME];
        NSString *cabName = [self.cabNames objectAtIndex:indexPath.row];
        [query whereKey:CAB_COLUMN_NAME equalTo:cabName];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self updateNumViewsOnObject:object withKey:CAB_COLUMN_NUM_CALLS];
        }];
        
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }

}

-(void)updateNumViewsOnObject:(PFObject *)obj withKey:(NSString *)key{
    NSNumber *views = obj[key];
    int value = [views intValue];
    views = [NSNumber numberWithInt:value + 1];
    [obj setObject:views forKey:key];
    [obj saveEventually];
}
/*
-(NSMutableArray *)cabNames {
    if(!self.cabNames) {
        self.cabNames = [[NSMutableArray alloc] init];
    }
    return self.cabNames;
}
-(NSMutableArray *)phoneNumbers {
    if(!self.phoneNumbers) {
        self.phoneNumbers = [[NSMutableArray alloc] init];
    }
    return self.phoneNumbers;
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
