//
//  RequestRecievedViewController.h
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "WTStatusBar.h"
#import "ServerConnection.h"
#import "DefineMainValues.h"
#import "RecievedReqModel.h"
#import "PassengerListTableViewCell.h"
#import "PassengerListView.h"
#import "PassengerListModel.h"
#import "RequestedProfileView.h"
#import "REFrostedViewController.h"

@interface RequestRecievedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *path;
    NSMutableArray * reqListArray;
     NSMutableArray * passListArray;
    RecievedReqModel *mRequestModel;
    PassengerListModel *mPassengerModel;
    UIAlertView *Alerts;
    RequestedProfileView *AccessoryView;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (weak, nonatomic) IBOutlet UITableView *passengerTable;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;

//Profile view
- (IBAction)closeView:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *ageField;
@property (weak, nonatomic) IBOutlet UILabel *addressField;
@property (weak, nonatomic) IBOutlet UILabel *cityField;
@property (weak, nonatomic) IBOutlet UILabel *carModelField;
@property (weak, nonatomic) IBOutlet UILabel *seatsField;
@property (weak, nonatomic) IBOutlet UILabel *sosContactField;
@property (weak, nonatomic) IBOutlet UILabel *SOSEmailField;
@property (weak, nonatomic) IBOutlet UILabel *phoneField;
@property (weak, nonatomic) IBOutlet UIView *views;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UILabel *seats;

@property (strong, nonatomic) IBOutlet UILabel *routeFrom;
@property (strong, nonatomic) IBOutlet UILabel *routeTo;

@end
