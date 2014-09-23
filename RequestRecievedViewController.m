//
//  RequestRecievedViewController.m
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RequestRecievedViewController.h"

@interface RequestRecievedViewController ()<GMSMapViewDelegate>
{
    ServerConnection *ConnectToServer;
    float zoom;
}
@end

@implementation RequestRecievedViewController
@synthesize scollView,nameField,ageField,cityField,addressField,carModelField,sosContactField,SOSEmailField,phoneField,seatsField,views;
@synthesize myMap,zoomOut,zoomIn;
NSString *uId;
NSString *types;
UIAlertView * Alert;


- (void)viewDidLoad
{
    [super viewDidLoad];
    zoom=kGoogleMapsZoomLevelDefault;
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
    NSString * PostString = [NSString stringWithFormat:@"userId=%@",uId];
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_journeyRequestRecieved]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
        if(!err){
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        }
        else{
          
            [self ShowAlertView:UnableToProcess];
        }
        
    });
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
    
    [reqListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
    NSString *status=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    if(![status isEqualToString:@"0"])
         {
             [WTStatusBar setLoading:NO loadAnimated:NO];
             [WTStatusBar clearStatus];
           NSArray *requestObj=[data objectForKey:@"requests"];
             NSInteger *count=[requestObj count];
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
    
   NSString *markerTitle=[NSString stringWithFormat:@"%@",marker.title];
    NSLog(@"JID %@",markerTitle);
    for (RecievedReqModel * model in reqListArray)
    {
        NSString *id=[NSString stringWithFormat:@"%@",model.journey_id];
        if([markerTitle isEqualToString:id])
        {
             NSString * PostString = [NSString stringWithFormat:@"userId=%@&journeyId=%@",uId,model.journey_id];
            NSData *passengerList=[ConnectToServer ServerCall:kServerLink_journeyRequestPassengers post:PostString];
            
            [self parsePassengerResponse:passengerList];
        }
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
            mPassengerModel.journey_id=[passDict objectForKey:@"journey_id"];
            mPassengerModel.request_id=[passDict objectForKey:@"request_id"];
            mPassengerModel.name=[passDict objectForKey:@"name"];
            mPassengerModel.user_id=[passDict objectForKey:@"user_id"];
            mPassengerModel.request_status=[passDict objectForKey:@"request_status"];
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
        cell.rejectButton.backgroundColor=[UIColor redColor];
        cell.rejectButton.userInteractionEnabled=NO;
    }
    return cell;
}


-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{

    return [passListArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
    PassengerListModel *model=[passListArray objectAtIndex:indexPath.row];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&profileId=%@",uId,model.user_id];
    NSData *passengerProfile=[ConnectToServer ServerCall:kServerLink_GetCoridersProfileById post:PostString];
     [self ShowPassengerProfileAlert:passengerProfile];
    
}

-(void)ShowPassengerProfileAlert:(NSData*)responseData
{
    
   UIAlertView *Alert = [[UIAlertView alloc ]initWithTitle:@"Profile" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    RequestedProfileView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"RequesteProfileView" owner:self options:nil] objectAtIndex:0];
    
    
    [scollView setScrollEnabled:YES];
    [scollView setContentSize:CGSizeMake(320, 462)];
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Requested%@",data);
    if(!jsonParsingError)
    {
        NSArray *passengerProf=[data objectForKey:@"profile"];
        
        for(int pos=0;pos<[passengerProf count];pos++)
        {
            NSDictionary *passDict=[passengerProf objectAtIndex:pos];
            nameField.text=[passDict objectForKey:@"name"];
            ageField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"age"]];
            addressField.text=[passDict objectForKey:@"address"];
            cityField.text=[passDict objectForKey:@"city"];
            if([types isEqualToString:@"T"])
            {
                seatsField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"number_of_seats"]];
                carModelField.text=[passDict objectForKey:@"car_model"];
                
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
                [scollView setContentSize:CGSizeMake(320, 400)];
            }
            sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
        }
    }
    
    [Alert show];
}


//accept
-(void)acceptButtonClicked:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor blackColor]];
    PassengerListModel *model=[passListArray objectAtIndex:sender.tag];
    NSLog(@"Accepted=%@",model.request_id);
    [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&requestId=%@",uId,model.request_id];
    NSData *acceptedReq=[ConnectToServer ServerCall:kServerLink_AcceptRequest post:PostString];
    [self fetchAcceptresponse:acceptedReq sender:@"accept"];
}

- (void)fetchAcceptresponse:(NSData *)responseData sender:(NSString*)senders{
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    if(!jsonParsingError && data!=nil)
    {
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        NSLog(@"Data %@",result);
        if([result isEqualToString:@"1"])
        {
            
            [self ShowAlertViewwithDismiss:@"Request updated!!"];
            
            
            
        }
        else if([result isEqualToString:@"0"]){
            
            [self ShowAlertView:@"Unable to process request.Please try later!!"];
        }
    }
    else{
        [self ShowAlertView:UnableToProcess];
    }
}

-(void)rejectButtonClicked:(UIButton*)sender
{
    PassengerListModel *model=[passListArray objectAtIndex:sender.tag];
    NSLog(@"Rejected=%@",model.request_id);
    [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&requestId=%@",uId,model.request_id];
    NSData *rejectReq=[ConnectToServer ServerCall:kServerLink_RejectRequest post:PostString];
    [self fetchAcceptresponse:rejectReq sender:@"reject"];
    
}
-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)ShowPassengerAlertWithMessage//:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action
{
    NSLog(@"here");
    Alert = [[UIAlertView alloc ]initWithTitle:@"Passenger List" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    PassengerListView *AccessoryView =[[[NSBundle mainBundle]loadNibNamed:@"PassengerListView" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
  
    [Alert show];
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

@end
