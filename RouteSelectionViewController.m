//
//  RouteSelectionViewController.m
//  CarPooling
//
//  Created by atk's mac on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RouteSelectionViewController.h"

@interface RouteSelectionViewController ()

@end

@implementation RouteSelectionViewController
@synthesize cityNames,mFindRouteButton,mDestination,mOrigin,Names,options,subOptions;
NSString *city,*origin,*dest,*option;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    cityNames = @[@"Bangalore",
                  @"Chennai",@"Kannur", @"Cochin", @"Delhi"];
    
      options= @[@"None",@"Favourite Users",@"Same Company", @"Nearest to starting", @"Nearest to Destination",@"Already interested", @"Highest Rating", @"Schedule"];
    
  //  @"female_only",
     [self.mOptionsPickerView selectRow:3 inComponent:0 animated:YES];
     [self.mCityPickerView selectRow:2 inComponent:0 animated:YES];
    NSLog(@"Counts %lu %lu",(unsigned long)subOptions.count,(unsigned long)options.count );
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mFindRouteButton.layer.cornerRadius=5;
    
    subOptions=@[@" ",@"fav_users",@"same_company",@"near_origin",@"near_destination",
                 @"interested",@"highest_rating",@"active_shedule"];

   
    Names = @[@",Bangalore",
                  @",Chennai",@",Kannur", @",Cochin", @",Delhi"];
   
    city=Names[2];
    option=subOptions[3];
      NSLog(@"Options %@",option);
    mOrigin.delegate=self;
    mDestination.delegate=self;
}
-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Verdana" size:16]];
       [tView setTextAlignment:UITextAlignmentCenter];
    }
   
    if(pickerView==self.mOptionsPickerView)
    {
    tView.text=[options objectAtIndex:row];
    }
    else{
        tView.text=[cityNames objectAtIndex:row];
    }
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
    if(pickerView==self.mOptionsPickerView)
    {
        return options.count;
    }
    else{
        return cityNames.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if(pickerView==self.mOptionsPickerView)
    {
        return options[row];
       
    }
    else
    {
    return cityNames[row];
         NSLog(@"Selected comp=  %li",(long)component);
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if(pickerView==self.mOptionsPickerView)
    {
        
        option=subOptions[row];
        NSLog(@"Selected option= %@",option);
    }
    else{
        
    city= Names[row];
         NSLog(@"Selected = %@",city);
    }
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [mOrigin resignFirstResponder];
    [mDestination resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField==mOrigin)
    {
        [textField resignFirstResponder];
        [mDestination becomeFirstResponder];
    }
    else if (textField==mDestination)
    {
         [textField resignFirstResponder];
        if(mOrigin.hasText && mDestination.hasText)
        {
            origin=[mOrigin.text stringByAppendingString:city];
            dest =[mDestination.text stringByAppendingString:city];
            [self performSegueWithIdentifier:@"toSearch" sender:nil];
        }
        else{
            [self ShowAlertView:@"Please fill all the fields"];
        }


    }
   
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==mDestination)
    {
        [self animateTextField: textField up: YES];
    }

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==mDestination)
    {
        [self animateTextField: textField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)SearchOnMap:(id)sender {
 
    if(mOrigin.hasText && mDestination.hasText)
    {
    origin=[mOrigin.text stringByAppendingString:city];
    dest =[mDestination.text stringByAppendingString:city];
    [self performSegueWithIdentifier:@"toSearch" sender:nil];
    }
    else{
        [self ShowAlertView:@"Please fill all the fields"];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([segue.identifier isEqualToString:@"toSearch"]) {
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.starts= origin;
        mapVC.stops=dest;
        mapVC.options=option;
    }

}




@end
