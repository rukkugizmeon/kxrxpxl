//
//  MenuViewController.m
//  CarPooling
//
//  Created by atk's mac on 25/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
{
    NSString *role;
    NSString *userId;
    NSUserDefaults *prefs ;
}
@end

@implementation MenuViewController

@synthesize earningPaymentButton,mRouteOptions,coRideRidePoints;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    
    role=[prefs stringForKey:@"role"];
    NSLog(@"%@",role);
    if([role isEqualToString:@"G"])
    {
        [earningPaymentButton setTitle:@"Earnings" forState:UIControlStateNormal];
        [coRideRidePoints setTitle:@"Co-riders" forState:UIControlStateNormal];
    }else if([role isEqualToString:@"T"])
    {
        [earningPaymentButton setTitle:@"Payments " forState:UIControlStateNormal];
        [coRideRidePoints setTitle:@"Ride Points" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Do any additional setup after loading the view.
}

- (IBAction)LogOut:(id)sender {
    [prefs removeObjectForKey:@"id"];
    [prefs removeObjectForKey:@"isLogged"];
    [prefs removeObjectForKey:@"username"];
    [prefs removeObjectForKey:@"password"];
    [prefs removeObjectForKey:@"role"];
    [prefs synchronize];
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

-(void)FetchEarningsFromServer{
    
  //NSString *UserId=@"200";
    NSString * PostString = [NSString stringWithFormat:@"userId=%@",userId];
    NSLog(@"postString %@",PostString);
    NSLog(@"}");
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_GetEarnings]];
    
    
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
            [self ShowAlertView:@"Unable to process request"];
        }
        
    });
}

- (IBAction)fetchEarnings:(id)sender {
    if([role isEqualToString:@"G"])
    {
        [self FetchEarningsFromServer];
    }else{
            [self ShowAlertView:@"Its Payments"];
    }
}

- (IBAction)MoveToCoriders:(id)sender {
    if([role isEqualToString:@"G"])
    {
        [self performSegueWithIdentifier:@"toCoriders" sender:nil];
    }
    else{
        [self ShowAlertView:@"Its ride points"];
    }
}

- (void)fetchedData:(NSData *)responseData {
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSString *earnings=[NSString stringWithFormat:@"%@",[data objectForKey:@"Earnings"]];
    NSLog(@"Data %@",result);
    if([result isEqualToString:@"No data found"])
    {
        [self ShowAlertView:@"No Earnings yet!!"];
        
    }
    else if(earnings!=nil){
        NSString *value=[@"Your Earnings :" stringByAppendingString:earnings];
        [self ShowAlertView:value];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
