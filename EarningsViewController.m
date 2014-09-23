//
//  EarningsViewController.m
//  CarPooling
//
//  Created by atk's mac on 22/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "EarningsViewController.h"

@interface EarningsViewController ()
{
    
    NSString *userId;
    NSUserDefaults *prefs ;
}
@end

@implementation EarningsViewController



- (void)viewDidLoad
 {
    [super viewDidLoad];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    earningsData=[[NSMutableArray alloc]init];
    ConnectToServer=[[ServerConnection alloc]init];
     [self fetchPoints];
  }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [earningsData count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RidePointModel *model=[earningsData objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"earnings";
    EarningsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[EarningsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.index.text=model.index;
    cell.points.text=model.points;
    cell.date.text=model.date;
    
    return cell;
    
}

-(void)fetchPoints
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString *postString=[NSString stringWithFormat:@"userId=%@",userId];
    NSData *ridePointsData=[ConnectToServer ServerCall:kServerLink_GetEarnings post:postString];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:ridePointsData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Earnings%@",data);
    if(!jsonParsingError)
    {
        NSArray *dataArray=[data objectForKey:@"Earnings"];
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
                [earningsData addObject:mRidePointModel];
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



@end
