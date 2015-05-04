//
//  RegistrationViewController.m
//  CarPooling
//
//  Created by atk's mac on 24/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()
{
    int genderFlag;
}
@end

@implementation RegistrationViewController
@synthesize mScrollView,mRegisterButton,mCancelButton,mAddressTextField,mRideOptionSegment,ageSlider,ageLabel;
@synthesize mCompanyTextField,mApprovalStatus,mUsername,mPassword,mConPassword,mPointsTextField,genderSwitch;
@synthesize mCarBrandTextField,mCarModelTextField,mCityTextField,mNameTextField;
@synthesize mNoOfRidesTextField,mNoOfSeatsTextField,mPhoneTextField,mSosEmailTextField,mSosPhoneTextField;
@synthesize UserName,Password,ConPassword,CarBrand,CarModel,City,CompanyName,SosEmail,SosPhone,Name;
@synthesize NoOfRides,NoOfSeats,Address,Age,ApprovalStatus,RidePoints,Phone,TopLayer,footerText;




- (void)viewDidLoad
{
    [super viewDidLoad];
    genderFlag=1;
    [self setupUI];
 }





//Ride Option segment action

- (IBAction)mRideOptionSelection:(id)sender {
    
    if (mRideOptionSegment.selectedSegmentIndex == 0)
    {
        RideOption=@"G";
        mCarModelTextField.userInteractionEnabled=YES;
        mCarBrandTextField.userInteractionEnabled=YES;
        mNoOfSeatsTextField.userInteractionEnabled=YES;
        mCarModelTextField.text=@"";
        mCarBrandTextField.text=@"";
         mNoOfSeatsTextField.text=@"";
    }
    else  if (mRideOptionSegment.selectedSegmentIndex == 1)
    {
        RideOption=@"T";
        mCarModelTextField.userInteractionEnabled=NO;
        mCarBrandTextField.userInteractionEnabled=NO;
        mNoOfSeatsTextField.userInteractionEnabled=NO;
        mCarModelTextField.text=@"NA";
        mCarBrandTextField.text=@"NA";
         mNoOfSeatsTextField.text=@"NA";
    }
    else{
        RideOption=@"B";
        mCarModelTextField.userInteractionEnabled=YES;
        mCarBrandTextField.userInteractionEnabled=YES;
        mNoOfSeatsTextField.userInteractionEnabled=YES;
        mCarModelTextField.text=@"";
        mCarBrandTextField.text=@"";
        mNoOfSeatsTextField.text=@"";
    }
}

//User Registration

- (IBAction)UserRegistration:(id)sender
{
    NSString *str = Gender;
    str = [str stringByAppendingString:@" +"];
    str = [str stringByAppendingString:RideOption];

    
    
    if ([mUsername.text isEqualToString:@""]) {
        
        [self ShowAlertView:@"User Name is empty"];
        [mUsername becomeFirstResponder];
        
    }
    else if ([mPassword.text isEqualToString:@""]){
        
        [self ShowAlertView:@"Password is empty"];
        [mPassword becomeFirstResponder];
        
    }
    else if ([mNameTextField.text isEqualToString:@""]){
        
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
            
            [self RegisterUser];
        }
        
        
        
        
        
        
    } else {
        
        [self RegisterUser];
    }
    
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



-(void)touch
{
    [self.view endEditing:YES];
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
    Age=ageLabel.text;
    Phone=mPhoneTextField.text;
    City=mCityTextField.text;
    Address=mAddressTextField.text;
    CarBrand=mCarBrandTextField.text;
    CarModel=mCarModelTextField.text;
    NoOfSeats=mNoOfSeatsTextField.text;
    SosEmail=mSosEmailTextField.text;
    SosPhone=mSosPhoneTextField.text;
    RidePoints=@"0";
    NoOfRides=@"0";
    ApprovalStatus=@"0";
    CompanyName=mCompanyTextField.text;
    
    if ([RideOption isEqualToString:@"T"]) {
        
        NoOfSeats = @"0";
    }
    
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
        [self.TopLayer setHidden:YES];
        [self ShowAlertView:[NSString stringWithFormat:@"Registration Failed:%@",[data objectForKey:@"message"] ] ];
    }
    }
    else{
        TopLayer.hidden=NO;
        [self hideLoadingMode];
        [self ShowAlertView:UnableToProcess];
       
    }
}
-(void) setupUI
{
    //Scrolling Enabled
     UIColor *placeholder =[UIColor colorWithRed:0.87 green:0.69 blue:0.09 alpha:1];
    
    [ageSlider setThumbImage:[UIImage imageNamed:@"ridewithme_mobile_slide.png"] forState:UIControlStateNormal];
    
    UIColor * Cgrey1 =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    
    self.view.backgroundColor=Cgrey1;
    
   //  [self.view insertSubview:footerText atIndex:1];
    TopLayer.hidden=YES;
    
    [mScrollView setScrollEnabled:YES];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
       [mScrollView setContentSize:CGSizeMake(768, 1110)];
        
    } else {
        
       [mScrollView setContentSize:CGSizeMake(320, 1110)];
        
    }

       UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    
    [recognizer setNumberOfTapsRequired:1];
    
    [recognizer setNumberOfTouchesRequired:1];
    
    [mScrollView addGestureRecognizer:recognizer];
    
    UIColor * yellow =[UIColor colorWithRed:237.0f/255.0f green:181.0f/255.0f blue:0.0f/255.0f alpha:1];
    
    mCancelButton.backgroundColor=yellow;
    
    mCancelButton.layer.cornerRadius=5;
    
    mAddressTextField.layer.cornerRadius=5;
   
    [mUsername setValue:placeholder
                    forKeyPath:@"_placeholderLabel.textColor"];
    [mPassword setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mNameTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mCityTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mPhoneTextField setValue:placeholder
                   forKeyPath:@"_placeholderLabel.textColor"];
    [mCarModelTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mCarBrandTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mNoOfRidesTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mAddressTextField setValue:placeholder
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
    
     mUsername.delegate=self;
    mPassword.delegate=self;
    mConPassword.delegate=self;
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



- (IBAction)ageValueChanged:(id)sender {
    
    int result = (int)ceilf(ageSlider.value);
    ageLabel.text = [NSString stringWithFormat:@"%i", result];
    
}

- (IBAction)genderValueChanged:(id)sender {
    
    if(genderFlag==1)
    {
        Gender=@"Male";
        NSLog(@"%@", Gender);
        genderFlag=0;
        UIImage *male=[UIImage imageNamed:@"ridewithme_mobile_gendermale.png"];
        [genderSwitch setImage:male forState:UIControlStateNormal];
    }
    else if(genderFlag==0){
       
        Gender=@"FeMale";
            NSLog(@"%@", Gender);
        genderFlag=1;
        UIImage *female=[UIImage imageNamed:@"ridewithme_mobile_genderfemale.png"];
        [genderSwitch setImage:female forState:UIControlStateNormal];
    }
    
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
