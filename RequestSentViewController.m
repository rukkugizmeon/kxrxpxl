//
//  RequestSentViewController.m
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RequestSentViewController.h"
#import "CustomIOS7AlertView.h"
#import "InterfaceManager.h"
#import "BinSystemsServerConnectionHandler.h"


@interface RequestSentViewController ()<GMSMapViewDelegate>
{
    float zoom;
}
@end

@implementation RequestSentViewController
@synthesize myMap,scrollView,nameField,ageField,cityField,addressField,carModelField,sosContactField,SOSEmailField,phoneField,seatsField,views;
NSString *uId;
NSString *types;
@synthesize starRating,zoomOut,zoomIn;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    if( [control isEqual:starRating] )
        NSLog(@"Rating%@",ratingString);
    else
        NSLog(@"Rating%@",ratingString);
}
-(void)slider:(id)sender
{
   
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title = @"Request Sent";
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
        self.navigationItem.hidesBackButton = YES;
    zoom=kGoogleMapsZoomLevelDefault;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    ConnectToServer=[[ServerConnection alloc]init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    uId=[prefs stringForKey:@"id"];
    types=[prefs stringForKey:@"role"];
    reqListArray=[[NSMutableArray alloc]init];
    starRating.backgroundImage=[UIImage imageNamed:@"starsbackground iOS.png"];
    starRating.starImage = [UIImage imageNamed:@"star.png"];
    starRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12;
    starRating.editable=YES;
    starRating.rating= 2;
    starRating.displayMode=EDStarRatingDisplayAccurate;
    [self starsSelectionChanged:starRating rating:2.5];
    // This one will use the returnBlock instead of the delegate
    starRating.returnBlock = ^(float rating )
    {
        NSLog(@"ReturnBlock: Star rating changed to %.1f", rating);
        // For the sample, Just reuse the other control's delegate method and call it
        [self starsSelectionChanged:starRating rating:rating];
    };
     [self LoadMaps];   
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


-(void)fetchMyRoutesFromServer{
    [WTStatusBar setLoading:YES loadAnimated:YES];
   

        NSString * PostString = [NSString stringWithFormat:@"userId=%@",uId];
  

   BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_journeyRequestSent PostData:PostString];
    
    
    //specify method in first argument
    
    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
        
        
        
        
        
        NSDictionary *data = JSONDict;
        
        [reqListArray removeAllObjects];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        
        NSArray *requestObj=[data objectForKey:@"requests"];
        NSInteger count=[requestObj count];
        if(count>0)
        {
            
            for(int i=0;i<[requestObj count];i++)
            {
                
                
                mRequestModel=[[RecievedReqModel alloc] init];
                NSDictionary *route=[requestObj objectAtIndex:i];
                NSString *status=[NSString stringWithFormat:@"%@",[route objectForKey:@"status"]];
                mRequestModel.status=status;
                NSDictionary *journeyArray=[route objectForKey:@"route"];
                mRequestModel.journey_id=[journeyArray objectForKey:@"journey_id"];
                mRequestModel.user_id=[journeyArray objectForKey:@"user_id"];
                NSLog(@"Jid %@",[journeyArray objectForKey:@"journey_id"]);
                mRequestModel.journey_start=[journeyArray objectForKey:@"journey_start_point"];
                mRequestModel.journey_latitude=[journeyArray objectForKey:@"journey_start_latitude"];
                mRequestModel.journey_longitude=[journeyArray objectForKey:@"journey_start_longitude"];
                mRequestModel.journey_end_latitude=[journeyArray objectForKey:@"journey_end_latitude"];
                mRequestModel.journey_end_longitude=[journeyArray objectForKey:@"journey_end_longitude"];
                
                //            if (mRequ) {
                //
                //
                [reqListArray addObject:mRequestModel];
                //
                //            }
                //
                //
                
            }
            [self PlaceMarkersOnMap];
        }
        else{
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"No Requests Sent"];
        }
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
        
        
        
        
    } FailBlock:^(NSString *Error) {
        
        
        
        [InterfaceManager DisplayAlertWithMessage:@"Failed to load requests"];
        
        
        
        [WTStatusBar setLoading:NO loadAnimated:NO];
        
        [WTStatusBar clearStatus];
        
        
        
    }];
    

    }

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}





