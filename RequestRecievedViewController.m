//
//  RequestRecievedViewController.m
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RequestRecievedViewController.h"
#import "CustomIOS7AlertView.h"
#import "BinSystemsServerConnectionHandler.h"
#import "InterfaceManager.h"

@interface RequestRecievedViewController ()<GMSMapViewDelegate>
{
    ServerConnection *ConnectToServer;
    float zoom;
    CustomIOS7AlertView * cAlertPassengersList;
    NSUInteger  sharedIndex;
    UIAlertView *alertPleaseWait;
}
@end

@implementation RequestRecievedViewController
@synthesize scollView,nameField,ageField,cityField,addressField,carModelField,sosContactField,SOSEmailField,phoneField,seatsField,views,routeFrom,routeTo;
@synthesize myMap,zoomOut,zoomIn;
NSString *uId;
NSString *types;
//UIAlertView * Alert;


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
    zoom=kGoogleMapsZoomLevelDefault;
    self.navigationItem.title = @"Request Recieved";
     self.navigationItem.hidesBackButton = YES;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    ConnectToServer=[[ServerConnection alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    uId=[prefs stringForKey:@"id"];
    types=[prefs stringForKey:@"role"];
    reqListArray=[[NSMutableArray alloc]init];
    passListArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self LoadMaps];
    //[myMap addSubview:zoom];
    
    
    alertPleaseWait  = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
}
-(void)slider:(id)sender
{
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
-(void)LoadMaps
{
    myMap.delegate=self;
    myMap.myLocationEnabled = YES;
    [self.view addSubview:myMap];
    [myMap setMapType:kGMSTypeNormal];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
    myMap.camera=cameraPosition;
   [self fetchMyRoutesFromServer];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Dismiss"]) {
       [self fetchMyRoutesFromServer];
        NSLog(@"dismiss");
    }
    
   
}

-(void)fetchMyRoutesFromServer{
    
    [myMap clear];
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
  //  @try {
        
        NSString * PostString = [NSString stringWithFormat:@"userId=%@",uId];
    

    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_journeyRequestRecieved PostData:PostString];
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        NSDictionary *data = JSONDict;
        
        
        
        NSString *status=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        if(![status isEqualToString:@"0"])
        {
            [reqListArray removeAllObjects];
            
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            NSArray *requestObj=[data objectForKey:@"requests"];
            int count=[requestObj count];
            if(count>0)
            {
                for(int i=0;i<[requestObj count];i++)
                {
                    mRequestModel=[[RecievedReqModel alloc] init];
                    NSDictionary *route=[requestObj objectAtIndex:i];
                    NSDictionary *journeyArray=[route objectForKey:@"route"];
                    mRequestModel.journey_id=[journeyArray objectForKey:@"journey_id"];
                    mRequestModel.user_id=[journeyArray objectForKey:@"user_id"];
                    NSLog(@"Jid %@",[journeyArray objectForKey:@"journey_id"]);
                    mRequestModel.journey_start=[journeyArray objectForKey:@"journey_start_point"];
                    mRequestModel.journey_latitude=[journeyArray objectForKey:@"journey_start_latitude"];
                    mRequestModel.journey_longitude=[journeyArray objectForKey:@"journey_start_longitude"];
                    mRequestModel.journey_end_latitude=[journeyArray objectForKey:@"journey_end_latitude"];
                    mRequestModel.journey_end_longitude=[journeyArray objectForKey:@"journey_end_longitude"];
                    [reqListArray addObject:mRequestModel];
                    
                }
                [self PlaceMarkersOnMap];}
            else{
                [WTStatusBar setLoading:NO loadAnimated:NO];
                [WTStatusBar clearStatus];
                [self ShowAlertView:@"No Requests found"];
                
            }
        }
        else{
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"No Requests found"];
            
        }
        

        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        
        
        [WTStatusBar clearStatus];
        
            
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
    }];
    
    
   }

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [Alert show];
}

-(void)ShowAlertViewwithDismiss:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

- (void)fetchedData:(NSData *)responseData {
    
    
    
}

