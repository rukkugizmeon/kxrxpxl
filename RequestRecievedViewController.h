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

@interface RequestRecievedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *path;
    NSMutableArray * reqListArray;
     NSMutableArray * passListArray;
    RecievedReqModel *mRequestModel;
    PassengerListModel *mPassengerModel;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (weak, nonatomic) IBOutlet UIStepper *zoom;
@property (weak, nonatomic) IBOutlet UITableView *passengerTable;

@end
