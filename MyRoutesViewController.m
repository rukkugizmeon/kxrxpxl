//
//  MyRoutesViewController.m
//  CarPooling
//
//  Created by atk's mac on 06/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "MyRoutesViewController.h"
#import "CoRiderObject.h"
#import "CoRiderTableViewCell.h"
#import "CustomIOS7AlertView.h"
#import "InterfaceManager.h"




@interface MyRoutesViewController ()<GMSMapViewDelegate>
{
    NSString *markerTitle;
    BOOL noJourneyOngoing;
    NSString * onGoingJourneyId;
    NSInteger  activeRouteId;
    NSString  *confirmationJID;
   
    NSString *userId;
    NSString *active_Rawform;
    NSString *type;
    NSString *userRole;
    NSUserDefaults *prefs;
    int sel_index;
    NSArray *imageList;
    NSMutableArray *arrayNotifications;
    float zoom;
    
    GMSMarker * journeyMarker;
    UIAlertView * alertPleaseWait;
    CGRect notificationViewFrame,viewNotificationOriginalFrame;
    NSInteger sharedIndex, sharedIndex2;
    
    CustomIOS7AlertView * alertViewFeedback;
    NSMutableArray *arrayCoridersDetails;
    CustomIOS7AlertView *coRidersView;
    UIAlertView * alertDistance;
    NSString * completedJID;
   
}
@end

@implementation MyRoutesViewController
@synthesize  myMap,noOfSeatField,mActiveFields,mActiveSwitch,mDestField,zoomOut,zoomIn;
@synthesize  mOriginField,mTimeIntervalField,seats,activeDays,timeInterval,role;

@synthesize viewNotifications,tableViewJourneyCompletionConfirmation,viewFeedbackView,tableViewCoRiders;
@synthesize textViewFeedBack,AuthenticationServer;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [WTStatusBar clearStatus];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
   
    // [self.view addSubview:viewFeedbackView];
}
-(void)slider:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
-(void) showHideNotification : (id) sender
{
    
    
    notificationViewFrame=viewNotifications.frame;
    
    if (notificationViewFrame.size.height==0 ) {
        
        viewNotifications.alpha=1;
        
        viewNotifications.frame= CGRectMake(0, 0, notificationViewFrame.size.width, 0);
        
        [UIView animateWithDuration:.5 animations:^{
            
            
            
            viewNotifications.frame=viewNotificationOriginalFrame;
            viewNotifications.alpha=1;
            [self.view addSubview:viewNotifications];
            //[self ShowAlertView:@"Please Confirm Journey Completion"];
            
        }];
        
        
          [self.view addSubview:viewNotifications];
        
        
        [tableViewJourneyCompletionConfirmation reloadData];
        
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            
            
          //  viewNotifications.alpha=0;
         //   [viewNotifications setHidden:NO];
            
            notificationViewFrame.size.height=0;
            
            viewNotifications.frame=CGRectMake(viewNotificationOriginalFrame.origin.x, viewNotificationOriginalFrame.origin.y, viewNotificationOriginalFrame.size.width, 0);
            
            [viewNotifications removeFromSuperview];
            
        }];
        
    }

    
    


}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
//    int i = 0;
//    int j = 10/i;
    
    tableViewCoRiders.dataSource=self;
    tableViewCoRiders.delegate=self;
    
    
    
    
    
   viewNotificationOriginalFrame= notificationViewFrame = viewNotifications.frame;
    viewNotifications.frame=CGRectZero;
    
    arrayCoridersDetails = [NSMutableArray new];
    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"Rider 1",@"name",@"journeyreq_id",@"j_rid", nil];
