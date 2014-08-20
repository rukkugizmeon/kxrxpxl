//
//  EditRouteViewController.m
//  CarPooling
//
//  Created by atk's mac on 20/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "EditRouteViewController.h"

@interface EditRouteViewController ()

@end

@implementation EditRouteViewController

@synthesize noOfSeatField,daysTableView,intervalSegment,editButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
     mSelectedArray=[[NSMutableArray alloc]init];
    [daysTableView setSeparatorInset:UIEdgeInsetsZero];
    daysTableView.layer.cornerRadius=10;
    DaysArray=@[@"Sunday", @"Monday",
                @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    [self setUpUI];
}

- (IBAction)editDetails:(id)sender {
    NSLog(@"Array%@",[NSString stringWithFormat:@"%@",mSelectedArray]);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [DaysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *data=[DaysArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    cell.textLabel.text = data;
    cell.backgroundColor=[UIColor clearColor];
    if([self.activeDays rangeOfString:@"Mon"].location == NSNotFound)
    {
        NSLog(@"Not Founed!!!!!!!!!!!!!!!!");
    }else{
      //  [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [mSelectedArray addObject:data];
    }
    return cell;
}

#pragma mark UITableViewDelegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *data=[DaysArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        NSLog(@"Cleared%@",data);
        [mSelectedArray removeObject:data];
    }else{
      
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
         NSLog(@"Selected %@",data);
        [mSelectedArray addObject:data];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI
{
    noOfSeatField.text=[NSString stringWithFormat:@"%@",self.seats];
    noOfSeatField.delegate=self;
    NSString *timeInter=[NSString stringWithFormat:@"%@",self.timeInterval];
    if([timeInter isEqualToString:@"9-10"])
    {
        [intervalSegment setSelectedSegmentIndex:0];
    }
    else if ([timeInter isEqualToString:@"10-11"])
    {
        [intervalSegment setSelectedSegmentIndex:1];
    }
    else{
        [intervalSegment setSelectedSegmentIndex:2];
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
    const int movementDistance = 105; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
