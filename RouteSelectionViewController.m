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
@synthesize cityNames,mFindRouteButton,mDestination,mOrigin,Names;
NSString *city,*origin,*dest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mFindRouteButton.layer.cornerRadius=5;
    cityNames = @[@"Kannur", @"Bangalore",
                      @"Chennai", @"Cochin", @"Delhi"];
    Names = @[@",Kannur", @",Bangalore",
                  @",Chennai", @",Cochin", @",Delhi"];
    city=Names[0];
    mOrigin.delegate=self;
    mDestination.delegate=self;
}
-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return cityNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return cityNames[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    city= Names[row];
    
    NSLog(@"Selected = %@",city);
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
    }

}




@end