//    
//    
//   // [arrayCoridersDetails addObject:dic];
    
    prefs= [NSUserDefaults standardUserDefaults];
    userId=[prefs stringForKey:@"id"];
    userRole=[prefs stringForKey:@"role"];
    
    
    
        [self requestForNotifications];
        
    
    
    alertPleaseWait = [[UIAlertView alloc] initWithTitle:kApplicationName message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    tableViewJourneyCompletionConfirmation.dataSource=self;
    tableViewJourneyCompletionConfirmation.delegate=self;
    
    noJourneyOngoing=true;
    
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
    UIButton *buttonN = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //[aButton setImage:buttonImage forState:UIControlStateNormal];
   // aButton.frame = CGRectMake(0.0, 0.0,30,20);
    
  UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
    
    UIBarButtonItem *barButtonNotification =[[UIBarButtonItem alloc] initWithCustomView:buttonN];
    [buttonN addTarget:self action:@selector(showHideNotification:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barButtonNotification;
    

    sel_index=0;
     self.navigationItem.title = @"My Routes";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"Role %@",role);
       self.navigationItem.hidesBackButton = YES;
       zoom=kGoogleMapsZoomLevelDefault;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    [WTStatusBar setLoading:YES loadAnimated:YES];
    mSelectedArray=[[NSMutableArray alloc]init];
  
    
    
    DaysArray=@[@"Sunday", @"Monday",
                @"Tuesday", @"Wednesday", @"Thursday",@"Friday",@"Saturday"];
    
   // [daysTableView setSeparatorInset:UIEdgeInsetsZero];
    
    ConnectToServer=[[ServerConnection alloc] init];
    arrayJourneyList=[[NSMutableArray alloc]init];
    
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
     GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
   // myMap.camera=cameraPosition;
    
    
    
    [self fetchMyRoutesFromServer];
    
}


-(void)ShowAlertView:(NSString*)Message{
    [WTStatusBar clearStatus];
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}

-(void)ShowResultAlertView:(NSString*)Message{
    
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}



-(void)fetchMyRoutesFromServer{
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    [myMap clear];
    
     NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_JourneyList PostData:PostString];
    
   
    
    //specify method in first argument
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        NSDictionary *data = JSONDict;
        
   //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        NSLog(@"Response %@",data);
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        if([result isEqualToString:@"0"])
        {
            
            [self ShowAlertView:@"No Routes added!!"];
        }
        else
        {
            NSLog(@"Response=1");
            for(int i=0;i<[data count]-2;i++)
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
                [arrayJourneyList addObject:mRouteModel];
                
            }}
        
        if (![[data valueForKey:@"active_route"] isKindOfClass:[NSNull class]]) {
            
            
            activeRouteId = [[data valueForKey:@"active_route"] integerValue] ;
        }
        
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self PlaceMarkersOnMap];
        
        
    } FailBlock:^(NSString *Error) {
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        
    }];

    
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
    
     myRouteModel *activeMarker;
    
    for (myRouteModel * model in arrayJourneyList) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_start_latitude doubleValue],[model.journey_start_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        if (activeRouteId) {
            
            NSInteger  ajid = (NSInteger)[model.journey_id integerValue];
       //     [self performSelectorInBackground:@selector(fetchCoridersFromServer) withObject:nil];
        
        if (ajid == activeRouteId) {
            
            activeMarker=model;
            
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            
            journeyMarker=marker;
            noJourneyOngoing=false;
            
            
            
            
        }
        }
        
        
        marker.map = myMap;
      //  marker.icon = [UIImage imageNamed:@"ridewithme_mobile_peopletracker"];
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_start_latitude doubleValue] longitude:[model.journey_start_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
        myMap.camera=cameraPosition;
    }
    
    if (activeMarker) {
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([activeMarker.journey_start_latitude doubleValue],[activeMarker.journey_start_longitude doubleValue]);

        
        marker.map = myMap;
        //  marker.icon = [UIImage imageNamed:@"ridewithme_mobile_peopletracker"];
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[activeMarker.journey_start_latitude doubleValue] longitude:[activeMarker.journey_start_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
        myMap.camera=cameraPosition;

    }
    
   


}


-(void)ShowRouteAlertWithMessage:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDay active:(NSString*)action {
    
    Alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
   AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"MyDataView" owner:self options:nil] objectAtIndex:0];
    AccessoryView.hidden=NO;
    [AccessoryView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView.frame=CGRectMake(20,self.view.frame.origin.y+20,AccessoryView.frame.size.width-20,AccessoryView.frame.size.height);
    AccessoryView.layer.cornerRadius=5;
    //[Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    // Set Values
    mOriginField.text=from;
    mDestField.text=to;
    time=[NSString stringWithFormat:@"%@",time];
    mTimeIntervalField.text=time;
    if([role isEqualToString:@"T"])
    {
        self.seatsLabel.hidden=YES;
        noOfSeatField.hidden=YES;
    }else{
    noSeats=[NSString stringWithFormat:@"%@",noSeats];
        noOfSeatField.text=noSeats;}
    activeDays=[NSString stringWithFormat:@"%@",activeDays];
    mActiveFields.text=activeDay;
    NSString *active=[NSString stringWithFormat:@"%@",action];
    if([active isEqualToString:@"1"])
    {
    [mActiveSwitch setOn:YES animated:YES];
    }
    else{
     [mActiveSwitch setOn:NO animated:YES];
    }
    mActiveSwitch.userInteractionEnabled=NO;
    [myMap addSubview:AccessoryView];
   // [Alert show];
}



