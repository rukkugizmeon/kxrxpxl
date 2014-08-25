//
//  CoRidersViewController.m
//  CarPooling
//
//  Created by atk's mac on 13/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "CoRidersViewController.h"

@interface CoRidersViewController ()<GMSMapViewDelegate>

@end

@implementation CoRidersViewController
@synthesize myMap,scrollView,nameField,ageField,cityField,addressField,carModelField,sosContactField,SOSEmailField,phoneField,seatsField;
NSString *uId;
NSString *types;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Rating=@"0";
    ConnectToServer=[[ServerConnection alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    uId=[prefs stringForKey:@"id"];
    types=[prefs stringForKey:@"role"];
    riderListArray=[[NSMutableArray alloc]init];
    ridePassengerListArray=[[NSMutableArray alloc]init];
    [self LoadMaps];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    // Initate call over cellular network
    if ([title isEqualToString:@"Cancel"]) {
        [self performSelector:@selector(dismiss:) withObject:Alerts afterDelay:1.0];
    
    }}

-(void)LoadMaps
{
    myMap.delegate=self;
    myMap.myLocationEnabled = YES;
    [self.view addSubview:myMap];
    [myMap setMapType:kGMSTypeNormal];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:26.90083 longitude:76.35371 zoom:8];
    myMap.camera=cameraPosition;
    [self fetchCoridersFromServer];
    
}
-(void)fetchCoridersFromServer
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString * PostString = [NSString stringWithFormat:@"user_id=%@",uId];
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_GetCoriders]];
    
    
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

- (void)fetchedData:(NSData *)responseData {
    
    [riderListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
    
    
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
     NSString *req=[data objectForKey:@"requests"];
    if(![req isEqualToString:@"No requests"])
       {
    NSArray *requestObj=[data objectForKey:@"requests"];
        if([requestObj count]>0 )
        {
            for(int i=0;i<[requestObj count];i++)
        {
           mRiderModel=[[CoRiderObject alloc] init];
            NSDictionary *route=[requestObj objectAtIndex:i];
            NSString *status=[NSString stringWithFormat:@"%@",[route objectForKey:@"status"]];
           mRiderModel.status=status;
            NSDictionary *journeyArray=[route objectForKey:@"route"];
           mRiderModel.journey_id=[journeyArray objectForKey:@"journey_id"];
           mRiderModel.user_id=[journeyArray objectForKey:@"user_id"];
            NSLog(@"Jid %@",[journeyArray objectForKey:@"journey_id"]);
           mRiderModel.journey_start=[journeyArray objectForKey:@"journey_start_point"];
           mRiderModel.journey_latitude=[journeyArray objectForKey:@"journey_start_latitude"];
           mRiderModel.journey_longitude=[journeyArray objectForKey:@"journey_start_longitude"];
           mRiderModel.journey_end_latitude=[journeyArray objectForKey:@"journey_end_latitude"];
           mRiderModel.journey_end_longitude=[journeyArray objectForKey:@"journey_end_longitude"];
            [riderListArray addObject:mRiderModel];
            
        }
        [self PlaceMarkersOnMap];
    }
    else{
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:@"No Co-riders!!"];
    }}else{
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:@"No Co-riders!!"];
    }
    
}
-(void)PlaceMarkersOnMap{
    NSLog(@"PlaceMarkersOnMap");
    
    for (CoRiderObject * model in riderListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_latitude doubleValue],[model.journey_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = myMap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:10];
        myMap.camera=cameraPosition;
    }
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alerted = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerted show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoriderListObject *model=[ridePassengerListArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
    NSString *name=[NSString stringWithFormat:@"%@      %@",model.index,model.name];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=name;
    return cell;
}


-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    
    return [ridePassengerListArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
    CoriderListObject *model=[ridePassengerListArray objectAtIndex:indexPath.row];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&profileId=%@",uId,model.user_id];
    NSData *passengerProfile=[ConnectToServer ServerCall:kServerLink_GetCoridersProfileById post:PostString];
    
    [self ShowPassengerProfileAlert:passengerProfile];

}