-(void)PlaceMarkersOnMap{
    NSLog(@"PlaceMarkersOnMap");
    
    for (RecievedReqModel * model in reqListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_latitude doubleValue],[model.journey_longitude doubleValue]);
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        if([model.status isEqualToString:@"A"])
        {
         marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        }
        marker.map = myMap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
        myMap.camera=cameraPosition;
    }
    
    
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    
    
    NSString *markerTitle=[NSString stringWithFormat:@"%@",marker.title];
    NSLog(@"JID %@",markerTitle);
    for (RecievedReqModel * model in reqListArray)
    {  NSString *id=[NSString stringWithFormat:@"%@",model.journey_id];
        if([markerTitle isEqualToString:id])
        {
            
            
            
            
            
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&profileId=%@",uId,model.user_id];
  
            
            
            [WTStatusBar setLoading:YES loadAnimated:YES];
            
           BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_GetCoridersProfileById PostData:PostString];
            
                //specify method in first argument
            
            [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
                      
                NSDictionary *data = JSONDict;
                
                [self ShowPassengerProfileAlert:data];
                
                
                [WTStatusBar setLoading:NO loadAnimated:NO];
                
                [WTStatusBar clearStatus];
                
                
                
            } FailBlock:^(NSString *Error) {
                
                
                
                [InterfaceManager DisplayAlertWithMessage:@"Failed to load routes"];
                
                
                
                [WTStatusBar setLoading:NO loadAnimated:NO];
                
                [WTStatusBar clearStatus];
                
                
                
            }];
            

            
            
        }
    
    }
    
    
    
    
    
    return  YES;
    
}

 -(void)ShowPassengerProfileAlert:(NSDictionary *)data
{
    
    
    
    AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"RequestSentView" owner:self options:nil] objectAtIndex:0];
    AccessoryView.hidden=NO;
    [AccessoryView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView.frame=CGRectMake(15,self.view.frame.origin.y+20,self.view.frame.size.width-40,self.view.frame.size.height-60);
    AccessoryView.layer.cornerRadius=5;
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(300, 500)];
    
 
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
            favId=[passDict objectForKey:@"user_id"];
            if([types isEqualToString:@"T"])
            {
                
             seatsField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"number_of_seats"]];
            carModelField.text=[passDict objectForKey:@"car_model"];
           
            }
            else if([types isEqualToString:@"G"]){
                
                self.model.hidden=YES;
                self.seat.hidden=YES;
                seatsField.hidden=YES;
                carModelField.hidden=YES;
                const int movementDistance = 100; // tweak as needed
                const float movementDuration = 0.1f; // tweak as needed
                bool up=YES;
                int movement = (up ? -movementDistance : movementDistance);
                
                [UIView beginAnimations: @"anim" context: nil];
                [UIView setAnimationBeginsFromCurrentState: YES];
                [UIView setAnimationDuration: movementDuration];
                views.frame = CGRectOffset(views.frame, 0, movement);
                [UIView commitAnimations];
                 [scrollView setContentSize:CGSizeMake(300,350)];
                 AccessoryView.frame=CGRectMake(15,self.view.frame.origin.y+20,self.view.frame.size.width-40,self.view.frame.size.height-180);
                
            }
            
            sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
        }
    }
    
   
    [myMap addSubview:AccessoryView];
   // [Alerts show];
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
- (IBAction)addToFavs:(id)sender {
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

- (IBAction)zoomOut:(id)sender {
    zoom=zoom-0.5f;
    [myMap animateToZoom:zoom];
}
- (IBAction)zoomIn:(id)sender {
    zoom=zoom+0.5f;
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
    [AccessoryView setHidden:YES];
}
@end