#pragma Mark GMS delegate ******************************************************************

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    markerTitle=[NSString stringWithFormat:@"%@",marker.title];
    
    if([userRole isEqualToString:@"G"])
    {
        // For Giver
        
    
        if (marker==journeyMarker) {
        
        NSLog(@"Green Marker Pressed");
        
        UIAlertView * alertForGreenMarker =[[UIAlertView alloc]initWithTitle:kApplicationName message:@"Stop Journey?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",@"Route Details", nil];
        
        alertForGreenMarker.tag = 20;
        
        [alertForGreenMarker show];
        
        
        }else if (noJourneyOngoing){
        
        
        UIAlertView * alertForRedMarker = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"Do you want to start journey?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",@"Route Details", nil];
        
        //alertForTapOnRoute.cancelButtonIndex=-1;
        
        alertForRedMarker.tag=10;
        
        [alertForRedMarker show];
        
        journeyMarker = marker;
        
              
    //    }else if (onGoingJourneyId){
        
    
        
    
        } else {
        
        NSLog(@"Red marker Tapped");
        
        NSLog(@"JID %@",markerTitle);
        for (myRouteModel * model in arrayJourneyList)
        {
            NSString *jid=[NSString stringWithFormat:@"%@",model.journey_id];
            if([markerTitle isEqualToString:jid])
            {
                [self ShowRouteAlertWithMessage:model.journey_start_point To:model.journey_end_point TimeI:model.time_intervals NofSeats:model.seats_count ActiveDays:model.active_days active:model.active];
                seats=model.seats_count;
                timeInterval=model.time_intervals;
                activeDays=model.active_days;
                active_Rawform=model.active_raw;
            }
        }
        
        
    }
    }else{
        
       // For Taker
        
          markerTitle=[NSString stringWithFormat:@"%@",marker.title];
        
        NSLog(@"Red marker Tapped");
        
        NSLog(@"JID %@",markerTitle);
        for (myRouteModel * model in arrayJourneyList)
        {
            NSString *jid=[NSString stringWithFormat:@"%@",model.journey_id];
            if([markerTitle isEqualToString:jid])
            {
                [self ShowRouteAlertWithMessage:model.journey_start_point To:model.journey_end_point TimeI:model.time_intervals NofSeats:model.seats_count ActiveDays:model.active_days active:model.active];
                seats=model.seats_count;
                timeInterval=model.time_intervals;
                activeDays=model.active_days;
                active_Rawform=model.active_raw;
            }
        }

        
        
        
    }
    
	return YES;
}


