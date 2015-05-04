//
//  RidePointsViewController.m
//  CarPooling
//
//  Created by atk's mac on 25/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RidePointsViewController.h"

@interface RidePointsViewController ()
{
  
    NSString *userId;
    NSUserDefaults *prefs ;
}

@end

@implementation RidePointsViewController


- (void)viewDidLoad

{
     self.navigationItem.title = @"Ride Points";
    self.navigationItem.hidesBackButton = YES;
  //  UIBarButtonItem *purchaseButton = [[UIBarButtonItem alloc] initWithTitle:@"Purchase" style:UIBarButtonItemStylePlain target:self action:@selector(purchase:)];
    //self.navigationItem.rightBarButtonItem = purchaseButton;
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
    [super viewDidLoad];
//    UIColor * Cblue =[UIColor colorWithRed:4.0f/255.0f green:200.0f/255.0f blue:248.0f/255.0f alpha:0.9f];
  
    UIColor *Cgrey =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
      self.view.backgroundColor=Cgrey;
    self.pointsTable.backgroundColor=[UIColor clearColor];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    ridePointData=[[NSMutableArray alloc]init];
    ConnectToServer=[[ServerConnection alloc]init];
     [self fetchRidePoints];
    
}
-(void)slider:(id)sender
{
   
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    UIColor *tblbg =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:0.9f];
    self.view.backgroundColor=tblbg;
    
}
-(void)purchase:(id)sender
{
    PurchaseViewController *purVC= [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
 
    [self.navigationController pushViewController:purVC animated:YES];
}
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [ridePointData count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RidePointModel *model=[ridePointData objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"ridecells";
    RidePointCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ RidePointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.index.text=model.index;
    cell.type.text=model.type;
    cell.points.text=model.points;
    cell.date.text=model.date;
        
       return cell;
    
}

-(void)fetchRidePoints
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString *postString=[NSString stringWithFormat:@"userId=%@",userId];
    NSData *ridePointsData=[ConnectToServer ServerCall:kServerLink_GetRidepoints post:postString];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:ridePointsData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"RidPoints%@",data);
    if(!jsonParsingError)
    {
        NSArray *dataArray=[data objectForKey:@"datas"];
        int count=[dataArray count];
        if(count>0)
        {
        for (int pos=0; pos<count; pos++)
         {
             NSDictionary *dataArrayObj =[dataArray objectAtIndex:pos];
             mRidePointModel=[[RidePointModel alloc]init];
             mRidePointModel.type=[dataArrayObj objectForKey:@"type"];
             mRidePointModel.date=[dataArrayObj objectForKey:@"date_time"];
             mRidePointModel.points=[dataArrayObj objectForKey:@"ride_points"];
             mRidePointModel.index=[NSString stringWithFormat:@"%i",pos+1];
             [ridePointData addObject:mRidePointModel];
        }
            [self.pointsTable reloadData];
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
        }
        else{
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"No data"];
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

- (IBAction)purchaseOption:(id)sender {
   // [self ShowAlertView:@"Purchase is pending"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
