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
#import "ServerConnection.h"
#import "MyDataView.h"
#import "WTStatusBar.h"
#import "EarningsViewController.h"
#import "EditRouteViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "RequestRecievedViewController.h"
#import "RequestSentViewController.h"
#import "RouteSelectionViewController.h"
#import "CoRidersViewController.h"
#import "RidePointsViewController.h"
#import "PurchaseViewController.h"
#import "REFrostedViewController.h"
#import "CustomIOS7AlertView.h"
#import "ModelNotification.h"
#import "BinSystemsServerConnectionHandler.h"
#import "PaymentsSDK.h"


@interface MyRoutesViewController : UIViewController<CustomIOS7AlertViewDelegate, UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PGTransactionDelegate>
{
    NSMutableArray * arrayJourneyList;
    NSMutableArray * mSelectedArray;
     NSArray * DaysArray;
    myRouteModel *mRouteModel;
    MyDataView *AccessoryView;
    UIAlertView * Alert ;
    ServerConnection *ConnectToServer;
}



@property (strong,nonatomic) BinSystemsServerConnectionHandler * AuthenticationServer;

@property (strong, nonatomic)  NSString *seats;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;
@property (strong, nonatomic)  NSString *role;
@property (strong, nonatomic)  NSString *activeDays;
@property (strong, nonatomic)  NSString *timeInterval;
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (strong, nonatomic) IBOutlet MyDataView *customView;
@property (weak, nonatomic) IBOutlet UILabel *noOfSeatField;
@property (weak, nonatomic) IBOutlet UILabel *mTimeIntervalField;
@property (weak, nonatomic) IBOutlet UILabel *mActiveFields;
@property (weak, nonatomic) IBOutlet UILabel *mDestField;
@property (weak, nonatomic) IBOutlet UILabel *mOriginField;
@property (weak, nonatomic) IBOutlet UISwitch *mActiveSwitch;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
- (IBAction)deleteRoute:(id)sender;
- (IBAction)editRouteDetails:(id)sender;

- (IBAction)closeView:(id)sender;
- (IBAction)showRouteDetail:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewNotifications;
@property (strong, nonatomic) IBOutlet UITableView *tableViewJourneyCompletionConfirmation;
@property (weak, nonatomic) IBOutlet UIView *viewFeedbackView;

@property (weak, nonatomic) IBOutlet UITextView *textViewFeedBack;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCoRiders;
@property (strong, nonatomic) IBOutlet UIView *viewCoriders;

@end