#pragma Mark Alert View Delegate *****************

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
   
    
    if (alertView.tag==10) {
        // Start Journey Alert
        
        switch (buttonIndex) {
            case 0:
                
                NSLog(@"No pressed");
                
                
                break;
                
            case 1:
                
                NSLog(@"Start Jouney Block");
                
                
                [self startEndJourneyWithFlag:@"N" Distance:@"0"];

                break;
                
            case 2:
                NSLog(@"Display Route Details");
                
                
                
                NSLog(@"JID %@",markerTitle);
                for (myRouteModel * model in arrayJourneyList)
                {
                    NSString *jid=[NSString stringWithFormat:@"%@",model.journey_id];
                    if([markerTitle isEqualToString:jid])
                    {
                        [self ShowRouteAlertWithMessage:model.journey_start_point To:model.journey_end_point TimeI:model.time_intervals NofSeats:model.seats_count ActiveDays:model.active_days active:model.active];
                        seats=model.seats_count;
                        timeInterval=model.time_intervals;
                        activeDays=model.active_days;
                        active_Rawform=model.active_raw;
                    }
                }
                
                break;
                
            default:
                break;
        }
        
        
        
        
        
    } else if (alertView.tag==20)
    {
        if (buttonIndex==1) {
            
            //Stop journey
            
            NSLog(@"Stop Journey Block");
            
          //  [self startEndJourneyWithFlag:@"Y"Distance:@"10"];
            
            if (journeyMarker) {
                
                
                [self fetchCoridersForJourneyId:journeyMarker.title];
            }else{
                
                
                [InterfaceManager DisplayAlertWithMessage:@"something went wrong, Look like no journey on going"];
            }
            
            
        }else if (buttonIndex==2){
            
            NSLog(@"Display Route Details");
            
            
            
            
            NSLog(@"JID %@",markerTitle);
            
            for (myRouteModel * model in arrayJourneyList)
            {
                NSString *jid=[NSString stringWithFormat:@"%@",model.journey_id];
                if([markerTitle isEqualToString:jid])
                {
                    [self ShowRouteAlertWithMessage:model.journey_start_point To:model.journey_end_point TimeI:model.time_intervals NofSeats:model.seats_count ActiveDays:model.active_days active:model.active];
                    seats=model.seats_count;
                    timeInterval=model.time_intervals;
                    activeDays=model.active_days;
                    active_Rawform=model.active_raw;
                }
            }
            

            
            
            
        }
        
        } else {
            
            
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        
        
    if (alertView.tag==30) {
        
        if (buttonIndex == 1) {
            
            
            NSString * distance = [alertView textFieldAtIndex:0].text;
            
            [self startEndJourneyWithFlag:@"Y" Distance:distance];
            
            
            
        }else{
            
            
            
        }
        
        
        
    }
    


    if ([title isEqualToString:@"Dismiss"])
    {
        
     [self fetchMyRoutesFromServer];
      NSLog(@"Dismissed");
        
    }
    
    else if ([title isEqualToString:@"Delete"])
    {
        
    [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
     [self DeleteRoute];
        
    }
    
}

-(void)ShowDeleteAlertView{
    
    NSString *Message=@"Are you sure you want to delete ?";
    
   Alert= [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel",nil];
    [Alert show];
    
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
            AccessoryView.hidden=YES;
        }
        else if([result isEqualToString:@"0"]){
           
            [self ShowAlertView:@"Deletion Failed!!"];
            
        }
    }
    else{
      
        [self ShowAlertView:UnableToProcess];
    }
}

# pragma Mark Button Actions

- (IBAction)zoomIn:(id)sender {
    zoom=zoom+0.5f;
    [myMap animateToZoom:zoom];
}

- (IBAction)zoomOut:(id)sender {
    zoom=zoom-0.5f;
    [myMap animateToZoom:zoom];
}

- (IBAction)deleteRoute:(id)sender {
    [self ShowDeleteAlertView];

}

- (IBAction)editRouteDetails:(id)sender {
        EditRouteViewController *edtVC= [self.storyboard instantiateViewControllerWithIdentifier:@"editRouteDetail"];
        edtVC.journeyId=markerTitle;
        edtVC.seats=seats;
        edtVC.timeInterval=timeInterval;
       edtVC.activeDays=activeDays;
        edtVC.activeDaysRaw=active_Rawform;
        [self.navigationController pushViewController:edtVC animated:YES];
}

- (IBAction)closeView:(id)sender {
    AccessoryView.hidden=YES;
   
}

