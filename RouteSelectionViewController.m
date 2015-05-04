//
//  RouteSelectionViewController.m
//  CarPooling
//
//  Created by atk's mac on 05/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RouteSelectionViewController.h"

@interface RouteSelectionViewController ()
{
    UITableView * autocompleteTableView;
    NSMutableArray *descriptionArray;
}
@end

@implementation RouteSelectionViewController
@synthesize cityNames,mFindRouteButton,mDestination,mOrigin,Names,options,subOptions;
NSString *city,*origin,*dest,*option;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mOrigin.text=@"";
    mDestination.text=@"";
    descriptionArray=[[NSMutableArray alloc]init];
    cityNames = @[@"Bangalore",
                  @"Chennai",@"Kannur", @"Cochin", @"Delhi"];
    
      options= @[@"None",@"Favourite Users",@"Same Company", @"Nearest to starting", @"Nearest to Destination",@"Already interested", @"Highest Rating", @"Schedule"];
    
     [self.mOptionsPickerView selectRow:3 inComponent:0 animated:YES];
     [self.mCityPickerView selectRow:2 inComponent:0 animated:YES];
    NSLog(@"Counts %lu %lu",(unsigned long)subOptions.count,(unsigned long)options.count );
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
     UIColor *placeholder =[UIColor colorWithRed:230.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
     self.navigationItem.hidesBackButton = YES;
    [mOrigin setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [mDestination setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    
     UIColor * Cgrey =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    self.view.backgroundColor=Cgrey;
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
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(35,265,mOrigin.frame.size.width,90) style:UITableViewStylePlain];
    
    autocompleteTableView.delegate=self;
    autocompleteTableView.dataSource = self;
    
    autocompleteTableView.layer.masksToBounds=YES;
    autocompleteTableView.backgroundColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.9f];
    
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.layer.cornerRadius=3;
    [autocompleteTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:autocompleteTableView];
    autocompleteTableView.hidden = YES;



//    NSDictionary *params = @{@"input" : [@"Kannur" stringByReplacingOccurrencesOfString:@" " withString:@"+"],
//                             @"location" : [NSString stringWithFormat:@"%f,%f", 37.76999,-122.44696],
//                             @"sensor" : @true,
//                             @"key" : kGoogleMapsAPIKey};
    }

-(void)setupUI:(CGFloat)y
{

  }
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *substring;
    
        
        substring = [NSString stringWithString:textField.text];
        substring = [substring
                     stringByReplacingCharactersInRange:range withString:string];
        
        if(substring!=nil && substring.length>2)
        {
           // [self Places:substring];
            
        }
        else if(substring.length==0){
            autocompleteTableView.hidden=YES;
        }
    
    
    return YES;
}


-(void)Places:(NSString*)input
{
    
    NSLog(@"@Profile Info");
    NSString *postData=[NSString stringWithFormat:@"%@&location=11.8689,75.3555&radius=500&sensor=true&key=%@",input,kGooglePlacesAPIKey];
    NSString *text=@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=";
    text=[text stringByAppendingString:postData];
    NSURL *url = [NSURL URLWithString:text];
    // NSLog(@"Url%@",url);
    dispatch_async(kBgQueue, ^{
        NSData *data= [NSData dataWithContentsOfURL:
                       url];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        
        
    });
}

- (void)fetchedData:(NSData *)responseData
{
    //  NSLog(@"@Parsing Info");
    [descriptionArray removeAllObjects];
     //[autocompleteTableView reloadData];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:0 error:&jsonParsingError];
   
    NSArray *predictions=[data objectForKey:@"predictions"];
    for(int i=0;i<[predictions count];i++)
    {
        NSDictionary *predObj=[predictions objectAtIndex:i];
        NSString *desc=[predObj objectForKey:@"description"];
         //NSLog(@"Descriptions%@",desc);
        [descriptionArray addObject:desc];
    }
    optionsArray = [[NSArray alloc] initWithArray:descriptionArray];
	
       //autocompleteTableView.hidden=NO;
    //[autocompleteTableView reloadData];
}


// Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [descriptionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text =[descriptionArray objectAtIndex:indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if(mOrigin.editing)
    {
        mOrigin.text=[descriptionArray objectAtIndex:indexPath.row];
        
    }else{
        mDestination.text=[descriptionArray objectAtIndex:indexPath.row];
    }
    NSLog(@"%@",[descriptionArray objectAtIndex:indexPath.row]);
    autocompleteTableView.hidden=YES;
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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

            [tView setFont:[UIFont fontWithName:@"Verdana" size:20]];}
        else{
            
            [tView setFont:[UIFont fontWithName:@"Verdana" size:16]];
        }
       [tView setTextAlignment:NSTextAlignmentCenter];
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
    [ self.view endEditing:YES];
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
     autocompleteTableView.frame = CGRectMake(35,318,mOrigin.frame.size.width,90);
        [self animateTextField: textField up: YES];
    }
    else if(textField==mOrigin)
    {
        autocompleteTableView.frame = CGRectMake(35,265,mOrigin.frame.size.width,90);
       // [self animateTextField: textField up: YES];
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
   // [self performSegueWithIdentifier:@"toSearch" sender:nil];
       MapViewController *mapVC= [self.storyboard instantiateViewControllerWithIdentifier:@"searchAdd"];
        mapVC.starts=mOrigin.text;
        mapVC.stops=mDestination.text;
        mapVC.options=option;
        [self.navigationController pushViewController:mapVC animated:YES];
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
        mapVC.starts=mOrigin.text;
        mapVC.stops=mDestination.text;
        mapVC.options=option;
    }

}




@end
