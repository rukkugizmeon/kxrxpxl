//
//  CoRidersViewController.m
//  CarPooling
//
//  Created by atk's mac on 13/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "CoRidersViewController.h"
#import "CustomIOS7AlertView.h"
#import "BinSystemsServerConnectionHandler.h"
#import "InterfaceManager.h"


@interface CoRidersViewController ()<GMSMapViewDelegate>
{
    float zoom;
    
    CustomIOS7AlertView *coRidersListView ;
    StarRatingView * vRV;
    NSInteger favButtonFlag;
}
@end

@implementation CoRidersViewController
@synthesize myMap,nameField,ageField,cityField,addressField,sosContactField,SOSEmailField,phoneField,zoomIn,zoomOut;
@synthesize viewRating;
@synthesize buttonFavourite;
NSString *uId;
NSString *types;

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
     self.navigationItem.title = @"Co-Riders";
     self.navigationItem.hidesBackButton = YES;
    zoom=kGoogleMapsZoomLevelDefault;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    Rating=@"0";
    ConnectToServer=[[ServerConnection alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    uId=[prefs stringForKey:@"id"];
    types=[prefs stringForKey:@"role"];
    riderListArray=[[NSMutableArray alloc]init];
    ridePassengerListArray=[[NSMutableArray alloc]init];
    self.profileTable.backgroundColor=[UIColor clearColor];
    [self LoadMaps];
    one=0;
    
    
    
}
-(void)slider:(id)sender
{

    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
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
     GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
    myMap.camera=cameraPosition;
    [self fetchCoridersFromServer];
    
}
-(void)fetchCoridersFromServer
{
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
 //   @try {
        
        NSString * PostString = [NSString stringWithFormat:@"user_id=%@&journey_option=%@",uId,@"T"];
    
   BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoriders PostData:PostString];
    
   
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        [riderListArray removeAllObjects];
        
      
            
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            
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
            }
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load coriders"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    
    
   }

- (void)fetchedData:(NSData *)responseData {
    
    }
-(void)PlaceMarkersOnMap{
    NSLog(@"PlaceMarkersOnMap");
    
    for (CoRiderObject * model in riderListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_latitude doubleValue],[model.journey_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = myMap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
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
    NSString *name=[NSString stringWithFormat:@"%@",model.name];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
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
    
    [coRidersListView close];
    
    
    CoriderListObject *model=[ridePassengerListArray objectAtIndex:indexPath.row];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&profileId=%@",uId,model.user_id];
    
   BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoridersProfileById PostData:PostString];
    
    
    
    
    
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        
        
        //     NSMutableArray * Result = [JSONDict valueForKey:@"status"];
        
        
        
        
        [self ShowPassengerProfileAlert:data];
        
        
        
        
        
        
        
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load data"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    

    
    

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
            cityField.text=[passDict objectForKey:@"city"]; sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
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
              [WTStatusBar setLoading:YES loadAnimated:YES];
            
            
            NSString * PostString = [NSString stringWithFormat:@"userId=%@&journeyId=%@",uId,model.journey_id];
         
            
         BinSystemsServerConnectionHandler  *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoridersProfile PostData:PostString];
            
                        //specify method in first argument
            
            [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
                
                
                
                
                
                NSDictionary *data = JSONDict;
                
                if(data)
                {
                    [ridePassengerListArray removeAllObjects];
                    
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
                
                
                [WTStatusBar setLoading:NO loadAnimated:NO];
                
                [WTStatusBar clearStatus];
                
                
            } FailBlock:^(NSString *Error) {
                
                [InterfaceManager DisplayAlertWithMessage:@"Failed to load Details"];
                
                [WTStatusBar setLoading:NO loadAnimated:NO];
                
                [WTStatusBar clearStatus];
                
                
                
            }];
            

            
            
            
        }
    
    }
    return  YES;
}

-(void)ShowPassengerAlert
{
    
  
    AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"CoridersProfiles" owner:self options:nil] objectAtIndex:0];
//  
      [AccessoryView setBackgroundColor:[UIColor clearColor]];
;
    
    
    
    coRidersListView = [[CustomIOS7AlertView alloc] init];
    
    
    
    [coRidersListView setContainerView:AccessoryView];
    
    [coRidersListView show];
    
    
    
    
    
}

