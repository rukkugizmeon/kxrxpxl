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
#import "MyRoutesViewController.h"

@interface EditRouteViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
  
  NSMutableArray * mSelectedArray;
    ServerConnection *ConnectToServer;
}

@property (weak, nonatomic) IBOutlet UISlider *seatSlider;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
- (IBAction)seatValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *takerContainer;
@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thurButton;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;

- (IBAction)sunClick:(id)sender;
- (IBAction)monClick:(id)sender;
- (IBAction)tueClick:(id)sender;
- (IBAction)wedClick:(id)sender;
- (IBAction)thursClick:(id)sender;
- (IBAction)friClick:(id)sender;
- (IBAction)satClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *noOfSeatField;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIPickerView *mIntervalPicker;


@property (weak, nonatomic) IBOutlet UIButton *editButton;

//Variables

@property (strong, nonatomic)  NSString *seats;
@property (strong, nonatomic)  NSString *activeDays;
@property (strong, nonatomic)  NSString *activeDaysRaw;
@property (strong, nonatomic)  NSString *timeInterval;
@property (strong, nonatomic)  NSString *journeyId;
@end
