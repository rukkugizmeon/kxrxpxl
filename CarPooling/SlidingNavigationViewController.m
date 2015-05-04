//
//  SlidingNavigationViewController.m
//  ParivarTree
//
//  Created by atk's mac on 09/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "SlidingNavigationViewController.h"

@interface SlidingNavigationViewController ()

@end

@implementation SlidingNavigationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
   // [self.frostedViewController panGestureRecognized:sender];
}
@end
