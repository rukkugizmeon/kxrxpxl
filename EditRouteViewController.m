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
    int sunFlag;
    int monFlag;
    int tueFlag;
    int wedFlag;
    int thuFlag;
    int friFlag;
    int satFlag;
    UIImage *sundayImage;
    UIImage *mondayImage;
    UIImage *tuesdayImage;
    UIImage *wednesdayImage;
    UIImage *thursdayImage;
    UIImage *fridayImage;
    UIImage *saturdayImage;
    
}

@end

@implementation EditRouteViewController

@synthesize noOfSeatField,editButton,mIntervalPicker,mScrollView,seatLabel,seatSlider;
@synthesize sunButton,monButton,tueButton,wedButton,thurButton,friButton,satButton;
NSArray *options;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WTStatusBar clearStatus];
    options= @[@"12-12:30 AM", @"12:30-1 AM",@"1:30-2 AM", @"2-2:30 AM",@"2:30-3 AM",@"3-3:30 AM", @"3:30-4 AM",@"4-4:30 AM",@"4:30-5 AM", @"5-5:30 AM", @"5:30-6 AM",@"6-6:30 AM", @"6:30-7 AM",@"7-7:30 AM", @"7:30-8 AM",@"8-8:30 AM",@"8:30-9 AM", @"9-9:30 AM", @"9:30-10 AM",@"10-10:30 AM",@"10:30-11 PM",@"11-11:30 AM",@"11:30-12 PM",@"12-12:30P M", @"12:30-1 PM",@"1:30-2 PM", @"2-2:30 PM",@"2:30-3 PM",@"3-3:30 PM", @"3:30-4 PM",@"4-4:30 PM",@"4:30-5 PM", @"5-5:30 PM", @"5:30-6 PM",@"6-6:30 PM", @"6:30-7 PM",@"7-7:30 PM", @"7:30-8 PM",@"8-8:30 PM",@"8:30-9 PM", @"9-9:30 PM", @"9:30-10 PM",@"10-10:30 PM", @"10:30-11 PM",@"11-11:30 PM",@"11:30-12 PM"];

    NSUInteger index  = [options indexOfObject:_timeInterval];
    
 
    
    
    if(index==NSIntegerMax)
    {
         [mIntervalPicker selectRow:5 inComponent:0 animated:YES];
    }
    else{
    [mIntervalPicker selectRow:index inComponent:0 animated:YES];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   [seatSlider setThumbImage:[UIImage imageNamed:@"ridewithme_mobile_slide.png"] forState:UIControlStateNormal];
    UIColor * Cgrey =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    self.view.backgroundColor=Cgrey;
    sundayImage=[UIImage imageNamed:@"ridewithme_mobile_sun.png"];
    mondayImage=[UIImage imageNamed:@"ridewithme_mobile_monday.png"];
    tuesdayImage=[UIImage imageNamed:@"ridewithme_mobile_tue.png"];
    wednesdayImage=[UIImage imageNamed:@"ridewithme_mobile_wednesday.png"];
    thursdayImage=[UIImage imageNamed:@"ridewithme_mobile_thu.png"];
    fridayImage=[UIImage imageNamed:@"ridewithme_mobile_fri.png"];
    saturdayImage=[UIImage imageNamed:@"ridewithme_mobile_sat.png"];
    ConnectToServer=[[ServerConnection alloc]init];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    type=[prefs stringForKey:@"role"];
    NSLog(@"Data %@+%@",userId,type);
    mSelectedArray=[[NSMutableArray alloc]init];
    sunFlag=0;
    monFlag=0;
    tueFlag=0;
    wedFlag=0;
    thuFlag=0;
    friFlag=0;
    satFlag=0;
    [self setUpUI];
}


