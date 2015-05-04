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
#import "REFrostedViewController.h"
#import "StarRatingView.h"

@interface CoRidersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    CoridersSingleProfileView *AccessoryView ;
    ServerConnection *ConnectToServer;
    NSMutableArray *riderListArray;
    NSMutableArray *ridePassengerListArray;
    UIAlertView *Alert;
    UIAlertView  *Alerts;
    CoRiderObject *mRiderModel;
    NSString *favId;
     NSString *Rating;
    CoriderListObject *mRiderListModel;
    int one;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;

//Profile

@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *ageField;
@property (weak, nonatomic) IBOutlet UILabel *addressField;

@property (weak, nonatomic) IBOutlet UILabel *cityField;
@property (weak, nonatomic) IBOutlet UILabel *sosContactField;
@property (weak, nonatomic) IBOutlet UILabel *SOSEmailField;

@property (strong, nonatomic) IBOutlet StarRatingView *viewRating;
@property (weak, nonatomic) IBOutlet UILabel *phoneField;
- (IBAction)closeView:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *buttonFavourite;




@end
