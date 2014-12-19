//
//  ImageCell.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/6/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *numLikesLabel;

@end
