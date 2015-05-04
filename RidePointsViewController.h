//
//  RidePointsViewController.h
//  CarPooling
//
//  Created by atk's mac on 25/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RidePointCell.h"
#import "DefineMainValues.h"
#import "ServerConnection.h"
#import "WTStatusBar.h"
#import "PurchaseViewController.h"
#import "RidePointModel.h"
#import "REFrostedViewController.h"

@interface RidePointsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    ServerConnection *ConnectToServer;
    RidePointModel *mRidePointModel;
      NSMutableArray *ridePointData;
}
@property (weak, nonatomic) IBOutlet UITableView *pointsTable;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@end