- (IBAction)editDetails:(id)sender {
     [WTStatusBar setLoading:YES loadAnimated:YES];
    self.seats=[type isEqualToString:@"T"]?@"0":noOfSeatField.text;
    self.seats=[NSString stringWithFormat:@"%@",self.seats];
    self.activeDays=[self ActiveDaysText];
    NSString *postData=[NSString stringWithFormat:@"userId=%@&journeyId=%@&activeDays=%@&timeInterval=%@&seatsCount=%@",userId,self.journeyId,self.activeDays,self.timeInterval,self.seatLabel.text];
    NSData *editDataResp=[ConnectToServer ServerCall:kServerLink_EditRoute post:postData];
    NSLog(@"Array%@",[NSString stringWithFormat:@"%@",mSelectedArray]);
    [self parseData:editDataResp];
}

-(void)parseData:(NSData*)responseData
{
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingAllowFragments error:&jsonParsingError];
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
        NSLog(@"%@",jsonParsingError.description);
    }

}

-(void)ShowAlertView:(NSString*)Message{
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    MyRoutesViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"myRoute"];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
    



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI
{   // self.navigationItem.hidesBackButton = YES;
     noOfSeatField.delegate=self;
    [mScrollView setScrollEnabled:YES];
    [mScrollView setContentSize:CGSizeMake(320, 570)];
    if([type isEqualToString:@"T"])
    {
        self.takerContainer.hidden=YES;
    }else{
        
    NSString *seats=[NSString stringWithFormat:@"%@",self.seats];
        seatLabel.text=seats;
        float age=[seats floatValue];
        [seatSlider setValue:age];
      
    noOfSeatField.delegate=self;}
   // NSString *timeInter=[NSString stringWithFormat:@"%@",self.timeInterval];
    
   // Active days
    
    if([self.activeDays rangeOfString:@"Sun"].location != NSNotFound)
    {
        sunFlag=1;
         [mSelectedArray addObject:@"0"];
        [sunButton setImage:sundayImage forState:UIControlStateNormal];
    }
    else
    {
      
    }
    if([self.activeDays rangeOfString:@"Mon"].location != NSNotFound)
    {
        monFlag=1;
         [mSelectedArray addObject:@"1"];
      [monButton setImage:mondayImage forState:UIControlStateNormal];
    }
    else
    {
    
    }
    if([self.activeDays rangeOfString:@"Tue"].location != NSNotFound)
    {
         [mSelectedArray addObject:@"2"];
        tueFlag=1;
         [tueButton setImage:tuesdayImage forState:UIControlStateNormal];
    }
    else
    {
        
    }
    if([self.activeDays rangeOfString:@"Wed"].location != NSNotFound)
    {
        wedFlag=1;
         [mSelectedArray addObject:@"3"];
       [wedButton setImage:wednesdayImage forState:UIControlStateNormal];
    }
    else
    {
    
    }
    if([self.activeDays rangeOfString:@"Thu"].location != NSNotFound)
    {
        thuFlag=1;
         [mSelectedArray addObject:@"4"];
          [thurButton setImage:thursdayImage forState:UIControlStateNormal];
    }
    else
    {
        
    }
    if([self.activeDays rangeOfString:@"Fri"].location != NSNotFound)
    {
        friFlag=1;
         [mSelectedArray addObject:@"5"];
          [friButton setImage:fridayImage forState:UIControlStateNormal];
    }
    else
    {
        
    }
    if([self.activeDays rangeOfString:@"Sat"].location != NSNotFound)
    {
        satFlag=1;
         [mSelectedArray addObject:@"6"];
          [satButton setImage:saturdayImage forState:UIControlStateNormal];
    }
    else
    {
        
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
    //[mSelectedArray removeAllObjects];
//    if([sunSwitch isOn])
//    {
//      [mSelectedArray addObject:@"0"];
//    }
//    if([monSwitch isOn])
//    {
//        [mSelectedArray addObject:@"1"];
//    }
//    if([tueSwitch isOn])
//    {
//       [mSelectedArray addObject:@"2"];
//    }
//    if([wedSwitch isOn])
//    {
//        [mSelectedArray addObject:@"3"];
//    }
//    if([thursSwitch isOn])
//    {
//        [mSelectedArray addObject:@"4"];
//    }
//    if([friSwitch isOn])
//    {
//        [mSelectedArray addObject:@"5"];
//    }
//    if([satSwitch isOn])
//    {
//        [mSelectedArray addObject:@"6"];
//    }
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
        [tView setTextAlignment:NSTextAlignmentCenter];
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

- (IBAction)sunClick:(id)sender {
    if(sunFlag==1)
    {
        sunFlag=0;
        [mSelectedArray removeObject:@"0"];
        [self.sunButton setImage:nil forState:UIControlStateNormal];
    }
    else if(sunFlag==0)
    {
        sunFlag=1;
        [mSelectedArray addObject:@"0"];
        [self.sunButton setImage:sundayImage forState:UIControlStateNormal];
    }
    NSLog(@"Active days %@",[NSString stringWithFormat:@"%@",mSelectedArray]);
}

- (IBAction)monClick:(id)sender {
    if(monFlag==1)
    {
        monFlag=0;
        [mSelectedArray removeObject:@"1"];
        [self.monButton setImage:nil forState:UIControlStateNormal];
    }
    else if(monFlag==0)
    {
         monFlag=1;
         [mSelectedArray addObject:@"1"];
        [self.monButton setImage:mondayImage forState:UIControlStateNormal];
    }
}

- (IBAction)tueClick:(id)sender {
    if(tueFlag==1)
    {
        [mSelectedArray removeObject:@"2"];
        tueFlag=0;
        [self.tueButton setImage:nil forState:UIControlStateNormal];
    }
    else if(tueFlag==0)
    {
        tueFlag=1;
        [mSelectedArray addObject:@"2"];
        [self.tueButton setImage:tuesdayImage forState:UIControlStateNormal];
    }
}

- (IBAction)wedClick:(id)sender {
    if(wedFlag==1)
    {
        [mSelectedArray removeObject:@"3"];
        wedFlag=0;
        [self.wedButton setImage:nil forState:UIControlStateNormal];
    }
    else if(wedFlag==0)
    {
        [mSelectedArray addObject:@"3"];
        
        wedFlag=1;
        [self.wedButton setImage:wednesdayImage forState:UIControlStateNormal];
    }

}

- (IBAction)thursClick:(id)sender {
    if(thuFlag==1)
    {
        thuFlag=0;
        
        [mSelectedArray removeObject:@"4"];
        [self.thurButton setImage:nil forState:UIControlStateNormal];
    }
    else if( thuFlag==0)
    {
         thuFlag=1;
        [mSelectedArray addObject:@"4"];
        [self.thurButton setImage:thursdayImage forState:UIControlStateNormal];
    }

}

- (IBAction)friClick:(id)sender {
    if(friFlag==1)
    {
        friFlag=0;
         [mSelectedArray removeObject:@"5"];
        [self.friButton setImage:nil forState:UIControlStateNormal];
    }
    else if(friFlag==0)
    {
        friFlag=1;
        [mSelectedArray addObject:@"5"];
        [self.friButton setImage:fridayImage forState:UIControlStateNormal];
    }

}

- (IBAction)satClick:(id)sender {
    if(satFlag==1)
    {
         [mSelectedArray removeObject:@"6"];
        satFlag=0;
        [self.satButton setImage:nil forState:UIControlStateNormal];
    }
    else if(satFlag==0)
    {
        satFlag=1;
        [mSelectedArray addObject:@"6"];
        [self.satButton setImage:saturdayImage forState:UIControlStateNormal];
    }

}
- (IBAction)seatValueChanged:(id)sender {
    int result = (int)ceilf(seatSlider.value);
   seatLabel.text = [NSString stringWithFormat:@"%i", result];
}
@end