- (IBAction)showRouteDetail:(id)sender {
    DetailRouteViewController *VC= [self.storyboard instantiateViewControllerWithIdentifier:@"detailRoute"];
      VC.journeyId=markerTitle;
    
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma  Mark Journey Start End Related Methods

-(void) startEndJourneyWithFlag:(NSString *) flag Distance : (NSString *) distance
{
    // flag N for start, Y for End
 
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    NSString * PostString;
    if ([flag isEqualToString:@"N"]) {
        //start
    
         PostString = [NSString stringWithFormat:@"journey_req_id=%@&journey_complete=%@&journey_distance=%@",journeyMarker.title,flag,distance];
    
    }else{
        
        
        
        PostString = [NSString stringWithFormat:@"journey_req_id=%@&journey_complete=%@&journey_distance=%@",journeyMarker.title,flag,distance];
        
        // stop
        
    }

    
        AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_StartStopJourney PostData:PostString];
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        NSString * journeyStatus = [data valueForKey:@"journey_status"];

        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        
        if ([result isEqualToString:@"success"]) {
            
            if ([journeyStatus isEqualToString:@"N"]) {
                
                // Journey Started
                
                noJourneyOngoing=false;
                
                journeyMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                
              //  [self fetchCoridersForJourneyId:journeyMarker.title];
                
               
                
            }else if ([journeyStatus isEqualToString:@"Y"] ){
                
                // Journey Ended
                
                if (arrayJourneyList.count) {
                    
                   
                    
                    journeyMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
                    
                    journeyMarker = nil;
                    
                    noJourneyOngoing=true;
                    
                    
                    
                    [coRidersView close];
                    
                }
                else{
             
                
              //
                
                    [alertPleaseWait show];
                    
                [self fetchCoridersForJourneyId:journeyMarker.title];
                    
                }
                
            }else if([journeyStatus isEqualToString:@"I"] ){
                
                
                [self ShowAlertView:@"You cannot start journey for a route without co-riders"];
                
                journeyMarker=nil;
                
            }
   
        }
     
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        
        
     } FailBlock:^(NSString *Error) {
         
         [InterfaceManager DisplayAlertWithMessage:@"Failed to Start/Stop Journey"];
         
         [WTStatusBar setLoading:NO loadAnimated:NO];
         [WTStatusBar clearStatus];
         
     }];
    
}