-(void)PlaceMarkersOnMap{
    NSLog(@"PlaceMarkersOnMap");
    
    for (RecievedReqModel * model in reqListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_latitude doubleValue],[model.journey_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = myMap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
        myMap.camera=cameraPosition;
    }
    
    
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    @try {
        
        NSString *markerTitle=[NSString stringWithFormat:@"%@",marker.title];
        NSLog(@"JID %@",markerTitle);
        for (RecievedReqModel * model in reqListArray)
        {
            
            NSString *id=[NSString stringWithFormat:@"%@",model.journey_id];
            if([markerTitle isEqualToString:id])
            {
                NSString * PostString = [NSString stringWithFormat:@"userId=%@&journeyId=%@",uId,model.journey_id];
                NSData *passengerList=[ConnectToServer ServerCall:kServerLink_journeyRequestPassengers post:PostString];
                
                [alertPleaseWait show];
                [self parsePassengerResponse:passengerList];
                [self dismiss:alertPleaseWait];
            }
        }

        
    }
    @catch (NSException *exception) {
        
        [self ShowAlertView:exception.description];
    }
    @finally {
        
        
        NSLog(@"Finally block executed:");
        
    }
    
 return YES;
}

-(void) parsePassengerResponse:(NSData*)responseData
{
    [passListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Requested%@",data);
    if(!jsonParsingError)
    {
        
    NSArray *passenger=[data objectForKey:@"passengerList"];
        NSLog(@"Pass Count%lu",(unsigned long)[passenger count]);
        
        for(int pos=0;pos<[passenger count];pos++)
        {
            
            mPassengerModel=[[PassengerListModel alloc]init];
            NSDictionary *passDict=[passenger objectAtIndex:pos];
           // mPassengerModel.journey_id=[passDict objectForKey:@"journey_id"];
            mPassengerModel.request_id=[passDict objectForKey:@"request_id"];
            mPassengerModel.name=[passDict objectForKey:@"name"];
            mPassengerModel.user_id=[passDict objectForKey:@"user_id"];
            mPassengerModel.request_status=[passDict objectForKey:@"request_status"];
            mPassengerModel.age=[passDict valueForKey:@"age"];
            mPassengerModel.address=[passDict valueForKey:@"address"];
            mPassengerModel.city=[passDict valueForKey:@"city"];
            mPassengerModel.mobile=[passDict valueForKey:@"mobile_number"];
            mPassengerModel.sosEmail=[passDict valueForKey:@"sos_email_id"];
            mPassengerModel.sosNumber=[passDict valueForKey:@"sos_contact_num"];
            mPassengerModel.journeyDetails=[passDict objectForKey:@"journeydetails"];
            mPassengerModel.carModel=[passDict objectForKey:@"car_model"];
          //  NSLog(@"RequestedName%@",[passDict objectForKey:@"name"]);
            mPassengerModel.index=[NSString stringWithFormat:@"%i",pos+1];
              NSLog(@"Index%@",mPassengerModel.index);
            // NSLog(@"RequestedIndex%@",[NSString stringWithFormat:@"%i",pos+1]);
            [passListArray addObject:mPassengerModel];
            
        }
        
        [self.passengerTable reloadData];
          [self ShowPassengerAlertWithMessage];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengerListModel *model=[passListArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"passengerCell";
    
    PassengerListTableViewCell *cell=(PassengerListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.noField.text=model.index;
    cell.nameField.text=model.name;
    cell.acceptButton.layer.cornerRadius=3;
    cell.rejectButton.layer.cornerRadius=3;
    
    cell.acceptButton.tag = indexPath.row;
    
    [cell.acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if([model.request_status isEqualToString:@"P"])
    {
  
    cell.rejectButton.tag = indexPath.row;
     [cell.rejectButton addTarget:self action:@selector(rejectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    }
    else if([model.request_status isEqualToString:@"C"]){
       // cell.rejectButton.backgroundColor=[UIColor redColor];
        cell.rejectButton.enabled=NO;
    }
    return cell;
}


-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{

    return [passListArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PassengerListModel *model=[passListArray objectAtIndex:indexPath.row];
    
    [cAlertPassengersList close];
    
 
     [self ShowPassengerProfileAlert:model];
    
    sharedIndex=indexPath.row;
    
}

-(void)ShowPassengerProfileAlert:(PassengerListModel*)passenger
{
    
  // UIAlertView *Alert = [[UIAlertView alloc ]initWithTitle:@"Profile" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"RequesteProfileView" owner:self options:nil] objectAtIndex:0];
    
    
    [scollView setScrollEnabled:YES];
    [scollView setContentSize:CGSizeMake(289, 530)];
    AccessoryView.hidden=NO;
    [AccessoryView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView.frame=CGRectMake(15,self.view.frame.origin.y+40,289,self.view.frame.size.height-160);
    AccessoryView.layer.cornerRadius=5;
   
    nameField.text=passenger.name;
            ageField.text=[NSString stringWithFormat:@"%@",passenger.age];
    addressField.text=passenger.address;
    cityField.text=passenger.city;
    
   // types = [passenger.journeyDetails objectForKey:@"journey_type"];
    
            if([types isEqualToString:@"T"])
            {
                seatsField.text=[NSString stringWithFormat:@"%@",[passenger.journeyDetails objectForKey:@"seats_count"]];
                carModelField.text=passenger.carModel;
                
            }
            else if([types isEqualToString:@"G"]){
                self.model.hidden=YES;
                self.seats.hidden=YES;
                seatsField.hidden=YES;
                carModelField.hidden=YES;
                const int movementDistance = 60; // tweak as needed
                const float movementDuration = 0.1f; // tweak as needed
                bool up=YES;
                int movement = (up ? -movementDistance : movementDistance);
                
                [UIView beginAnimations: @"anim" context: nil];
                [UIView setAnimationBeginsFromCurrentState: YES];
                [UIView setAnimationDuration: movementDuration];
                views.frame = CGRectOffset(views.frame, 0, movement);
                [UIView commitAnimations];
                [scollView setContentSize:CGSizeMake(289,450)];
                 AccessoryView.frame=CGRectMake(15,self.view.frame.origin.y+40,289,self.view.frame.size.height-160);
            }
            sosContactField.text=[NSString stringWithFormat:@"%@",passenger.sosNumber ];
                                  SOSEmailField.text=passenger.sosEmail;
    phoneField.text=passenger.mobile;
    routeFrom.text=[NSString stringWithFormat:@"From:%@",[passenger.journeyDetails objectForKey:@"journey_start_point"]];
    routeTo.text=[NSString stringWithFormat:@"To:%@",[passenger.journeyDetails objectForKey:@"journey_end_point"]];
    

    [myMap addSubview:AccessoryView];
    //[Alert show];
}


//accept
-(void)acceptButtonClicked:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor blackColor]];
    PassengerListModel *model=[passListArray objectAtIndex:sender.tag];
    NSLog(@"Accepted=%@",model.request_id);
  

    
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&requestId=%@",uId,model.request_id];
    
    
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoridersProfileById PostData:PostString];
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        NSDictionary *data = JSONDict;
        
        [self fetchAcceptresponse:data sender:@"accept"];
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to process"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
    }];
    

}
-(void)rejectButtonClicked:(UIButton*)sender
{
    PassengerListModel *model=[passListArray objectAtIndex:sender.tag];
    NSLog(@"Rejected=%@",model.request_id);
    
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&requestId=%@",uId,model.request_id];
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
    
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoridersProfileById PostData:PostString];
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        NSDictionary *data = JSONDict;
        
        [self fetchAcceptresponse:data sender:@"reject"];
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to process"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
    }];
    
    
    
}

