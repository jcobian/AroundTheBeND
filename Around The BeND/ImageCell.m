//
//  ImageCell.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/6/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeButtonPressed:(id)sender {
    NSLog(@"like pressed in ImageCell.m");
    
}

@end
