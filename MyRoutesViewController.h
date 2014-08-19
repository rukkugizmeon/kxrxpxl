//
//  MyRoutesViewController.h
//  CarPooling
//
//  Created by atk's mac on 06/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DefineMainValues.h"
#import "myRouteModel.h"
#import "DetailRouteViewController.h"
#import "MyDataView.h"
#import "WTStatusBar.h"

@interface MyRoutesViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray * journeyListArray;
    NSMutableArray * mSelectedArray;
     NSArray * DaysArray;
    myRouteModel *mRouteModel;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (strong, nonatomic) IBOutlet MyDataView *customView;
@property (weak, nonatomic) IBOutlet UILabel *noOfSeatField;
@property (weak, nonatomic) IBOutlet UILabel *mTimeIntervalField;
@property (weak, nonatomic) IBOutlet UILabel *mActiveFields;
@property (weak, nonatomic) IBOutlet UILabel *mDestField;
@property (weak, nonatomic) IBOutlet UILabel *mOriginField;
@property (weak, nonatomic) IBOutlet UISwitch *mActiveSwitch;



@end
