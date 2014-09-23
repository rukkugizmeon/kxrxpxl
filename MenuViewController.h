//
//  MenuViewController.h
//  CarPooling
//
//  Created by atk's mac on 25/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineMainValues.h"
#import "WTStatusBar.h"

@interface MenuViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *earningPaymentButton;
@property (strong, nonatomic)  NSString *options;
@property (weak, nonatomic) IBOutlet UIButton *mRouteOptions;
@property (weak, nonatomic) IBOutlet UIButton *coRideRidePoints;

@end