#pragma Mark Table View Delegates *********************************************

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableViewCoRiders) {
        return 50;
    }
    
    return 110;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableViewCoRiders) {
        
        return arrayCoridersDetails.count;
    }else{
        
    
    
    return arrayNotifications.count;
}

}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==tableViewCoRiders) {
        
        
        CoRiderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none"];
        
        
        if (cell==nil) {
            
            NSArray * bundle = [[NSBundle mainBundle] loadNibNamed:@"CoRiderTableViewCell" owner:self options:nil];
            
            cell = bundle[0];
            
            
            
        }
        
        
        cell.labelName.text=[[arrayCoridersDetails objectAtIndex:indexPath.row]valueForKey:@"name"];
        
        
        
        [cell.buttonStop addTarget:self action:@selector(stopJourneyForUser:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        return cell;
        
    }else{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellForJCC" forIndexPath:indexPath];
    
    
        UITextField * textViewRouteDetails = (UITextField *) [cell viewWithTag:101];
    UITextField * textViewDate = (UITextField *) [cell viewWithTag:102];
    UIButton * buttonAccept =(UIButton*) [cell viewWithTag:103];
    UIButton * buttonReject =(UIButton*) [cell viewWithTag:104];
    UITextField *textStatus = (UITextField *) [cell viewWithTag:105];
    
    
    ModelNotification * notification = [arrayNotifications objectAtIndex:indexPath.row];
    
    
    NSString *dateNTime = notification.date;
    
    
    textViewDate.text = dateNTime;
    
    textViewRouteDetails.text = notification.route;
    
    textStatus.text = notification.description;

       
    if ([userRole isEqualToString:@"G"]) {
        
        [buttonAccept setHidden:YES];
        [buttonReject setHidden:YES];
        [textStatus setHidden:NO];
        
    }else if ([notification.status isEqualToString:@"R"]){
        
        [buttonAccept setHidden:NO];
        [buttonReject setHidden:NO];
        [textStatus setHidden:YES];
        
        
    }else{
        
        [buttonAccept setHidden:YES];
        [buttonReject setHidden:YES];
        [textStatus setHidden:NO];
    }
    
    
    [buttonAccept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonReject addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
    
    return cell;
}
}
#pragma  Mark Journey Completion Related Methods ******************************

- (void) requestForNotifications
{
    [alertPleaseWait show];
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
  //  NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetNotifications PostData:PostString];
    
     //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
           NSDictionary *data = JSONDict;
        
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        if ([result isEqualToString:@"success"]) {
            
            
            arrayNotifications = [data valueForKey:@"result"];
        
            
            NSMutableArray * tempSwapArray = [NSMutableArray new];
            
            for (NSDictionary * recievedData in arrayNotifications) {
                
                ModelNotification * notification = [ModelNotification new];
                
                NSString * route = @"";
                
                route = [[route stringByAppendingString:[recievedData valueForKey:@"journey_start_point"]] stringByAppendingString:@" - "];
                
                route = [route stringByAppendingString:[recievedData valueForKey:@"journey_end_point"]];
                
                
                
                notification.route = route;
                
                notification.reqId = [recievedData valueForKey:@"journey_req_id"];
                
                notification.status = [recievedData valueForKey:@"type"];
                
                notification.date=[recievedData valueForKey:@"Journey_Start_TS"];
                
                if ([[recievedData valueForKey:@"Reject_Comment"] isKindOfClass:[NSNull class]] || [recievedData valueForKey:@"Reject_Comment"] == nil) {
                    
                    notification.description = @"";
                    
                }else{
                    
                    notification.description = [recievedData valueForKey:@"Reject_Comment"];
                    
                }
                [tempSwapArray addObject:notification];
                
                
                
                
                
                
            }
            
            arrayNotifications=tempSwapArray;
            
            if (arrayNotifications.count>0) {
                
                viewNotifications.alpha=0;
                
                viewNotifications.frame= CGRectMake(0, 0, notificationViewFrame.size.width, 0);
                
                [UIView animateWithDuration:.5 animations:^{
                    
                    
                    
                    viewNotifications.frame=notificationViewFrame;
                    viewNotifications.alpha=1;
                    //  [self.view addSubview:viewNotifications];
                    //[self ShowAlertView:@"Please Confirm Journey Completion"];
                    
                }];
                
                
                [self.view addSubview:viewNotifications];
                
                
                [tableViewJourneyCompletionConfirmation reloadData];
                
                
            }else{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    
                    viewNotifications.alpha=0;
                    [viewNotifications setHidden:NO];
                    
                }];
                
            }
            
            
            
        }
    
        
     [WTStatusBar setLoading:NO loadAnimated:NO];
     [WTStatusBar clearStatus];
        
        
     } FailBlock:^(NSString *Error) {
         
         [InterfaceManager DisplayAlertWithMessage:@"Failed to load Notifications"];
         
         [WTStatusBar setLoading:NO loadAnimated:NO];
         [WTStatusBar clearStatus];
         
     }];
    
}
-(void) acceptAction :(UIButton *) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewJourneyCompletionConfirmation];
    NSIndexPath *indexPath = [tableViewJourneyCompletionConfirmation indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        sharedIndex=indexPath.row;
        
        [self reviewJourneyCompleteWithFlag:@"Y" ArrayIndex:indexPath.row AndComment:@""];
        
        
    }

    
}
-(void) rejectAction :(UIButton *) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewJourneyCompletionConfirmation];
    NSIndexPath *indexPath = [tableViewJourneyCompletionConfirmation indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        sharedIndex = indexPath.row;
        
        alertViewFeedback = [[CustomIOS7AlertView alloc] init];
        
        NSArray * tmp = [[NSBundle mainBundle] loadNibNamed:@"FeedBack" owner:self options:nil];
        UIView * vvv= tmp[0];
        
        
        vvv.frame = CGRectMake(vvv.frame.origin.x, vvv.frame.origin.y, 300, 200);
        
        
        alertViewFeedback.buttonTitles= [NSArray arrayWithObjects:@"Cancel",@"Submit",nil];
        
        [alertViewFeedback setContainerView:vvv];
        
        [alertViewFeedback setDelegate:self];
        
        
        [alertViewFeedback show];
        
        
        
        
        
        
      //  [self reviewJourneyCompleteWithFlag:@"N" andArrayIndex:indexPath.row];
        
        
    }
    
    
}
-(void) reviewJourneyCompleteWithFlag :(NSString *) flag ArrayIndex :(NSInteger) index AndComment :(NSString *) comment
{
    // flag N for reject, Y for accept
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    [alertPleaseWait show];
    
    ModelNotification * replyNotification=[arrayNotifications objectAtIndex:index];
    
    NSNumber *jId = (NSNumber*)replyNotification.reqId;
    
    confirmationJID = [jId stringValue];
    
    if (comment==nil) {
        comment=@"";
    }
    
    NSString * PostString = [NSString stringWithFormat:@"journey_req_id=%@&journey_complete=%@&comment=%@",jId,flag,comment];
    
    
    
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_ReviewJourneyCompleteConfirmation PostData:PostString];
    
    
    
    
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
          NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        if ([result isEqualToString:@"success"])
        {
            
            if ([[data valueForKey:@"ReviewStatus"] isEqualToString:@"Y"]) {
                
                
                
                ModelNotification * completed = [arrayNotifications objectAtIndex:sharedIndex];
                
                completed.status= @"RC";
                
                [arrayNotifications replaceObjectAtIndex:sharedIndex withObject:completed];
                
                [tableViewJourneyCompletionConfirmation reloadData];
                
//                [self ShowAlertView:@"Thank you for reviewing the ride. Your action will be communicated to Car Owner and Appropriate ride points are transferred."];
                
                NSString * amountToPay = [data valueForKey:@"amount"];
                
                 completedJID = confirmationJID;

                [self dismiss:alertPleaseWait];

                [self displayPaymentVCWithPaymentAmount:amountToPay];
                
            }else if ([[data valueForKey:@"ReviewStatus"] isEqualToString:@"N"]){
                
                ModelNotification * completed = [arrayNotifications objectAtIndex:sharedIndex];
                
                completed.status= @"RC";
                
                [arrayNotifications replaceObjectAtIndex:sharedIndex withObject:completed];
                
                [tableViewJourneyCompletionConfirmation reloadData];
                
                [self ShowAlertView:@"Thank You"];
                
                [self dismiss:alertPleaseWait];
                
                [alertViewFeedback close];
                
                
            }
            
            
            
        }else{
            
            [self ShowAlertView:@"Review submit not successful, try again"];
             [self dismiss:alertPleaseWait];
        }
        
        
        
        
        
        
        
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed Try Again"];
        
        [self dismiss:alertPleaseWait];
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    

    
}
-(void) sendFeedBackToServer :(NSString *) feedBackString
{
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    [alertPleaseWait show];
    
   
    
    NSString * PostString = [NSString stringWithFormat:@"journey_req_id=%@&comment=%@",confirmationJID,feedBackString];
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_JourneyList PostData:PostString];
    
        
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        
        
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        if ([result isEqualToString:@"success"])
            
        {
            
            [self ShowAlertView:@"Thank you for your feedback"];
            
            
        }else
        {
            
            [self ShowAlertView:@"Something went wrong."];
        }

        
        
        
        
        
        
        
        
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
       
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    

    
}
-(void) feedBackServerResponseWithData :(NSData *) responseData
{
    
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    
    if ([result isEqualToString:@"success"])

    {
        
        [self ShowAlertView:@"Thank you for your feedback"];
        
        
    }else
    {
        
        [self ShowAlertView:@"Something went wrong."];
    }
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    
    if (buttonIndex==1) {
        
        NSString *comment = textViewFeedBack.text;
        
        if (comment.length==0) {
            
            comment = @"";
        }
        
        [self reviewJourneyCompleteWithFlag:@"N" ArrayIndex:sharedIndex AndComment:comment];
        
        
        
        
        
    }
}
-(void)fetchCoridersForJourneyId :(NSString *) journeyId
{
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
    [arrayCoridersDetails removeAllObjects];
    
    
    
    NSString * PostString = [NSString stringWithFormat:@"journey_id=%@",journeyId];
  
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:@"http://ridewithme.in/index.php?r=Profile/fetchPassengerProfileApproved" PostData:PostString];
    
    
        //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        
        if ([[data valueForKey:@"result"] isEqualToString:@"success"]) {
            
            NSArray * passengers =[data valueForKey:@"passengerList"];
            
            
            for (NSDictionary *passeng in passengers) {
                
                NSString * passName = [passeng valueForKey:@"name"];
                
                NSString *journeyRequestId = [passeng valueForKey:@"request_id"];
                
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:passName,@"name",journeyRequestId,@"j_rid", nil];
                
                
                [arrayCoridersDetails addObject:dic];
                
                
            }
            
            coRidersView = [CustomIOS7AlertView new];
            
            NSArray *temp =[[NSBundle mainBundle] loadNibNamed:@"CoridersInMyRoutes" owner:self options:nil];
            UIView *vvvv = [temp objectAtIndex:0];
            
            vvvv.frame = CGRectMake(vvvv.frame.origin.x, vvvv.frame.origin.y, 300, 200);
            
            
            
            [coRidersView setContainerView:vvvv];
            
            
             [coRidersView show];
            
            [tableViewCoRiders reloadData];

            [self dismiss:alertPleaseWait];
            
            
        }else{
            
            [self dismiss:alertPleaseWait];
            [InterfaceManager DisplayAlertWithMessage:@"Failed to load coriders"];
            
        }
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load coriders"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
}


