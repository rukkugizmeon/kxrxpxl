//
//  UpdateProfileViewController.m
//  CarPooling
//
//  Created by atk's mac on 08/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "InterfaceManager.h"

@interface UpdateProfileViewController ()
{
    int genderFlag;
}
@end

@implementation UpdateProfileViewController
@synthesize mScrollView,mUpdateButton,mCanceButton,mAddressTextField,mGenderSegment,mRideOptionSegment,genderSwitch;
@synthesize mCompanyTextField,mApprovalStatus,mPointsTextField,ageSlider,ageLabel;
@synthesize mCarBrandTextField,mCarModelTextField,mCityTextField,mNameTextField;
@synthesize mNoOfRidesTextField,mNoOfSeatsTextField,mPhoneTextField,mSosEmailTextField,mSosPhoneTextField;
@synthesize UserName,Password,ConPassword,CarBrand,CarModel,City,CompanyName,SosEmail,SosPhone,Name;
@synthesize NoOfRides,NoOfSeats,Address,Age,ApprovalStatus,RidePoints,Phone,Gender,RideOption;
NSUserDefaults *prefs;



- (void)viewDidLoad
{
     //self.navigationItem.hidesBackButton = YES;
    UIColor * Cgrey1 =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    self.view.backgroundColor=Cgrey1;
    [ageSlider setThumbImage:[UIImage imageNamed:@"ridewithme_mobile_slide.png"] forState:UIControlStateNormal];
    [super viewDidLoad];
    UserName=[prefs stringForKey:@"username"];
    Password=[prefs stringForKey:@"password"];
    NSLog(@"Data%@",UserName);
     NSLog(@"Data%@",Password);
    [self fetchedProfileData:self.profiledata];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [mScrollView addGestureRecognizer:recognizer];
        [self setupUI];
}
-(void)touch
{ [self.view endEditing:YES];
}
//Gender segment action



//Ride Option segment action

- (IBAction)mRideOptionsSelection:(id)sender {
    if (mRideOptionSegment.selectedSegmentIndex == 0)
    {
        RideOption=@"G";
        mCarModelTextField.userInteractionEnabled=YES;
        mCarBrandTextField.userInteractionEnabled=YES;
        mNoOfSeatsTextField.userInteractionEnabled=YES;
        mCarModelTextField.text= @"";
        mCarBrandTextField.text=   @"";
        mNoOfSeatsTextField.text= @"";
    }
    else  if (mRideOptionSegment.selectedSegmentIndex == 1)
    {
        RideOption=@"T";
        mCarModelTextField.userInteractionEnabled=NO;
        mCarBrandTextField.userInteractionEnabled=NO;
        mNoOfSeatsTextField.userInteractionEnabled=NO;
    }
    else{
        RideOption=@"B";
        mCarModelTextField.userInteractionEnabled=YES;
        mCarBrandTextField.userInteractionEnabled=YES;
        mNoOfSeatsTextField.userInteractionEnabled=YES;
        mCarModelTextField.text= @"";
        mCarBrandTextField.text=   @"";
        mNoOfSeatsTextField.text= @"";
    }
}

