//
//  PurchaseViewController.h
//  CarPooling
//
//  Created by atk's mac on 28/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiKwikSDK.h"
#import "WTStatusBar.h"
#import "ServerConnection.h"
#import "DefineMainValues.h"
#import "REFrostedViewController.h"

@interface PurchaseViewController : UIViewController
{
    ServerConnection *ConnectToServer;
}
@property (weak, nonatomic) IBOutlet UITextField *CardNoField;
@property (weak, nonatomic) IBOutlet UITextField *expiryDate;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *payOptionField;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;

@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoField;
@property (weak, nonatomic) IBOutlet UITextField *emailIdField;
@property (weak, nonatomic) IBOutlet UISwitch *debitWalletSelector;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;


@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *debitWalletLabel;



@end