- (void)fetchAcceptresponse:(NSDictionary *)data sender:(NSString*)senders{
   
    if(data!=nil)
    {
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        NSLog(@"Data %@",result);
        if([result isEqualToString:@"1"])
        {
            
            
            [self ShowAlertViewwithDismiss:@"Request updated!!"];
            
            @try {
               [passListArray removeObjectAtIndex:sharedIndex];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
                
                NSLog(@"Finally block: remove object from passList Array");
            }
            
           
            
            [self.passengerTable reloadData];
            
        }
        else if([result isEqualToString:@"0"]){
            
            [self ShowAlertView:@"Unable to process request.Please try later!!"];
        }
    }
    else{
        [self ShowAlertView:UnableToProcess];
    }
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)ShowPassengerAlertWithMessage//:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action
{
    
    NSLog(@"Passengers List");
  
    
    
    cAlertPassengersList = [CustomIOS7AlertView new];
    
    PassengerListView *viewPassengerList =[[[NSBundle mainBundle]loadNibNamed:@"PassengerListView" owner:self options:nil] objectAtIndex:0];
    
    [viewPassengerList setBackgroundColor:[UIColor clearColor]];
    
    
    [cAlertPassengersList setContainerView:viewPassengerList];
    
    if (passListArray.count>0) {
        
        [cAlertPassengersList show];
        
    }else{
        
        [self ShowAlertView:@"No data to display"];
    }
    
    
    
}
- (IBAction)zoomIn:(id)sender {
    zoom=zoom+0.5f;
    [myMap animateToZoom:zoom];
}

- (IBAction)zoomOut:(id)sender {
    zoom=zoom-0.5f;
    [myMap animateToZoom:zoom];
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

- (IBAction)closeView:(id)sender {
    AccessoryView.hidden=YES;
    
    [self.passengerTable reloadData];
    if (passListArray.count>0) {
        
        [cAlertPassengersList show];
        
    }else{
        
        [self ShowAlertView:@"No data to display"];
    }
}
@end