-(void) fetchPassengerProfile:(NSData*)responseData
{

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
            carModelField.text=[passDict objectForKey:@"car_model"];
            seatsField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"number_of_seats"]];
            sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
        }
     
       
    }
    
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
      NSString *markerTitle=[NSString stringWithFormat:@"%@",marker.title];
     NSLog(@"markerTitle%@",markerTitle);
    for (CoRiderObject * model in riderListArray)
    {
         NSString *ids=[NSString stringWithFormat:@"%@",model.journey_id];

        if([markerTitle isEqualToString:ids])
        {
            NSString * PostString = [NSString stringWithFormat:@"userId=%@&journeyId=%@",uId,model.journey_id];
            NSData *passList=[ConnectToServer ServerCall:kServerLink_GetCoridersProfile post:PostString];
            [self fetchPassengerList:passList];
        }
    
    }
    return  YES;
}



-(void) fetchPassengerList:(NSData*)responseData
{
    [ridePassengerListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Requested%@",data);
    if(!jsonParsingError)
    {
        NSArray *passenger=[data objectForKey:@"passengerList"];
        
        for(int pos=0;pos<[passenger count];pos++)
        {
            mRiderListModel=[[CoriderListObject alloc]init];
            NSDictionary *passDict=[passenger objectAtIndex:pos];
            mRiderListModel.user_id=[passDict objectForKey:@"user_id"];
            mRiderListModel.name=[passDict objectForKey:@"name"];
            NSLog(@"RequestedName%@",[passDict objectForKey:@"name"]);
            mRiderListModel.index=[NSString stringWithFormat:@"%i",pos+1];
            NSLog(@"RequestedIndex%@",[NSString stringWithFormat:@"%i",pos+1]);
            [ridePassengerListArray addObject:mRiderListModel];
        }
        
        [self.profileTable reloadData];
        [self ShowPassengerAlert];
    }

}

-(void)ShowPassengerAlert//:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action
{
    
    Alert = [[UIAlertView alloc ]initWithTitle:@"Co-riders List" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    CoriderProfiles *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"CoridersProfiles" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    [Alert show];
}

-(void)ShowPassengerProfileAlert:(NSData*)responseData//:(NSString*)from To:(NSString*)to TimeI:(NSString*)time NofSeats:(NSString*)noSeats ActiveDays:(NSString*)activeDays active:(NSString*)action
{
    
   Alerts = [[UIAlertView alloc ]initWithTitle:@"Co-riders  profile" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    CoridersSingleProfileView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"CoridersSingleProfileView" owner:self options:nil] objectAtIndex:0];
    
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 560)];
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alerts setValue:AccessoryView forKey:@"accessoryView"];
  
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
            carModelField.text=[passDict objectForKey:@"car_model"];
            favId=[passDict objectForKey:@"user_id"];
            seatsField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"number_of_seats"]];
            sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
        }
      }
    
    [Alerts show];
}

- (IBAction)addToFavs:(id)sender {
    NSLog(@"Favourites");
    NSString *favsPost=[NSString stringWithFormat:@"userId=%@&fave_user_id=%@",uId,favId];
    NSData *favs=[ConnectToServer ServerCall:kServerLink_AddToFavourites post:favsPost];
    [self favResponse:favs];
}

-(void)favResponse:(NSData*)responseData
{
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Requested%@",data);
    if(!jsonParsingError)
    {
        NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
        
        NSLog(@"Data %@",result);
        if([result isEqualToString:@"1"])
        {
          
            [self ShowAlertView:@"Requset processed!!"];
            
        }
        else if([result isEqualToString:@"0"]){
         
            [self ShowAlertView:@"Request Failed!!"];
        }
    }
    else{
        
        [self ShowAlertView:UnableToProcess];
    }

    
    }

- (IBAction)rating1:(id)sender {
     Rating=@"1";
     [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
}
- (IBAction)rating2:(id)sender {
     Rating=@"2";
    [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
}
- (IBAction)rating3:(id)sender {
     Rating=@"3";
    [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
}
- (IBAction)rating4:(id)sender {
     Rating=@"4";
    [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
}
- (IBAction)rating5:(id)sender {
     Rating=@"5";
    [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
    [self.GiverStar5 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
}
- (IBAction)submitAll:(id)sender {
    if([Rating isEqualToString:@"0"])
    {
        [self ShowAlertView:@"Select alteast one"];
    }
    else{
        NSString *RatePost=[NSString stringWithFormat:@"userId=%@&userIdRate=%@&rate=%@",uId,favId,Rating];
        NSData *rates=[ConnectToServer ServerCall:kServerLink_SaveRatings post:RatePost];
        [self favResponse:rates];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