-(void)stopJourneyForUser : (UIButton *) sender
{
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewJourneyCompletionConfirmation];
    NSIndexPath *indexPath = [tableViewJourneyCompletionConfirmation indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        sharedIndex2=indexPath.row;
        
        
        
        
    }
    
     alertDistance = [[ UIAlertView alloc]initWithTitle:kApplicationName message:@"Please enter how much kilo meters have you travelled" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Process" , nil];
    
    
    alertDistance.tag = 30;
    
    alertDistance.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    [alertDistance textFieldAtIndex:0].placeholder=@"Eg: 5.5";
    
    [alertDistance textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
    [alertDistance show];
    
   
    
}
-(void)displayPaymentVCWithPaymentAmount:(NSString*) amountToPay
{
    
    NSLog(@"Displaying PaymentVC");
    
    
    
    
    PGMerchantConfiguration *merchant = [PGMerchantConfiguration defaultConfiguration];
    
    
    
    merchant.merchantID = @"ridewi53827839997571";
    merchant.website = @"ridewithme";
    merchant.industryID = @"Retail";
    merchant.channelID = @"WAP";
    merchant.checksumGenerationURL =@"http://ridewithme.in/index.php?r=PgApi/getCheckSum";
    merchant.checksumValidationURL = @"http://ridewithme.in/index.php?r=PgApi/verifyCheckSum";
    merchant.theme=@"merchant";
    merchant.clientSSLCertPath= NULL;
    merchant.clientSSLCertPassword= NULL;
    //merchant.
    
    
    //creating unique orderid-c
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*curntdate=[formatter stringFromDate:date];
    
    NSString *currenttime=[curntdate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *c=[currenttime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *d=[c stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    
    
    //PGOrder *order = [PGOrder orderForOrderID:[d stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] customerID:@"220199" amount:@"10"
    // customerMail:@"shikha@oxyten.com" customerMobile:@"9633255821"];
    PGOrder *order = [PGOrder orderForOrderID:[d stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] customerID:@"220199" amount:amountToPay
                                 customerMail:@"" customerMobile:@""];
    
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc]
                                                  initTransactionForOrder:order];
    txnController. serverType = eServerTypeStaging;
    //Set server for Staging :- eStagingServer.
    //  txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
    txnController.merchant=merchant;
    //Set merchant which has been configured in step 2
    txnController.delegate = self;
    //Set the Delegation Object and implement the methods mentioned in step 4
    [self.navigationController pushViewController:txnController animated:YES];
    
    NSLog(@"Pushed txnController");
    
    
}

- (void)didSucceedTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    NSLog(@"PAYTM SUCCESS = %@", response);
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *orderId= [response valueForKey:@"ORDERID"];
    
    NSString *txnAmount = [response valueForKey:@"TXNAMOUNT"];
    NSString *txnId = [ response valueForKey:@"TXNID"];
    NSString *jounrneyId = completedJID;
    
    
    
    
    
    NSString *PostData = [NSString stringWithFormat:@"userId=%@&TXNAMOUNT=%@&TXNID=%@&ORDERID=%@&JourneyID=%@",userId,txnAmount,txnId,orderId,jounrneyId];
    NSLog(@"Request: %@", PostData);
    
    
    AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_SetPayment PostData:PostData];
    
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST":^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSString * status = [JSONDict valueForKey:@"status"];
        
        
        
        if ([status isEqualToString:@"Success"]) {
            
            
            
            
            
            completedJID= nil;
            
            
        }else{
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        NSLog(@"error");
        
        
        
        
        
        
        
        
        
    }];
    
    
    
    
    
    
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    //Called when a transaction is failed with any reason. response dictionary will be having details about failed transaction.
    NSLog(@"PAYTM failed = %@", response);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    //Called when a transaction is canceled by user. response dictionary will be having details about canceled transaction.
    NSLog(@"PAYTM cancel = %@", response);
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
////-(NSString*) getJourneyreqIdForJourneyId:(NSString*) journeyId
////{
////    
////    for (NSDictionary * jorney in arrayJourneyList) {
////        
////        NSString * jId = [jorney valueForKey:@"journey_id"];
////        NSString *jrqId = [jorney valueForKey:@""];
////        
////        if () {
////            <#statements#>
////        }
////        
////        
////    }
//
//    
//    
//    
//    return nil;
//}
 @end