- (IBAction)UpdateProfile:(id)sender {
    
   
    if ([mNameTextField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"Name is empty"];
        [mNameTextField becomeFirstResponder];
        
    }else if (![self validPhoneNumber:mPhoneTextField.text]){
        
        [self ShowAlertView:@"Invalid Mobile Number"];
        [mPhoneTextField becomeFirstResponder];
        
    }else if ([mAddressTextField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"Address is empty"];
        [mAddressTextField becomeFirstResponder];
        
    }else if ([mCityTextField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"City is empty"];
        [mCityTextField becomeFirstResponder];
        
    }
    else if (![self validEmail:mSosEmailTextField.text]) {
        
        [self ShowAlertView:@"Invalid email"];
        [mSosEmailTextField becomeFirstResponder];
        
        
    }else if ( ![self validPhoneNumber:mSosPhoneTextField.text]) {
        
        [self ShowAlertView:@"Invalid Phone Number"];
        [mSosEmailTextField becomeFirstResponder];
        
        
    } else if ([mCompanyTextField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"Company Field is Empty"];
        [mCompanyTextField becomeFirstResponder];
        
        
    } else if (![RideOption isEqualToString:@"T"]){
        
        if ([mCarModelTextField.text isEqualToString:@""]) {
            
            [self ShowAlertView:@"Car Model is empty"];
            [mCarModelTextField becomeFirstResponder];
            
        }else if ([mCarBrandTextField.text isEqualToString:@""]){
            
            [self ShowAlertView:@"Car Brand is empty"];
            [mCarBrandTextField becomeFirstResponder];
            
        }else if ([mNoOfSeatsTextField.text isEqualToString:@""]){
            
            [self ShowAlertView:@"Number of Seats is empty"];
            [mNoOfSeatsTextField becomeFirstResponder];
            
            
            
            
        }  else {
            
            [self UpdateUser];
        }
        
        
        
        
        
        
    } else {
        
        [self UpdateUser];
    }
    
    
    
    
    
    
    
    
    
}
- (IBAction)cncelUpdate:(id)sender {
    [self performSegueWithIdentifier:@"backFromUpdateCancel" sender:nil];
}

- (void)fetchedProfileData:( NSDictionary *)data {
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    NSDictionary *profileDetailsDictionary=[data objectForKey:@"0"];
    
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSLog(@"Data %@",result);
    if(!jsonParsingError && profileDetailsDictionary!=nil)
    {
        if([result isEqualToString:@"1"])
        {
            
           mNameTextField.text=[profileDetailsDictionary objectForKey:@"name"];
           ageLabel.text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"age"]];
            NSString *myAge=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"age"]];
            float age=[myAge floatValue];
            [ageSlider setValue:age];
           Gender=[profileDetailsDictionary objectForKey:@"gender"];
             NSLog(@"Gender%@",Gender);
            if([Gender isEqualToString:@"Male"] || [Gender isEqualToString:@"male"] || [Gender isEqualToString:@"M"] || [Gender isEqualToString:@"m"])
            {
                    genderFlag=0;
              Gender=@"Male";
                UIImage *male=[UIImage imageNamed:@"ridewithme_mobile_gendermale.png"];
                [genderSwitch setImage:male forState:UIControlStateNormal];
            }
            else{
                Gender=@"FeMale";         
                    genderFlag=1;
                UIImage *female=[UIImage imageNamed:@"ridewithme_mobile_genderfemale.png"];
                [genderSwitch setImage:female forState:UIControlStateNormal];
            }
            
          mPhoneTextField.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"mobile_number"]];
            mAddressTextField.text= [profileDetailsDictionary objectForKey:@"address"];
           mCityTextField.text= [profileDetailsDictionary objectForKey:@"city"];
           mCarModelTextField.text=  [profileDetailsDictionary objectForKey:@"car_model"];
          mCarBrandTextField.text=  [profileDetailsDictionary objectForKey:@"car_brand"];
           mNoOfSeatsTextField.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"number_of_seats"]];
           mSosPhoneTextField.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"sos_contact_num"]];
           mSosEmailTextField.text=  [profileDetailsDictionary objectForKey:@"sos_email_id"];
            
            if ([[profileDetailsDictionary objectForKey:@"ride_point_balance"] isKindOfClass:[NSNull class]]) {
                
                mPointsTextField.text = @"0";
                
            }else{
                
           mPointsTextField .text=[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"ride_point_balance"]];
                
            }
            
            if ([[profileDetailsDictionary objectForKey:@"no_of_rides"] isKindOfClass:[NSNull class]]) {
                
                mNoOfRidesTextField.text = @"0";
                
            }else{
                
            mNoOfRidesTextField.text= [NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"no_of_rides"]];
            }
            
            mApprovalStatus.text =[NSString stringWithFormat:@"%@",[profileDetailsDictionary objectForKey:@"approval_status"]];
            RideOption= [profileDetailsDictionary objectForKey:@"ride_option"];
                NSLog(@"Rideoption%@",RideOption);
            if([RideOption isEqualToString:@"G"])
            {
            [mRideOptionSegment setSelectedSegmentIndex:0];
            }
            else if ([RideOption isEqualToString:@"T"])
            {
                mCarModelTextField.text= @"NA";
                mCarBrandTextField.text=   @"NA";
              mNoOfSeatsTextField.text= @"NA";
                mCarModelTextField.userInteractionEnabled=NO;
            mCarBrandTextField.userInteractionEnabled=NO;
             mNoOfSeatsTextField.userInteractionEnabled=NO;
            
            [mRideOptionSegment setSelectedSegmentIndex:1];
            }
            else{
                [mRideOptionSegment setSelectedSegmentIndex:2];
            }
            mCompanyTextField.text=[profileDetailsDictionary objectForKey:@"company_name"];
            [self hideLoadingMode];
          //  LoadingView.hidden=YES;
        }
        else{
            [self hideLoadingMode];
            
            [self ShowAlertView:@"Invalid Response"];
        }
    }
    else{
        [self hideLoadingMode];
        [self ShowAlertView:@"Unable to process request"];
    }
}


