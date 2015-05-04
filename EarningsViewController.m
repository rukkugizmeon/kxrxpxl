//
//  EarningsViewController.m
//  CarPooling
//
//  Created by atk's mac on 22/09/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "EarningsViewController.h"
#import "InterfaceManager.h"
#import "BinSystemsServerConnectionHandler.h"

@interface EarningsViewController ()
{
    
    NSString *userId;
    NSUserDefaults *prefs ;
    UIColor * tblbg;
}
@end

@implementation EarningsViewController



- (void)viewDidLoad
 {
    [super viewDidLoad];
     UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
     UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [aButton setImage:buttonImage forState:UIControlStateNormal];
     aButton.frame = CGRectMake(0.0, 0.0,30,20);
     UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
     [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.leftBarButtonItem = slideButton;
   self.navigationItem.hidesBackButton = YES;  
        self.navigationItem.title = @"Earnings";
       tblbg =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
     self.view.backgroundColor=tblbg;
     self.pointsTable.backgroundColor=[UIColor clearColor];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    earningsData=[[NSMutableArray alloc]init];
    ConnectToServer=[[ServerConnection alloc]init];
   
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
    [self fetchPoints];
    tblbg =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:0.9f];
    self.view.backgroundColor=tblbg;
    
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
    cell.backgroundColor=[UIColor clearColor];
    cell.index.text=model.index;
    cell.points.text=model.points;
    cell.date.text=model.date;
    
    return cell;
    
}

-(void)fetchPoints
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString *postString=[NSString stringWithFormat:@"userId=%@",userId];
  
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetEarnings PostData:postString];
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        NSDictionary *data = JSONDict;
        
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
        
    
    
     
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load Earnings"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];

    
    
  
       }

-(void)ShowAlertView:(NSString*)Message{
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}



@end
