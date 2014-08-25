//
//  EditRouteViewController.h
//  CarPooling
//
//  Created by atk's mac on 20/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineMainValues.h"
#import "ServerConnection.h"
#import "WTStatusBar.h"

@interface EditRouteViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
  
  NSMutableArray * mSelectedArray;
    ServerConnection *ConnectToServer;
}
@property (weak, nonatomic) IBOutlet UITextField *noOfSeatField;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalSegment;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UISwitch *sunSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *monSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *thursSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *friSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *satSwitch;

//Variables

@property (strong, nonatomic)  NSString *seats;
@property (strong, nonatomic)  NSString *activeDays;
@property (strong, nonatomic)  NSString *activeDaysRaw;
@property (strong, nonatomic)  NSString *timeInterval;
@property (strong, nonatomic)  NSString *journeyId;
@end
