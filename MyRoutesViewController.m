//
//  MyRoutesViewController.m
//  CarPooling
//
//  Created by atk's mac on 06/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "MyRoutesViewController.h"

@interface MyRoutesViewController ()<GMSMapViewDelegate>
{
    NSString *markerTitle;
    NSString *role;
    NSString *userId;
    NSUserDefaults *prefs;
}
@end

@implementation MyRoutesViewController
@synthesize  myMap,noOfSeatField,mActiveFields,mActiveSwitch,mDestField;
@synthesize  mOriginField,mTimeIntervalField;

-(void)viewDidAppear:(BOOL)animated
{
   
       [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mSelectedArray=[[NSMutableArray alloc]init];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    DaysArray=@[@"Sunday", @"Monday",
                @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
   // [daysTableView setSeparatorInset:UIEdgeInsetsZero];
    journeyListArray=[[NSMutableArray alloc]init];
    // [self ShowCallAlertWithMessage:@"Clicked"];
    [self LoadMaps];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [noOfSeatField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

-(void)LoadMaps
{
    myMap.delegate=self;
    myMap.myLocationEnabled = YES;
    [self.view addSubview:myMap];
    [myMap setMapType:kGMSTypeNormal];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:26.90083 longitude:76.35371 zoom:8];
    myMap.camera=cameraPosition;
    [self fetchMyRoutesFromServer];
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
//    return [DaysArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = nil;
//    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
//    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
//    }
//    cell.textLabel.textAlignment=UITextAlignmentCenter;
//    cell.textLabel.text = [DaysArray objectAtIndex:indexPath.row];
//    cell.backgroundColor=[UIColor clearColor];
//    return cell;
//}
//
//#pragma mark UITableViewDelegate methods
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//     NSString *data=[DaysArray objectAtIndex:indexPath.row];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//        NSLog(@"Cleared%@",data);
//        [mSelectedArray removeObject:data];
//    }else{
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//         NSLog(@"Selected %@",data);
//        [mSelectedArray addObject:data];
//    }
//}
-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}



-(void)fetchMyRoutesFromServer{
    [WTStatusBar setLoading:YES loadAnimated:YES];
   // NSString *user_id=@"564";
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
   NSLog(@"Url %@",kServerLink_JourneyList);
    NSLog(@"postString %@",PostString);
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_JourneyList]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if(!err)
        {
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        }else{
            [self ShowAlertView:@"invalid"];
           
        }
    });
    
    
    
}
- (void)fetchedData:(NSData *)responseData {
    
    [journeyListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
     NSLog(@"Response %@",data);
    if([data count]==0){
    [self ShowAlertView:@"No Routes added!!"];
    }else{
    for(int i=0;i<[data count]-1;i++)
    {
          mRouteModel=[[myRouteModel alloc] init];
        NSString *position= [NSString stringWithFormat:@"%i",i];
        NSDictionary *journeyArray=[data objectForKey:position];
        mRouteModel.journey_id=[journeyArray objectForKey:@"journey_id"];
        mRouteModel.journey_start_point=[journeyArray objectForKey:@"journey_start_point"];
        mRouteModel.journey_start_latitude=[journeyArray objectForKey:@"journey_start_latitude"];
        mRouteModel.journey_start_longitude=[journeyArray objectForKey:@"journey_start_longitude"];
        mRouteModel.journey_end_point=[journeyArray objectForKey:@"journey_end_point"];
        mRouteModel.active_days=[journeyArray objectForKey:@"active_days"];
        mRouteModel.active=[journeyArray objectForKey:@"active"];
        mRouteModel.time_intervals=[journeyArray objectForKey:@"time_intervals"];
        mRouteModel.seats_count=[journeyArray objectForKey:@"seats_count"];
        [journeyListArray addObject:mRouteModel];
    }}
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
    [self PlaceMarkersOnMap];
   
}

-(void)PlaceMarkersOnMap{
    NSLog(@"PlaceMarkersOnMap");
    
    for (myRouteModel * model in journeyListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_start_latitude doubleValue],[model.journey_start_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = myMap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_start_latitude doubleValue] longitude:[model.journey_start_longitude doubleValue] zoom:8];
        myMap.camera=cameraPosition;
    }
   
    
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    
	markerTitle=[NSString stringWithFormat:@"%@",marker.title];
    NSLog(@"JID %@",markerTitle);
    for (myRouteModel * model in journeyListArray)
    {
        NSString *id=[NSString stringWithFormat:@"%@",model.journey_id];
    if([markerTitle isEqualToString:id])
    {
        [self ShowRouteAlertWithMessage:model.journey_start_point To:model.journey_end_point TimeI:model.time_intervals NofSeats:model.seats_count ActiveDays:model.active_days active:model.active];
    }
    }
	return YES;
}

-(void)ShowRouteAlertWithMessage:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action {
    
    UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:@"Route Details" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Show route",@"Edit details", nil];
    
    MyDataView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"MyDataView" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    // Set Values
    mOriginField.text=from;
    mDestField.text=to;
    time=[NSString stringWithFormat:@"%@",time];
    mTimeIntervalField.text=time;
    noSeats=[NSString stringWithFormat:@"%@",noSeats];
    noOfSeatField.text=noSeats;
    activeDays=[NSString stringWithFormat:@"%@",activeDays];
    mActiveFields.text=activeDays;
    NSString *active=[NSString stringWithFormat:@"%@",action];
    if([active isEqualToString:@"1"])
    {
    [mActiveSwitch setOn:YES animated:YES];
    }
    else{
     [mActiveSwitch setOn:NO animated:YES];
    }
    mActiveSwitch.userInteractionEnabled=NO;
    [Alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Initate call over cellular network
    if (buttonIndex==1) {
         [self performSegueWithIdentifier:@"toDetailedView" sender:nil];
        
    }
    else if (buttonIndex==2){
        NSLog(@"2");
    }
    else{
    NSLog(@"3");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"toDetailedView"]) {
        DetailRouteViewController *detVC = segue.destinationViewController;
        detVC.journeyId=markerTitle;
    }
}
@end
