//
//  RegistrationViewController.h
//  CarPooling
//
//  Created by atk's mac on 24/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineMainValues.h"
#import "MZLoadingCircle.h"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
{
    NSString *Gender;
    NSString *RideOption;
      MZLoadingCircle *loadingCircle;
}


@property (weak, nonatomic) IBOutlet UIView *TopLayer;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *mRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *mCancelButton;
@property (weak, nonatomic) IBOutlet UITextView *mAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *mUsername;
@property (weak, nonatomic) IBOutlet UITextField *mPassword;
@property (weak, nonatomic) IBOutlet UITextField *mConPassword;
@property (weak, nonatomic) IBOutlet UITextField *mNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mAgeTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mGenderSegment;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mCityTextField;
@property (weak, nonatomic) IBOutlet UITextField *mCarModelTextField;
@property (weak, nonatomic) IBOutlet UITextField *mCarBrandTextField;
@property (weak, nonatomic) IBOutlet UITextField *mNoOfSeatsTextField;
@property (weak, nonatomic) IBOutlet UITextField *mSosEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mSosPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPointsTextField;
@property (weak, nonatomic) IBOutlet UITextField *mNoOfRidesTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mRideOptionSegment;
@property (weak, nonatomic) IBOutlet UITextField *mApprovalStatus;
@property (weak, nonatomic) IBOutlet UITextField *mCompanyTextField;
@property (strong,nonatomic) NSString * UserName;
@property (strong,nonatomic) NSString * Password;
@property (strong,nonatomic) NSString * ConPassword;
@property (strong,nonatomic) NSString * Name;
@property (strong,nonatomic) NSString * Age;
@property (strong,nonatomic) NSString * Phone;
@property (strong,nonatomic) NSString * Address;
@property (strong,nonatomic) NSString * City;
@property (strong,nonatomic) NSString * CarModel;
@property (strong,nonatomic) NSString * CarBrand;
@property (strong,nonatomic) NSString * NoOfSeats;
@property (strong,nonatomic) NSString * SosEmail;
@property (strong,nonatomic) NSString * SosPhone;
@property (strong,nonatomic) NSString * NoOfRides;
@property (strong,nonatomic) NSString * RidePoints;
@property (strong,nonatomic) NSString * ApprovalStatus;
@property (strong,nonatomic) NSString * CompanyName;

@end
