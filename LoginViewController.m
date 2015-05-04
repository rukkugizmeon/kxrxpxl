//
//  LoginViewController.m
//  CarPooling
//
//  Created by atk's mac on 23/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "LoginViewController.h"
#import "BinSystemsServerConnectionHandler.h"
#import "InterfaceManager.h"
@interface LoginViewController ()
{
    NSArray *optionArray;
      UIAlertView *alrtLogin,*alertPleaseWait;
    
}
@end

@implementation LoginViewController
@synthesize mLoginButton,mPasswordTextField,mUserNameTextField,mRegisterButton;
@synthesize AuthPassword,AuthUsername,mSpinner,myView,appLogo,bothContainer;
NSMutableData *mutableData;
NSUserDefaults *prefs ;
NSString *isLoggedIn;
NSString *rideOptions;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  bothContainer.hidden=YES;
    prefs= [NSUserDefaults standardUserDefaults];
    isLoggedIn=[prefs stringForKey:@"isLogged"];
    NSLog(@"result%@",isLoggedIn);
    if([isLoggedIn isEqualToString:@"true"] && ![isLoggedIn isKindOfClass:[NSNull class]] )
    {
     
        alrtLogin = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"Auto Login, Please Wait" delegate:self cancelButtonTitle:NULL otherButtonTitles:NULL, nil];
        
        [alrtLogin show];
         rideOptions=[prefs valueForKey:@"role"];
        
        
        [self AuthenticateUserLoginWithServer];
        // [self performSegueWithIdentifier:@"toHome" sender:nil];
        mUserNameTextField.hidden=YES;
        mPasswordTextField.hidden=YES;
        mLoginButton.hidden=YES;
        mRegisterButton.hidden=YES;
           }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [self dismiss:alrtLogin];
    
}
-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)viewDidLoad
{
    
    
    
    bothContainer.hidden=YES;
    UIColor * Cgrey1 =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    bothContainer.backgroundColor=Cgrey1;
    // sideBar=[[CDSideBarController alloc]hideButton];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
  //  [self.navigationController setNavigationBarHidden:YES animated:YES];
     UIColor *placeholder =[UIColor colorWithRed:230.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
    [mUserNameTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mPasswordTextField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    self.view.backgroundColor=Cgrey1;
    
    mUserNameTextField.delegate=self;
    mPasswordTextField.delegate=self;
    //mLoginButton.layer.cornerRadius=5;
    mRegisterButton.layer.cornerRadius=5;
     UIColor * Cgrey =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:0.5f];
    appLogo.layer.masksToBounds=YES;
    appLogo.layer.cornerRadius=50;
    appLogo.layer.borderColor = Cgrey.CGColor;
    appLogo.layer.borderWidth = 5.0f;
    [self setMSpinner:nil];
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
        NSLog(@"Login click");
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

-(void)ShowSelectionAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Take A Ride" otherButtonTitles:@"Give A Ride",nil];
    [Alert show];
}



-(void)AuthenticationFailed{
    
  //  [[self mUserNameTextField] setText:nil];
    [[self mPasswordTextField] setText:nil];
}



-(void)AuthenticateUserLoginWithServer{
    
    
    alertPleaseWait =[[UIAlertView alloc]initWithTitle:kApplicationName message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    
    if([isLoggedIn isEqualToString:@"true"])
    {
      
     self.AuthUsername= [prefs stringForKey:@"username"];
     self.AuthPassword =[prefs stringForKey:@"password"];
    }
    else{
        
        [alertPleaseWait show];
        
        myView.hidden=YES;
    self.AuthUsername = mUserNameTextField.text;
    self.AuthPassword = mPasswordTextField.text;
    
    }
    NSLog(@"Authentication Login With Server Started");
     NSLog(@"\n{");
    
    
        NSString * PostString = [NSString stringWithFormat:@"username=%@&password=%@",AuthUsername,AuthPassword];


    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_UserAuthenticationLink PostData:PostString];
    
        //specify the request method in first argument
        [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        NSDictionary *data = JSONDict;
        
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
        
        NSString *ids;
        NSString *password;
        NSString *username;
        NSString *rideOption;
        NSString *company;
        
        NSString *result=[data objectForKey:@"result"];
        
        
        if([result isEqualToString:@"success"])
        {
            
            myView.hidden=NO;
            ids=[data objectForKey:@"userID"];
            rideOption=[data objectForKey:@"rideOption"];
            rideOptions=[data objectForKey:@"rideOption"];
            password=[data objectForKey:@"password"];
            username=[data objectForKey:@"username"];
            company=[data objectForKey:@"company"];
            username = [username stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
            if([isLoggedIn isEqualToString:@"false"] || isLoggedIn==nil)
            {
                NSLog(@"Preference %@%@%@%@",ids,username,password,rideOptions);
                [prefs setObject:@"true" forKey:@"isLogged"];
                [prefs setObject:ids forKey:@"id"];
                
                [prefs setObject:[data objectForKey:@"name"] forKey:@"name"];
                
                [prefs setObject:username forKey:@"username"];
                [prefs setObject:password forKey:@"password"];
                [prefs setObject:rideOptions forKey:@"role"];
                [prefs setObject:company forKey:@"company"];
                [prefs synchronize];
                
                
                
            }
            NSString *type=[prefs valueForKey:@"role"];
            NSLog(@"Roles%@",type);
            if([type isEqualToString:@"B"])
            {  bothContainer.hidden=NO;
                            }
            else
            {
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *userid = [defaults objectForKey:@"id"];
                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                
                NSString *devToken = [defaults1 objectForKey:@"token"];

                
                    NSString * PostString = [NSString stringWithFormat:@"userId=%@&token=%@",userid,devToken];
                
                
                    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_saveDevicetoken PostData:PostString];
                
                    //specify the request method in first argument
                    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
                
                
                        NSDictionary *data = JSONDict;
                
                
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PostString message:[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                
                
                
//                        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
//                
//                        NSLog(@"%@",result);
//                        if([result isEqualToString:@"success"])
//                        {
//                
//                                      //  [self ShowAlertView:result];
//                        }
//                        else{
//                            
//                        }
                        
                        [WTStatusBar setLoading:NO loadAnimated:NO];
                        
                        [WTStatusBar clearStatus];
                        
                        
                        
                        
                        
                        
                        
                    } FailBlock:^(NSString *Error) {
                        
                        
                        
                        
                    }];
                

                                // [self.navigationController popViewControllerAnimated:YES];
                [self performSegueWithIdentifier:@"toHome" sender:nil];
                
            
            }
            //  [self ShowAlertView:result];
        }
        else if([result isEqualToString:@"Invalid"]){
            [prefs setObject:@"false" forKey:@"isLogged"];
            [prefs removeObjectForKey:@"id"];
            [prefs removeObjectForKey:@"isLogged"];
            [prefs removeObjectForKey:@"username"];
            [prefs removeObjectForKey:@"password"];
            [prefs removeObjectForKey:@"role"];
            [prefs removeObjectForKey:@"company"];
            [prefs synchronize];
            mUserNameTextField.hidden=NO;
            mPasswordTextField.hidden=NO;
            mLoginButton.hidden=NO;
            mRegisterButton.hidden=NO;
            [self ShowAlertView:result];
        }
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        [self dismiss:alertPleaseWait];
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to login"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    

    
}


-(void)showUIControls{
    [prefs setObject:@"false" forKey:@"isLogged"];
   
    myView.hidden=NO;
    [prefs removeObjectForKey:@"id"];
    [prefs removeObjectForKey:@"isLogged"];
    [prefs removeObjectForKey:@"username"];
    [prefs removeObjectForKey:@"password"];
    [prefs removeObjectForKey:@"role"];
    [prefs removeObjectForKey:@"company"];
    [prefs synchronize];
    mUserNameTextField.hidden=NO;
    mPasswordTextField.hidden=NO;
    mLoginButton.hidden=NO;
    mRegisterButton.hidden=NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"toHome"])
