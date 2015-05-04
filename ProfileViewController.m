//
//  ProfileViewController.m
//  CarPooling
//
//  Created by shebin on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "ProfileViewController.h"
#import "InterfaceManager.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize profileScrollView;
@synthesize profileNameLabel;
@synthesize profileAgeLabel;
@synthesize profileAddressLabel;
@synthesize profileCarBrandLabel;
@synthesize profileApprovalStatusLabel;
@synthesize profileCarModelLabel;
@synthesize profileCompanyNameLabel;
@synthesize profilecityLabel;
@synthesize profileMobileLabel;
@synthesize profileNoOfRidesLabel;
@synthesize profileSeatLabel;
@synthesize profileSexLabel,genderSwitch;
@synthesize profileRidePointBalanceLabel,rideOptionSegment;
@synthesize profileSosContactNoLabel;
@synthesize profileSosEmailLabel,LoadingView;
NSDictionary *data ;
NSUserDefaults *prefs;
NSString *RideOption;
UIBarButtonItem *editButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setupUI];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    
//    
//    int x = 0;
//    
//    int y = 10/x;
//    
//    NSLog(@"%d",y);
    
    [self webconnection];
}
-(void) viewDidAppear:(BOOL)animated
{
    
    
    [editButton setEnabled:NO];
}

-(void)webconnection
{
   [self showLoadingMode];
    UIColor * Cgrey1 =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    self.view.backgroundColor=Cgrey1;
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *id=[prefs stringForKey:@"id"];
    NSLog(@" id %@",id);
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@",id];
    
  //  NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
    
    
    
   BinSystemsServerConnectionHandler  *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_ProfileView PostData:PostString];
    
        //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        data = JSONDict;
        
        NSDictionary *profileDetailsDictionary=[data objectForKey:@"0"];
        
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        NSLog(@"Data %@",result);
       
            if([result isEqualToString:@"1"])
            {
                
                profileNameLabel.text=[profileDetailsDictionary objectForKey:@"name"];
                profileAgeLabel.text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"age"]];
                NSString *myAge=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"age"]];
                float age=[myAge floatValue];
                [self.ageSlider setValue:age];
                profileSexLabel.text=[profileDetailsDictionary objectForKey:@"gender"];
                NSString *myGender=[profileDetailsDictionary objectForKey:@"gender"];
                if([myGender isEqualToString:@"Male"] || [myGender isEqualToString:@"male"])
                {
                    
                    UIImage *male=[UIImage imageNamed:@"ridewithme_mobile_gendermale.png"];
                    [genderSwitch setImage:male forState:UIControlStateNormal];
                }
                else
                {
                    UIImage *female=[UIImage imageNamed:@"ridewithme_mobile_genderfemale.png"];
                    [genderSwitch setImage:female forState:UIControlStateNormal];
                }
                profileMobileLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"mobile_number"]];
                profileAddressLabel.text= [profileDetailsDictionary objectForKey:@"address"];
                profilecityLabel.text= [profileDetailsDictionary objectForKey:@"city"];
                
                profileSosContactNoLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"sos_contact_num"]];
                profileSosEmailLabel.text=  [profileDetailsDictionary objectForKey:@"sos_email_id"];
                profileRidePointBalanceLabel .text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"ride_point_balance"]];
                
                profileNoOfRidesLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"no_of_rides"]];
                profileApprovalStatusLabel.text =[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"approval_status"]];
                RideOption= [profileDetailsDictionary objectForKey:@"ride_option"];
                NSLog(@"OPtion %@",RideOption);
                if([[profileDetailsDictionary objectForKey:@"ride_option"] isEqualToString:@"G"])
                {
                    [rideOptionSegment setSelectedSegmentIndex:1];
                    profileCarModelLabel.text=  [profileDetailsDictionary objectForKey:@"car_model"];
                    profileCarBrandLabel.text=  [profileDetailsDictionary objectForKey:@"car_brand"];
                    profileSeatLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"number_of_seats"]];
                }
                else if([[profileDetailsDictionary objectForKey:@"ride_option"] isEqualToString:@"T"])
                {
                    [rideOptionSegment setSelectedSegmentIndex:0];
                    profileCarModelLabel.text= @"NA";
                    profileCarBrandLabel.text=   @"NA";
                    profileSeatLabel.text= @"NA";
                }
                else{
                    [rideOptionSegment setSelectedSegmentIndex:2];
                    profileCarModelLabel.text=  [profileDetailsDictionary objectForKey:@"car_model"];
                    profileCarBrandLabel.text=  [profileDetailsDictionary objectForKey:@"car_brand"];
                    profileSeatLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"number_of_seats"]];
                }
                
                [prefs setObject:[profileDetailsDictionary objectForKey:@"ride_option"] forKey:@"role"];
                profileCompanyNameLabel.text=[profileDetailsDictionary objectForKey:@"company_name"];
                [self hideLoadingMode];
                LoadingView.hidden=YES;
            
        }
        else{
             [self hideLoadingMode];
            [self ShowAlertView:UnableToProcess];
        }
        
        [editButton setEnabled:YES];
        [self hideLoadingMode];
        
        
        
        
        
        
        
        
        
        
        
        
     
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        [self hideLoadingMode];
        [InterfaceManager DisplayAlertWithMessage:@"Failed to profile details"];
        
    }];
    


}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}
-(void) setupUI
{
    self.navigationItem.title = @"Profile";
    [self.ageSlider setThumbImage:[UIImage imageNamed:@"ridewithme_mobile_slide.png"] forState:UIControlStateNormal];
     self.navigationItem.hidesBackButton = YES;
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditProfile:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
    [profileScrollView setScrollEnabled:YES];
    [profileScrollView setContentSize:CGSizeMake(320, 950)];
}
-(void)slider:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
-(void)EditProfile:(id)sender
{
    UpdateProfileViewController *updVC= [self.storyboard instantiateViewControllerWithIdentifier:@"editProfile"];
    updVC.profiledata=data;
    [self.navigationController pushViewController:updVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLoadingMode {
    if (!loadingCircle) {
        loadingCircle = [[MZLoadingCircle alloc]initWithNibName:nil bundle:nil];
        loadingCircle.view.backgroundColor = [UIColor clearColor];
        
        //Colors for layers
        loadingCircle.colorCustomLayer = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1];
        loadingCircle.colorCustomLayer2 = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:0.65];
        loadingCircle.colorCustomLayer3 = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:0.4];
        
        int size = 100;
        
        CGRect frame = loadingCircle.view.frame;
        frame.size.width = size ;
        frame.size.height = size;
        frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
        loadingCircle.view.frame = frame;
        loadingCircle.view.layer.zPosition = MAXFLOAT;
        [self.view addSubview: loadingCircle.view];
    }
}

-(void)hideLoadingMode {
    if (loadingCircle) {
        [loadingCircle.view removeFromSuperview];
        loadingCircle = nil;
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toEditProfile"])
    {
        UpdateProfileViewController *upVc = segue.destinationViewController;
        upVc.profiledata=data;
    }
   
    
}


@end
