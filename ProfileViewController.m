//
//  ProfileViewController.m
//  CarPooling
//
//  Created by shebin on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "ProfileViewController.h"

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
@synthesize profileRideOptionsLabel;
@synthesize profileSeatLabel;
@synthesize profileSexLabel;
@synthesize profileRidePointBalanceLabel;
@synthesize profileSosContactNoLabel;
@synthesize profileSosEmailLabel,LoadingView;
NSDictionary *data ;
NSUserDefaults *prefs;
NSString *RideOption;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self webconnection];
    [self setupUI];
    // Do any additional setup after loading the view.
}
-(void)webconnection
{
    [self showLoadingMode];
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *id=[prefs stringForKey:@"id"];
    NSLog(@" id %@",id);
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@",id];
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_ProfileView]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        
    });

}
- (void)fetchedData:(NSData *)responseData {
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSDictionary *profileDetailsDictionary=[data objectForKey:@"0"];
   
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSLog(@"Data %@",result);
    if(!jsonParsingError && profileDetailsDictionary!=nil)
    {
    if([result isEqualToString:@"1"])
    {
 
   profileNameLabel.text=[profileDetailsDictionary objectForKey:@"name"];
  profileAgeLabel.text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"age"]];
   profileSexLabel.text=[profileDetailsDictionary objectForKey:@"gender"];
   profileMobileLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"mobile_number"]];
   profileAddressLabel.text= [profileDetailsDictionary objectForKey:@"address"];
   profilecityLabel.text= [profileDetailsDictionary objectForKey:@"city"];
  profileCarModelLabel.text=  [profileDetailsDictionary objectForKey:@"car_model"];
  profileCarBrandLabel.text=  [profileDetailsDictionary objectForKey:@"car_brand"];
   profileSeatLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"number_of_seats"]];
  profileSosContactNoLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"sos_contact_num"]];
 profileSosEmailLabel.text=  [profileDetailsDictionary objectForKey:@"sos_email_id"];
profileRidePointBalanceLabel .text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"ride_point_balance"]];
   
  profileNoOfRidesLabel.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"no_of_rides"]];
 profileApprovalStatusLabel.text =[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"approval_status"]];
        RideOption= [profileDetailsDictionary objectForKey:@"ride_option"];
  profileRideOptionsLabel.text=  [profileDetailsDictionary objectForKey:@"ride_option"];
    profileCompanyNameLabel.text=[profileDetailsDictionary objectForKey:@"company_name"];
           [self hideLoadingMode];
        LoadingView.hidden=YES;
    }
    else{
        [self hideLoadingMode];
        
        [self ShowAlertView:@"Invalid Response"];
    }
    }
    else{
        [self hideLoadingMode];
        [self ShowAlertView:UnableToProcess];
    }
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}
-(void) setupUI
{
    [profileScrollView setScrollEnabled:YES];
    [profileScrollView setContentSize:CGSizeMake(320, 800)];
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
    if([segue.identifier isEqualToString:@"toMenuFromProfile"])
    {
        MenuViewController *menVC = segue.destinationViewController;
        menVC.options=RideOption;
    }
    
}


@end
