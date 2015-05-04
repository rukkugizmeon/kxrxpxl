//
//  SlidingMenuViewController.m
//  ParivarTree
//
//  Created by atk's mac on 09/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "SlidingMenuViewController.h"
#import "SelectChatRoomViewController.h"

@interface SlidingMenuViewController ()
{
  NSUserDefaults *prefs ;
    NSString *role;
  NSArray *images;
}
@end

@implementation SlidingMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs=[NSUserDefaults standardUserDefaults];
    role=[prefs objectForKey:@"role"];
    self.view.backgroundColor=[UIColor clearColor];
  if([role isEqualToString:@"T"])
      {
   images=@[@"Ridewithme_mobile_menu_myroutes.png", @"Ridewithme_mobile_menu_profile.png",@"Ridewithme_mobile_menu_payments.png", @"Ridewithme_mobile_menu_search.png",@"Ridewithme_mobile_menu_ridepoints.png",@"Ridewithme_mobile_requestsent.png",@"Ridewithme_mobile_requestreceived.png", @"Ridewithme_mobile_menu_signout.png",@"Ridewithme_mobile_requestsent.png"];
      }
  else{
   images=@[@"Ridewithme_mobile_menu_myroutes.png", @"Ridewithme_mobile_menu_profile.png",@"Ridewithme_mobile_menu_earnings.png", @"Ridewithme_mobile_menu_search.png",@"Ridewithme_mobile_menu_coriders.png",@"Ridewithme_mobile_requestsent.png",@"Ridewithme_mobile_requestreceived.png", @"Ridewithme_mobile_menu_signout.png",@"Ridewithme_mobile_requestsent.png"];
  }
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    //self.tableView.frame = CGRectMake(0,45,320,430);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50.0f)];
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, 0, 24)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:label];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundColor = [UIColor clearColor];
 
   // cell.textLabel.textAlignment=UITextAlignmentCenter;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
  
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 0, tableView.frame.size.width, 20
)];
//    view.backgroundColor = [UIColor clearColor];
//    UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
//    dot.image=[UIImage imageNamed:@"tree_bar.png"];
//    [view addSubview:dot];

    return view;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;

    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SlidingNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
     NSLog(@"%li",(long)indexPath.section);
     NSLog(@"%li",(long)indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        MyRoutesViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"myRoute"];
        navigationController.viewControllers = @[VC];

    }
    else  if (indexPath.section == 0 && indexPath.row == 1) {
        ProfileViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        navigationController.viewControllers = @[VC];
    }
     else if (indexPath.section == 0 && indexPath.row == 2) {
         if([role isEqualToString:@"T"])
         {
             PurchaseViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
                 navigationController.viewControllers = @[VC];
         }
         else{
             EarningsViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"earning"];
             navigationController.viewControllers = @[VC];
         }
         }
     else if (indexPath.section == 0 && indexPath.row == 3) {
          MapViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"searchAdd"];
         navigationController.viewControllers = @[VC];
     }
     else if (indexPath.section == 0 && indexPath.row == 4) {
         if([role isEqualToString:@"T"])
         {
         RidePointsViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"ridePoint"];
         navigationController.viewControllers = @[VC];
         }
         else{
             CoRidersViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"corider"];
             navigationController.viewControllers = @[VC];
         }
     }
     else if (indexPath.section == 0 && indexPath.row == 5) {
        RequestSentViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"requestSent"];
         navigationController.viewControllers = @[VC];
     }
     else if (indexPath.section == 0 && indexPath.row == 6) {
         RequestRecievedViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"requestRecieved"];
         navigationController.viewControllers = @[VC];
     }
    else if (indexPath.section == 0 && indexPath.row == 7) {
          NSLog(@"LOGOUT");
        
      
        [prefs removeObjectForKey:@"id"];
        [prefs removeObjectForKey:@"username"];
        [prefs removeObjectForKey:@"isLogged"];
        [prefs synchronize];
        
        LoginViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [nav setNavigationBarHidden:YES];
        
        [[[[UIApplication sharedApplication]windows] objectAtIndex:0] setRootViewController:nav];
     //   [self performSegueWithIdentifier:@"logout" sender:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
    }else if (indexPath.section == 0 && indexPath.row == 8)
    {
        SelectChatRoomViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"chatroom"];
        navigationController.viewControllers = @[VC];
        
        
    }
    
    if (indexPath.section == 0 && indexPath.row != 7){
        
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
    
    
}



#pragma mark -
#pragma mark UITableView Datasource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return [images count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   // static NSString *cellIdentifier = @"Cell";
    static NSString *simpleTableIdentifier = @"menuCell";
    SlidingMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ SlidingMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section == 0) {
         cell.backgroundColor = [UIColor clearColor];
        cell.menuImage.image=[UIImage imageNamed:images[indexPath.row]];
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//  cell.textLabel.text = images[indexPath.row];
    return cell;
}

@end
