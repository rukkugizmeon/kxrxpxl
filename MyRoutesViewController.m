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
    NSString *active_Rawform;
    NSString *type;
    NSUserDefaults *prefs;
}
@end

@implementation MyRoutesViewController
@synthesize  myMap,noOfSeatField,mActiveFields,mActiveSwitch,mDestField;
@synthesize  mOriginField,mTimeIntervalField,seats,activeDays,timeInterval;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [WTStatusBar clearStatus];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    mSelectedArray=[[NSMutableArray alloc]init];
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    type=[prefs stringForKey:@"role"];
    
    DaysArray=@[@"Sunday", @"Monday",
                @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
   // [daysTableView setSeparatorInset:UIEdgeInsetsZero];
    ConnectToServer=[[ServerConnection alloc] init];
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


-(void)ShowAlertView:(NSString*)Message{
    [WTStatusBar clearStatus];
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [Alerts show];
}

-(void)ShowResultAlertView:(NSString*)Message{
    
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}



-(void)fetchMyRoutesFromServer{
    [myMap clear];
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
     NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    if([result isEqualToString:@"0"])
    {
        
    [self ShowAlertView:@"No Routes added!!"];
    }
    else
    {
        NSLog(@"Response=1");
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
        NSString *active=[journeyArray objectForKey:@"active_day"];
        mRouteModel.active_raw=active;
        mRouteModel.active_days=[self replaces:active];
        mRouteModel.active=[journeyArray objectForKey:@"active"];
        mRouteModel.time_intervals=[journeyArray objectForKey:@"time_intervals"];
        mRouteModel.seats_count=[journeyArray objectForKey:@"seats_count"];
        [journeyListArray addObject:mRouteModel];
    }}
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
    [self PlaceMarkersOnMap];
   
}
-(NSString*)replaces:(NSString*)string
{
    string=[string stringByReplacingOccurrencesOfString:@"0"
                                             withString:@"Sun"];
    string=[string stringByReplacingOccurrencesOfString:@"1"
                                             withString:@"Mon"];
    string=[string stringByReplacingOccurrencesOfString:@"2"
                                             withString:@"Tue"];
    string=[string stringByReplacingOccurrencesOfString:@"3"
                                             withString:@"Wed"];
    string=[string stringByReplacingOccurrencesOfString:@"4"
                                             withString:@"Thu"];
    string=[string stringByReplacingOccurrencesOfString:@"5"
                                             withString:@"Fri"];
    string=[string stringByReplacingOccurrencesOfString:@"6"
                                             withString:@"Sat"];
    string=[string stringByReplacingOccurrencesOfString:@"{"
                                             withString:@""];
    string=[string stringByReplacingOccurrencesOfString:@"}"
                                             withString:@""];
    return string;
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
        seats=model.seats_count;
        timeInterval=model.time_intervals;
        activeDays=model.active_days;
        active_Rawform=model.active_raw;
    }
    }
	return YES;
}

-(void)ShowRouteAlertWithMessage:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action {
    
    Alert = [[UIAlertView alloc]initWithTitle:@"Route Details" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Show route",@"Delete route",@"Edit details", nil];
    
    MyDataView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"MyDataView" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    // Set Values
    mOriginField.text=from;
    mDestField.text=to;
    time=[NSString stringWithFormat:@"%@",time];
    mTimeIntervalField.text=time;
    if([type isEqualToString:@"T"])
    {
        self.seatsLabel.hidden=YES;
        noOfSeatField.hidden=YES;
    }else{
    noSeats=[NSString stringWithFormat:@"%@",noSeats];
        noOfSeatField.text=noSeats;}
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
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    // Initate call over cellular network
    if ([title isEqualToString:@"Dismiss"])
    {
     [self fetchMyRoutesFromServer];
            NSLog(@"Dismissed");
    }
    // Initate call over cellular network
    if (buttonIndex==1) {
         [self performSegueWithIdentifier:@"toDetailedView" sender:nil];
        
    }
    else if (buttonIndex==2){
         [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
        [self DeleteRoute];
    }
    else if (buttonIndex==3){
    NSLog(@"Edit");
          [self performSegueWithIdentifier:@"toEditDetailView" sender:nil];
        
    }
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)DeleteRoute
{
    NSLog(@"Deleted");
    NSString *postString=[NSString stringWithFormat:@"userId=%@&journeyId=%@",userId,markerTitle];
    NSData *deleteRouteResponse=[ConnectToServer ServerCall:kServerLink_DeleteRoute post:postString];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:deleteRouteResponse
                                                         options:0 error:&jsonParsingError];
    if(!jsonParsingError)
    {
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        NSLog(@"Data %@",result);
        if([result isEqualToString:@"1"])
        {
            [self ShowResultAlertView:@"Route Successfully Deleted!!"];
            
        }
        else if([result isEqualToString:@"0"]){
           
            [self ShowAlertView:@"Deletion Failed!!"];
        }
    }
    else{
      
        [self ShowAlertView:UnableToProcess];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"toDetailedView"]) {
        DetailRouteViewController *detVC = segue.destinationViewController;
        detVC.journeyId=markerTitle;
    }
   else if ([segue.identifier isEqualToString:@"toEditDetailView"]) {
        EditRouteViewController *edtVC = segue.destinationViewController;
        edtVC.journeyId=markerTitle;
       edtVC.seats=seats;
       edtVC.timeInterval=timeInterval;
       edtVC.activeDays=activeDays;
       edtVC.activeDaysRaw=active_Rawform;
    }
}
@end
