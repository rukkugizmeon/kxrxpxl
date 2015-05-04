//
//  LoginViewController.h
//  CarPooling
//
//  Created by atk's mac on 23/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "DefineMainValues.h"
#import "ServerConnection.h"
#import "SevenSwitch.h"
#import "MyRoutesViewController.h"
#import "ViewController.h"
#import "DropDownView.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    MZLoadingCircle *loadingCircle;
    DropDownView *dropDownView;
}


@property (weak, nonatomic) IBOutlet UIView *bothContainer;
- (IBAction)giverAction:(id)sender;
- (IBAction)takerAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *appLogo;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mSpinner;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UITextField *mUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *mLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *mRegisterButton;
@property (strong,nonatomic) NSString * AuthUsername;
@property (strong,nonatomic) NSString * AuthPassword;
@end
