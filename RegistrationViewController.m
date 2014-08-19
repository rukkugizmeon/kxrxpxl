//
//  RegistrationViewController.m
//  CarPooling
//
//  Created by atk's mac on 24/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize mScrollView,mRegisterButton,mCancelButton,mAddressTextField,mGenderSegment,mRideOptionSegment;
@synthesize mCompanyTextField,mApprovalStatus,mUsername,mPassword,mConPassword,mPointsTextField;
@synthesize mAgeTextField,mCarBrandTextField,mCarModelTextField,mCityTextField,mNameTextField;
@synthesize mNoOfRidesTextField,mNoOfSeatsTextField,mPhoneTextField,mSosEmailTextField,mSosPhoneTextField;
@synthesize UserName,Password,ConPassword,CarBrand,CarModel,City,CompanyName,SosEmail,SosPhone,Name;
@synthesize NoOfRides,NoOfSeats,Address,Age,ApprovalStatus,RidePoints,Phone,TopLayer;




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
 }

//Gender segment action

- (IBAction)mGenderSelection:(id)sender {
     if (mGenderSegment.selectedSegmentIndex == 0)
     {
         Gender=@"Male";
     }
     else{
      Gender=@"Female";
     }
}


//Ride Option segment action

- (IBAction)mRideOptionSelection:(id)sender {
    
    if (mRideOptionSegment.selectedSegmentIndex == 0)
    {
        RideOption=@"G";
    }
    else  if (mRideOptionSegment.selectedSegmentIndex == 1)
    {
        RideOption=@"T";
    }
    else{
        RideOption=@"B";
    }
}

//User Registration

- (IBAction)UserRegistration:(id)sender
{
    NSString *str = Gender;
    str = [str stringByAppendingString:@" +"];
    str = [str stringByAppendingString:RideOption];

    [self ShowAlertView:str];
    
    [self RegisterUser];

}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
   // [Alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [mUsername resignFirstResponder];
    [mPassword resignFirstResponder];
    [mConPassword resignFirstResponder];
    [mNameTextField resignFirstResponder];
    [mAgeTextField resignFirstResponder];
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

-(void) RegisterUser{
     NSLog(@"Registration Started");
    TopLayer.hidden=NO;
    [self showLoadingMode];
    UserName= mUsername.text;
    Password= mPassword.text;
    Name=mNameTextField.text;
    ConPassword=mConPassword.text;
    Age=mAgeTextField.text;
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
    
    NSString * PostString = [NSString stringWithFormat:@"username=%@&password=%@&name=%@&age=%@&gender=%@&mobile_number=%@&address=%@&city=%@&car_model=%@&car_brand=%@&number_of_seats=%@&sos_contact_num=%@&sos_email_id=%@&ride_point_balance=%@&no_of_rides=%@&ride_option=%@&approval_status=%@&company_name=%@",UserName,Password,Name,Age,Gender,Phone,Address,City,CarModel,CarBrand,NoOfSeats,SosPhone,SosEmail,RidePoints,NoOfRides,RideOption,ApprovalStatus,CompanyName];
    NSLog(@"postString %@",PostString);
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_Registration]];
    
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
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    if(!jsonParsingError && data!=nil)
    {
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    
      NSLog(@"Data %@",result);
    if([result isEqualToString:@"1"])
    {
        [self hideLoadingMode];
        TopLayer.hidden=NO;
        [self ShowAlertView:@"Registration Successfull!!"];
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
        
    }
    else if([result isEqualToString:@"0"]){
        TopLayer.hidden=NO;
        [self hideLoadingMode];
        [self ShowAlertView:@"Registration Failed!!"];
    }
    }
    else{
        TopLayer.hidden=NO;
        [self hideLoadingMode];
        [self ShowAlertView:@"Unable to process the request"];
    }
}
-(void) setupUI
{
    //Scrolling Enabled
    TopLayer.hidden=YES;
    [mScrollView setScrollEnabled:YES];
    [mScrollView setContentSize:CGSizeMake(320, 1200)];
    mRegisterButton.layer.cornerRadius=5;
    mCancelButton.layer.cornerRadius=5;
    mAddressTextField.layer.cornerRadius=5;
    mUsername.delegate=self;
    mPassword.delegate=self;
    mConPassword.delegate=self;
    mNameTextField.delegate=self;
    mAgeTextField.delegate=self;
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
    Gender=@"Male";
    RideOption=@"G";

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

@end
