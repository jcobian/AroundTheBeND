//
//  UITextView+ResizeFont.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/26/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "UITextView+ResizeFont.h"

@implementation UITextView (ResizeFont)
-(void)adjustTextViewFontSize {
    UIFont *font = [self font];
    
    int width = self.frame.size.width, height = self.frame.size.height;
    
    self.contentInset = UIEdgeInsetsMake(-8, -4, 0, 0);
    
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:font forKey:NSFontAttributeName];
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(width, height)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:atts
                                                          context:nil];
    
    
    CGRect frame = self.frame;
    frame.size.height  = rect.size.height + 4;
    self.frame = frame;
}
@end
