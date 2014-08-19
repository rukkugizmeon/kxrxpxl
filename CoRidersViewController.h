//
//  CoRidersViewController.h
//  CarPooling
//
//  Created by atk's mac on 13/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ServerConnection.h"
#import "WTStatusBar.h"
#import "DefineMainValues.h"
#import "CoRiderObject.h"
#import "CoriderListObject.h"
#import "CoriderProfiles.h"
#import "CoridersSingleProfileView.h"

@interface CoRidersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    ServerConnection *ConnectToServer;
    NSMutableArray *riderListArray;
    NSMutableArray *ridePassengerListArray;
    UIAlertView *Alert;
    UIAlertView  *Alerts;
    CoRiderObject *mRiderModel;
    CoriderListObject *mRiderListModel;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (weak, nonatomic) IBOutlet UITableView *profileTable;

//Profile
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *ageField;
@property (weak, nonatomic) IBOutlet UILabel *addressField;

@property (weak, nonatomic) IBOutlet UILabel *cityField;
@property (weak, nonatomic) IBOutlet UILabel *carModelField;
@property (weak, nonatomic) IBOutlet UILabel *seatsField;
@property (weak, nonatomic) IBOutlet UILabel *sosContactField;
@property (weak, nonatomic) IBOutlet UILabel *SOSEmailField;

@property (weak, nonatomic) IBOutlet UILabel *phoneField;

@end
