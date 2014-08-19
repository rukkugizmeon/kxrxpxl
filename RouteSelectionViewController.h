//
//  RouteSelectionViewController.h
//  CarPooling
//
//  Created by atk's mac on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface RouteSelectionViewController : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *mCityPickerView;
@property (weak, nonatomic) IBOutlet UITextField *mOrigin;
@property (weak, nonatomic) IBOutlet UITextField *mDestination;
@property (weak, nonatomic) IBOutlet UIButton *mFindRouteButton;
@property (strong, nonatomic) NSArray *cityNames;
@property (strong, nonatomic) NSArray *Names;
@end