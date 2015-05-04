//
//  SlidingRootViewController.m
//  ParivarTree
//
//  Created by atk's mac on 09/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "SlidingRootViewController.h"

@interface SlidingRootViewController ()
{

    SlidingMenuViewController *menu;
}
@end

@implementation SlidingRootViewController

- (void)awakeFromNib
{
   
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
  
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    }


@end