//    {
//        MyRoutesViewController *menVC = segue.destinationViewController;
//        menVC.role=rideOptions;
//    }
}




- (IBAction)giverAction:(id)sender {
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid = [defaults objectForKey:@"id"];
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    
    NSString *devToken = [defaults1 objectForKey:@"token"];
    
    
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&token=%@",userid,devToken];
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_saveDevicetoken PostData:PostString];
    
    //specify the request method in first argument
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        NSDictionary *data = JSONDict;
        
        
        
        
        
        
        NSString *result=[data objectForKey:@"status"];
        
     //   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PostString message:[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     //   [alert show];
//        if([result isEqualToString:@"success"])
//        {
//            
//            //  [self ShowAlertView:result];
//        }
//        else if([result isEqualToString:@"Invalid"]){
//            
//        }
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        
    }];
    

        [prefs setObject:@"G" forKey:@"role"];
       [self performSegueWithIdentifier:@"toHome" sender:nil];
    
}

- (IBAction)takerAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid = [defaults objectForKey:@"id"];
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    
    NSString *devToken = [defaults1 objectForKey:@"token"];
    
    
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&token=%@",userid,devToken];
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_saveDevicetoken PostData:PostString];
    
    //specify the request method in first argument
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        NSDictionary *data = JSONDict;
        
        
        
        
        
        
        NSString *result=[data objectForKey:@"status"];
        
      //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PostString message:[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      //  [alert show];
//        if([result isEqualToString:@"success"])
//        {
//            
//            //  [self ShowAlertView:result];
//        }
//        else if([result isEqualToString:@"Invalid"]){
//            
//        }
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        
    }];
    

    [prefs setObject:@"T" forKey:@"role"];
    [self performSegueWithIdentifier:@"toHome" sender:nil];
    
}
@end
