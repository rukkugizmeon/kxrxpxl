//
//  ProfileViewController.h
//  CarPooling
//
//  Created by shebin on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineMainValues.h"
#import "MZLoadingCircle.h"
#import "UpdateProfileViewController.h"
#import "REFrostedViewController.h"
#import "BinSystemsServerConnectionHandler.h"

@interface ProfileViewController : UIViewController
{
    MZLoadingCircle *loadingCircle;
}
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UIButton *genderSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rideOptionSegment;

@property (weak, nonatomic) IBOutlet UIView *LoadingView;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *profilecityLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileCarModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileCarBrandLabel;

@property (weak, nonatomic) IBOutlet UILabel *profileSeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileSosContactNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileSosEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileRidePointBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNoOfRidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileApprovalStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileCompanyNameLabel;

@end
