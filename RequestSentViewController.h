//
//  RequestSentViewController.h
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "WTStatusBar.h"
#import "RecievedReqModel.h"
#import "RequestSentView.h"
#import "ServerConnection.h"
#import "EDStarRating.h"

@interface RequestSentViewController : UIViewController<EDStarRatingProtocol,UIAlertViewDelegate>
{
    NSMutableArray *path;
     UIAlertView  *Alerts;
     NSString *favId;
    NSMutableArray * reqListArray;
    RecievedReqModel *mRequestModel;
      ServerConnection *ConnectToServer;
}
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (weak, nonatomic) IBOutlet EDStarRating *starRating;

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

@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UILabel *seat;
@property (weak, nonatomic) IBOutlet UIView *views;


@end
