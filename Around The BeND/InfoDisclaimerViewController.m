//
//  InfoDisclaimerViewController.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 4/16/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "InfoDisclaimerViewController.h"

@interface InfoDisclaimerViewController ()

@end

@implementation InfoDisclaimerViewController

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
    
    [self.myNavBar.topItem.leftBarButtonItem setTarget:self];
    [self.myNavBar.topItem.leftBarButtonItem setAction:@selector(exit:)];
    self.myNavBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    [self.disclaimerTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:TABLE_BACKGROUND_IMAGE]]];
    
    
  
    
    [self.disclaimerTextView setEditable:NO];
    [self.disclaimerTextView setTextColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)contactButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        //mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [mailer setSubject:@"Question/Suggestion to Around The BeND"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"contact@aroundthebendapp.com", nil];
        [mailer setToRecipients:toRecipients];
        

        
     
        
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your device doesn't support sending email"
                                                        message:@"Send us an email: AroundTheBeNDApp@gmail.com"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
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
