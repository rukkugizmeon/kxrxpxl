//
//  EditRouteViewController.m
//  CarPooling
//
//  Created by atk's mac on 20/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "EditRouteViewController.h"

@interface EditRouteViewController ()
{
    NSString *userId;
    NSUserDefaults *prefs;
       NSString *type;
}

@end

@implementation EditRouteViewController

@synthesize noOfSeatField,editButton,mIntervalPicker,mScrollView;
@synthesize monSwitch,sunSwitch,tueSwitch,wedSwitch,thursSwitch,friSwitch,satSwitch;
NSArray *options;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WTStatusBar clearStatus];
    options= @[@"12-1 AM", @"1-2 AM",@"2-3 AM", @"3-4 AM",@"4-5 AM",@"5-6 AM", @"6-7 AM", @"8-9 AM",@"9-10 AM", @"10-11 AM", @"11-12 AM",@"12-1 PM", @"1-2 PM",@"2-3 PM", @"3-4 PM",@"4-5 PM",@"5-6 PM", @"6-7 PM", @"8-9 PM",@"9-10 PM", @"10-11 PM",@"11-12 PM"];
     NSUInteger index = [options indexOfObject:self.timeInterval];
    [mIntervalPicker selectRow:index inComponent:0 animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    ConnectToServer=[[ServerConnection alloc]init];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    type=[prefs stringForKey:@"role"];
    NSLog(@"Data %@+%@",userId,type);
    mSelectedArray=[[NSMutableArray alloc]init];
    [self setUpUI];
}


- (IBAction)editDetails:(id)sender {
     [WTStatusBar setLoading:YES loadAnimated:YES];
    self.seats=[type isEqualToString:@"T"]?@"0":noOfSeatField.text;
    self.seats=[NSString stringWithFormat:@"%@",self.seats];
    self.activeDays=[self ActiveDaysText];
    NSString *postData=[NSString stringWithFormat:@"userId=%@&journeyId=%@&activeDays=%@&timeInterval=%@&seatsCount=%@",userId,self.journeyId,self.activeDays,self.timeInterval,self.seats];
    NSData *editDataResp=[ConnectToServer ServerCall:kServerLink_EditRoute post:postData];
    NSLog(@"Array%@",[NSString stringWithFormat:@"%@",mSelectedArray]);
    [self parseData:editDataResp];
}

-(void)parseData:(NSData*)responseData
{
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    if(!jsonParsingError)
    {
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        NSLog(@"Data %@",result);
        if([result isEqualToString:@"1"])
        {
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"Details successfully update!!"];
        }
        else if([result isEqualToString:@"0"]){
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"Updation Failed!!"];
          
            
        }
    }
    else{
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:UnableToProcess];
    }

}

-(void)ShowAlertView:(NSString*)Message{
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
  
          [self performSegueWithIdentifier:@"backFromEdit" sender:nil];
        
}
    



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI
{
     noOfSeatField.delegate=self;
    [mScrollView setScrollEnabled:YES];
    [mScrollView setContentSize:CGSizeMake(320, 720)];
    if([type isEqualToString:@"T"])
    {
        noOfSeatField.hidden=YES;
        self.seatsLabel.hidden=YES;
    }else{
        
    noOfSeatField.text=[NSString stringWithFormat:@"%@",self.seats];
    noOfSeatField.delegate=self;}
    NSString *timeInter=[NSString stringWithFormat:@"%@",self.timeInterval];
    
   // Active days
    
    if([self.activeDays rangeOfString:@"Sun"].location != NSNotFound)
    {
     [sunSwitch setOn:YES animated:YES];
     NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
      [sunSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Mon"].location != NSNotFound)
    {
    [monSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [monSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Tue"].location != NSNotFound)
    {
        [tueSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [tueSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Wed"].location != NSNotFound)
    {
        [wedSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [wedSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Thu"].location != NSNotFound)
    {
        [thursSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [thursSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Fri"].location != NSNotFound)
    {
        [friSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [friSwitch setOn:NO animated:YES];
    }
    if([self.activeDays rangeOfString:@"Sat"].location != NSNotFound)
    {
        [satSwitch setOn:YES animated:YES];
         NSLog(@"Found!!!!!!!!!!!!!!!!");
    }
    else
    {
        [satSwitch setOn:NO animated:YES];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField: textField up: YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [noOfSeatField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 165; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(NSString*)ActiveDaysText
{
    [mSelectedArray removeAllObjects];
    if([sunSwitch isOn])
    {
      [mSelectedArray addObject:@"0"];
    }
    if([monSwitch isOn])
    {
        [mSelectedArray addObject:@"1"];
    }
    if([tueSwitch isOn])
    {
       [mSelectedArray addObject:@"2"];
    }
    if([wedSwitch isOn])
    {
        [mSelectedArray addObject:@"3"];
    }
    if([thursSwitch isOn])
    {
        [mSelectedArray addObject:@"4"];
    }
    if([friSwitch isOn])
    {
        [mSelectedArray addObject:@"5"];
    }
    if([satSwitch isOn])
    {
        [mSelectedArray addObject:@"6"];
    }
  NSString  *activedaysFinal= [[NSString stringWithFormat:@"%@",mSelectedArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
    activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@")" withString:@"}"];
        NSLog(@"Array%@",[NSString stringWithFormat:@"%@",activedaysFinal]);

    return activedaysFinal;
}

//picker

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [tView setFont:[UIFont fontWithName:@"Verdana" size:20]];}
        else{
            
            [tView setFont:[UIFont fontWithName:@"Verdana" size:16]];
        }
        [tView setTextAlignment:UITextAlignmentCenter];
    }
    
    
    tView.text=[options objectAtIndex:row];
    
    return tView;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    return options.count;
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return options[row];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    
    self.timeInterval= options[row];
    NSLog(@"Selected = %@",self.timeInterval);
    
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