-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
     [Alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [mNameTextField resignFirstResponder];
    [mPhoneTextField resignFirstResponder];
    [mCityTextField resignFirstResponder];
    [mCarModelTextField resignFirstResponder];
    [mCarBrandTextField resignFirstResponder];
    [mNoOfRidesTextField resignFirstResponder];
    [mNoOfSeatsTextField resignFirstResponder];
    [mSosEmailTextField resignFirstResponder];
    [mSosPhoneTextField resignFirstResponder];
    [mPointsTextField resignFirstResponder];
    [mCompanyTextField resignFirstResponder];
    [mApprovalStatus resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==mApprovalStatus)
    {
        [textField resignFirstResponder];
        [mCompanyTextField becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==mCompanyTextField || textField==mApprovalStatus)
    {
        [self animateTextField: textField up: YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==mCompanyTextField || textField==mApprovalStatus)
    {
        [self animateTextField: textField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 135; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void) UpdateUser{
    NSLog(@"Updation Started");
   // TopLayer.hidden=NO;
    [self showLoadingMode];
    Name=mNameTextField.text;
    Age=ageLabel.text;
    Phone=mPhoneTextField.text;
    City=mCityTextField.text;
    Address=mAddressTextField.text;
    CarBrand=mCarBrandTextField.text;
    CarModel=mCarModelTextField.text;
    NoOfSeats=mNoOfSeatsTextField.text;
    SosEmail=mSosEmailTextField.text;
    SosPhone=mSosPhoneTextField.text;
    RidePoints=mPointsTextField.text;
    NoOfRides=mNoOfRidesTextField.text;
    ApprovalStatus=mApprovalStatus.text;
    CompanyName=mCompanyTextField.text;
    if([NoOfSeats isEqualToString:@""] || [NoOfSeats isEqualToString:@"NA"])
        NoOfSeats=@"0";
    
    
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *id=[prefs stringForKey:@"id"];
    UserName=[prefs stringForKey:@"username"];
    Password=[prefs stringForKey:@"password"];
    NSLog(@" id %@",id);
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@&username=%@&password=%@&name=%@&age=%@&gender=%@&mobile_number=%@&address=%@&city=%@&car_model=%@&car_brand=%@&number_of_seats=%@&sos_contact_num=%@&sos_email_id=%@&ride_point_balance=%@&no_of_rides=%@&ride_option=%@&approval_status=%@&company_name=%@",id,UserName,Password,Name,Age,Gender,Phone,Address,City,CarModel,CarBrand,NoOfSeats,SosPhone,SosEmail,RidePoints,NoOfRides,RideOption,ApprovalStatus,CompanyName];
 
    
    //NSString * PostString = [NSString stringWithFormat:@"user_id=%@",id];
    
    
    
   BinSystemsServerConnectionHandler  *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_UpdateProfile PostData:PostString];
    
    
    
    
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        if(data!=nil)
        {
            NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
            
            NSLog(@"Data %@",result);
            if([result isEqualToString:@"1"])
            {
                [self hideLoadingMode];
                [self ShowAlertView:@"Successfully updated!!"];
                ProfileViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
                
                
                [self.navigationController pushViewController:VC animated:YES];
                //   [self performSegueWithIdentifier:@"backFromUpdateCancel" sender:nil];
                
            }
            else if([result isEqualToString:@"0"]){
                [self hideLoadingMode];
                [self ShowAlertView:@"Updation Failed!!"];
            }
        }
        else{
            [self hideLoadingMode];
           
           
        }
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
        
        
        
        
    }];
    
    
    
}

-(void) setupUI
{
    //Scrolling Enabled
   // TopLayer.hidden=YES;
    UIColor *placeholder =[UIColor colorWithRed:0.87 green:0.69 blue:0.09 alpha:1];
    
    [mScrollView setScrollEnabled:YES];
    [mScrollView setContentSize:CGSizeMake(320, 1021)];
    mUpdateButton.layer.cornerRadius=5;
    mCanceButton.layer.cornerRadius=5;
    mAddressTextField.layer.cornerRadius=5;
    [mNameTextField setValue:placeholder
                  forKeyPath:@"_placeholderLabel.textColor"];
    [mPhoneTextField setValue:placeholder
                     forKeyPath:@"_placeholderLabel.textColor"];
    [mCityTextField setValue:placeholder
                  forKeyPath:@"_placeholderLabel.textColor"];
    [mCarModelTextField setValue:placeholder
                      forKeyPath:@"_placeholderLabel.textColor"];
    [mCarBrandTextField setValue:placeholder
                      forKeyPath:@"_placeholderLabel.textColor"];
    [mNoOfRidesTextField setValue:placeholder
                       forKeyPath:@"_placeholderLabel.textColor"];
    [mNoOfSeatsTextField setValue:placeholder
                       forKeyPath:@"_placeholderLabel.textColor"];
    [mSosEmailTextField setValue:placeholder
                      forKeyPath:@"_placeholderLabel.textColor"];
    [mSosPhoneTextField setValue:placeholder
                      forKeyPath:@"_placeholderLabel.textColor"];
    [mPointsTextField setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    [mApprovalStatus setValue:placeholder
                   forKeyPath:@"_placeholderLabel.textColor"];
    [mCompanyTextField setValue:placeholder
                     forKeyPath:@"_placeholderLabel.textColor"];
    
    mNameTextField.delegate=self;
    mPhoneTextField.delegate=self;
    mCityTextField.delegate=self;
    mCarModelTextField.delegate=self;
    mCarBrandTextField.delegate=self;
    mNoOfRidesTextField.delegate=self;
    mNoOfSeatsTextField.delegate=self;
    mSosEmailTextField.delegate=self;
    mSosPhoneTextField.delegate=self;
    mPointsTextField.delegate=self;
    mCompanyTextField.delegate=self;
    mApprovalStatus.delegate=self;
    
    //Gender=@"Male";
    //RideOption=@"G";
    
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

- (IBAction)genderChanged:(id)sender {
    
        if(genderFlag==1)
        {
                  Gender=@"Male";
        genderFlag=0;
        UIImage *male=[UIImage imageNamed:@"ridewithme_mobile_gendermale.png"];
        [genderSwitch setImage:male forState:UIControlStateNormal];
    }
    else if(genderFlag==0){
              Gender=@"FeMale";
        genderFlag=1;
        UIImage *female=[UIImage imageNamed:@"ridewithme_mobile_genderfemale.png"];
        [genderSwitch setImage:female forState:UIControlStateNormal];
    }
}

- (IBAction)ageValueChanged:(id)sender {
    int result = (int)ceilf(ageSlider.value);
     ageLabel.text = [NSString stringWithFormat:@"%i", result];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)datas
{
    NSLog(@"Some Data is recieving");
}

#pragma Mark Email and Phone Number Validation

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
    
}

- (BOOL)validPhoneNumber:(NSString*)number
{
    
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
    
}


@end
