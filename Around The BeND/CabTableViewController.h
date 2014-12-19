//
//  CabTableViewController.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/4/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface CabTableViewController : UITableViewController
@property(strong,nonatomic) NSMutableArray *cabNames;
@property(strong,nonatomic) NSMutableArray *phoneNumbers;

@end
