//
//  EarningsViewController.h
//  CarPooling
//
//  Created by atk's mac on 22/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineMainValues.h"
#import "ServerConnection.h"
#import "RidePointModel.h"
#import "WTStatusBar.h"
#import "EarningsViewCell.h"

@interface EarningsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    ServerConnection *ConnectToServer;
    RidePointModel *mRidePointModel;
    NSMutableArray *earningsData;
}
@property (weak, nonatomic) IBOutlet UITableView *pointsTable;

@end
