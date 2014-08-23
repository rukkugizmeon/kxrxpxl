//
//  LoginViewController.m
//  CarPooling
//
//  Created by atk's mac on 23/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize mLoginButton,mPasswordTextField,mUserNameTextField,mRegisterButton;
@synthesize AuthPassword,AuthUsername,mSpinner,myView;
NSMutableData *mutableData;
NSUserDefaults *prefs ;
NSString *isLoggedIn;
NSString *rideOptions;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    prefs= [NSUserDefaults standardUserDefaults];
    isLoggedIn=[prefs stringForKey:@"isLogged"];
    NSLog(@"result%@",isLoggedIn);
    if([isLoggedIn isEqualToString:@"true"] && isLoggedIn!=nil)
    {
        mUserNameTextField.hidden=YES;
        mPasswordTextField.hidden=YES;
        mLoginButton.hidden=YES;
        mRegisterButton.hidden=YES;
        // myView.hidden=YES;
        //[self performSegueWithIdentifier:@"toMenuView" sender:nil];
        [self AuthenticateUserLoginWithServer];
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if([isLoggedIn isEqualToString:@"true"] && isLoggedIn!=nil)
    {   [self AuthenticateUserLoginWithServer];
    }
}

- (void)viewDidLoad
{
    
    mUserNameTextField.delegate=self;
    mPasswordTextField.delegate=self;
    mLoginButton.layer.cornerRadius=5;
    mRegisterButton.layer.cornerRadius=5;
    [self setMSpinner:nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    if(mUserNameTextField.hasText && mPasswordTextField.hasText)
    {
      
    [self AuthenticateUserLoginWithServer];
    }
    else{
        [self ShowAlertView:@"Please fill all the fields"];
    }
    [mPasswordTextField resignFirstResponder];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:mUserNameTextField])
    {
        [mUserNameTextField resignFirstResponder];
        [mPasswordTextField becomeFirstResponder];
    }
    else if([textField isEqual:mPasswordTextField]){
        if(mUserNameTextField.hasText && mPasswordTextField.hasText)
        {
            
            [self AuthenticateUserLoginWithServer];
        }
        else{
            [self ShowAlertView:@"Please fill all the fields"];
        }

    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [mUserNameTextField resignFirstResponder];
     [mPasswordTextField resignFirstResponder];
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

-(void)AuthenticationFailed{
    
    [[self mUserNameTextField] setText:nil];
    [[self mPasswordTextField] setText:nil];
}



-(void)AuthenticateUserLoginWithServer{
    
    
    if([isLoggedIn isEqualToString:@"true"])
    {
        [self showLoadingMode];
     self.AuthUsername= [prefs stringForKey:@"username"];
     self.AuthPassword =[prefs stringForKey:@"password"];
    }
    else{
        myView.hidden=YES;
    self.AuthUsername = mUserNameTextField.text;
    self.AuthPassword = mPasswordTextField.text;}
    NSLog(@"Authentication Login With Server Started");
     NSLog(@"{");
    
    NSString * PostString = [NSString stringWithFormat:@"username=%@&password=%@",AuthUsername,AuthPassword];
    NSLog(@"Url %@",kServerLink_UserAuthenticationLink);
    NSLog(@"postString %@",PostString);
    NSLog(@"}");
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_UserAuthenticationLink]];
   
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
  
        dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
            if(!err){
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
            }
            else{
                myView.hidden=NO;
                [self showUIControls];
                [self ShowAlertView:@"Unable to Login.Please Login again!"];
            }
        
    });
    
       
    
}

- (void)fetchedData:(NSData *)responseData {
 
    NSString *ids;
    NSString *password;
    NSString *username;
    NSString *rideOption;
    
    NSError *jsonParsingError;
     NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0 error:&jsonParsingError];
 NSLog(@"Response %@",data);
    NSString *result=[data objectForKey:@"result"];
     //[self ShowAlertView:result];
    
    if([result isEqualToString:@"success"])
    {
        [self hideLoadingMode];
        myView.hidden=NO;
         ids=[data objectForKey:@"userID"];
         rideOption=[data objectForKey:@"rideOption"];
        rideOptions=[data objectForKey:@"rideOption"];
         password=[data objectForKey:@"password"];
        username=[data objectForKey:@"username"];
         username = [username stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        if([isLoggedIn isEqualToString:@"false"] || isLoggedIn==nil)
        {
             NSLog(@"Preference nil%@%@%@",ids,username,password);
        [prefs setObject:@"true" forKey:@"isLogged"];
        [prefs setObject:ids forKey:@"id"];
        [prefs setObject:username forKey:@"username"];
        [prefs setObject:password forKey:@"password"];
        [prefs setObject:rideOption forKey:@"role"];
        }
        [self performSegueWithIdentifier:@"toMenuView" sender:nil];
        //  [self ShowAlertView:result];
    }
    else if([result isEqualToString:@"Invalid"]){
        [prefs setObject:@"false" forKey:@"isLogged"];
        [self hideLoadingMode];
        myView.hidden=NO;
        [prefs removeObjectForKey:@"id"];
        [prefs removeObjectForKey:@"isLogged"];
        [prefs removeObjectForKey:@"username"];
        [prefs removeObjectForKey:@"password"];
        [prefs removeObjectForKey:@"role"];
        [prefs synchronize];
        mUserNameTextField.hidden=NO;
        mPasswordTextField.hidden=NO;
        mLoginButton.hidden=NO;
        mRegisterButton.hidden=NO;
         [self ShowAlertView:result];
    }
   
}
-(void)showUIControls{
    [prefs setObject:@"false" forKey:@"isLogged"];
    [self hideLoadingMode];
    myView.hidden=NO;
    [prefs removeObjectForKey:@"id"];
    [prefs removeObjectForKey:@"isLogged"];
    [prefs removeObjectForKey:@"username"];
    [prefs removeObjectForKey:@"password"];
    [prefs removeObjectForKey:@"role"];
    [prefs synchronize];
    mUserNameTextField.hidden=NO;
    mPasswordTextField.hidden=NO;
    mLoginButton.hidden=NO;
    mRegisterButton.hidden=NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMenuView"])
    {
        MenuViewController *menVC = segue.destinationViewController;
        menVC.options=rideOptions;
    }
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