-(void)ShowPassengerProfileAlert:(NSDictionary*)data
{
    AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"CoridersSingleProfileView" owner:self options:nil] objectAtIndex:0];
    
    AccessoryView.hidden=NO;
    [AccessoryView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView.frame=CGRectMake(20,self.view.frame.origin.y+20,AccessoryView.frame.size.width-20,AccessoryView.frame.size.height);
    AccessoryView.layer.cornerRadius=5;
  
    NSLog(@"Requested%@",data);
    if(data)
    {
        NSArray *passengerProf=[data objectForKey:@"profile"];
        
        for(int pos=0;pos<[passengerProf count];pos++)
        {
            NSDictionary *passDict=[passengerProf objectAtIndex:pos];
            nameField.text=[passDict objectForKey:@"name"];
            ageField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"age"]];
            addressField.text=[passDict objectForKey:@"address"];
            cityField.text=[passDict objectForKey:@"city"];
            favId=[passDict objectForKey:@"user_id"];sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
            if ([passDict valueForKey:@"favourites"] == 0 ) {
                
                favButtonFlag=0;
                [buttonFavourite setImage:[UIImage imageNamed:@"add-Fav.jpg"] forState:UIControlStateNormal];
            }else{
                
                [buttonFavourite setImage:[UIImage imageNamed:@"favo"] forState:UIControlStateNormal];
                
            }
            
            
            
            
        }
      }
    vRV = [[StarRatingView alloc]initWithFrame:viewRating.frame andRating:68 withLabel:NO animated:YES];
    
    
    
    viewRating=vRV;
    
    
    [AccessoryView addSubview:viewRating];
    
    [myMap addSubview:AccessoryView];
   // [Alerts show];
}

- (IBAction)addToFavs:(UIButton*)sender {
    NSLog(@"Favourites");
    NSString *favsPost=[NSString stringWithFormat:@"userId=%@&fave_user_id=%@",uId,favId];
    NSData *favs=[ConnectToServer ServerCall:kServerLink_AddToFavourites post:favsPost];
    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_AddToFavourites PostData:favsPost];
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        if(data)
        {
            NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
            
            
            if([result isEqualToString:@"1"])
            {
                
                //   [self ShowAlertView:@"Request processed!!"];
                
                
                if (favButtonFlag==0) {
                    
                    
                    [buttonFavourite setImage:[UIImage imageNamed:@"favo"] forState:UIControlStateNormal];
                    
                    favButtonFlag=1;
                }else{
                    
                    [buttonFavourite setImage:[UIImage imageNamed:@"add-Fav.jpg"] forState:UIControlStateNormal];
                    
                    favButtonFlag=0;
                }
                
            }
            else if([result isEqualToString:@"0"]){
                
                // [self ShowAlertView:@"Request Failed!!"];
                
                
            }
        }
        else{
            
            [self ShowAlertView:UnableToProcess];
        }
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    
}


- (IBAction)submitAll:(id)sender {
    
    UIButton *buttonSelf = (UIButton *) sender;
    
    
    NSInteger rating = viewRating.myRating/20;
    
    if(rating==0)
    {
        [self ShowAlertView:@"Select alteast one"];
    }
    else{
        NSString *RatePost=[NSString stringWithFormat:@"userId=%@&userIdRate=%@&rate=%ld",uId,favId,(long)rating];
        
        
        
       [WTStatusBar setLoading:YES loadAnimated:YES];

       BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_SaveRatings PostData:RatePost];
        
                //specify method in first argument
        
        [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
            
            
            
            
            
            NSDictionary *data = JSONDict;
            
            NSString *status = [[data valueForKey:@"status"] stringValue];
            
            
            if ([status isEqualToString:@"1"]) {
                
                buttonSelf.userInteractionEnabled=NO;
                
                
            }
            
            [WTStatusBar setLoading:NO loadAnimated:NO];
            
            [WTStatusBar clearStatus];
            
            
            
            
            
            
            
        } FailBlock:^(NSString *Error) {
            
            
            
            [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
            
            
            
            [WTStatusBar setLoading:NO loadAnimated:NO];
            
            [WTStatusBar clearStatus];
            
            
            
        }];
        

        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)zoomIn:(id)sender {
    zoom=zoom+0.5f;
    [myMap animateToZoom:zoom];
}
- (IBAction)zoomOut:(id)sender {
    zoom=zoom-0.5f;
    [myMap animateToZoom:zoom];
}





- (IBAction)closeView:(id)sender {
    AccessoryView.hidden=YES;
}
@end
