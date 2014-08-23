//
//  RequestSentViewController.m
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RequestSentViewController.h"

@interface RequestSentViewController ()<GMSMapViewDelegate>

@end

@implementation RequestSentViewController
@synthesize myMap,scrollView,nameField,ageField,cityField,addressField,carModelField,sosContactField,SOSEmailField,phoneField,seatsField,views;
NSString *uId;
NSString *types;
@synthesize starRating;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:26.90083 longitude:76.35371 zoom:8];
    myMap.camera=cameraPosition;
    [self fetchMyRoutesFromServer];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Cancel"]) {
        [self performSelector:@selector(dismiss:) withObject:Alerts afterDelay:1.0];
        
    }}

-(void)fetchMyRoutesFromServer{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString * PostString = [NSString stringWithFormat:@"userId=%@",uId];
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_journeyRequestSent]];
    
    
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
            
            [self ShowAlertView:@"Unable to process request!!"];
        }
        
    });
}

-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

- (void)fetchedData:(NSData *)responseData {
    
    [reqListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
   

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
            [reqListArray addObject:mRequestModel];
            
        }
           [self PlaceMarkersOnMap];
        }
        else{
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
             [self ShowAlertView:@"No Requests Sent"];
        }
     
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
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:10];
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
    NSData *passengerProfile=[ConnectToServer ServerCall:kServerLink_GetCoridersProfileById post:PostString];
    [self ShowPassengerProfileAlert:passengerProfile];
        }}
    return  YES;
}

 -(void)ShowPassengerProfileAlert:(NSData*)responseData
{
    
    Alerts = [[UIAlertView alloc ]initWithTitle:@"Profile" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    RequestSentView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"RequestSentView" owner:self options:nil] objectAtIndex:0];
    
    
    [scrollView setScrollEnabled:YES];
   
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
            favId=[passDict objectForKey:@"user_id"];
            if([types isEqualToString:@"T"])
            {
             seatsField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"number_of_seats"]];
            carModelField.text=[passDict objectForKey:@"car_model"];
                 [scrollView setContentSize:CGSizeMake(300, 550)];
            }
            else if([types isEqualToString:@"G"]){
                self.model.hidden=YES;
                self.seat.hidden=YES;
                seatsField.hidden=YES;
                carModelField.hidden=YES;
                const int movementDistance = 75; // tweak as needed
                const float movementDuration = 0.1f; // tweak as needed
                bool up=YES;
                int movement = (up ? -movementDistance : movementDistance);
                
                [UIView beginAnimations: @"anim" context: nil];
                [UIView setAnimationBeginsFromCurrentState: YES];
                [UIView setAnimationDuration: movementDuration];
                views.frame = CGRectOffset(views.frame, 0, movement);
                [UIView commitAnimations];
                 [scrollView setContentSize:CGSizeMake(300, 500)];
            }
            sosContactField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"sos_contact_num"]];
            SOSEmailField.text=[passDict objectForKey:@"sos_email_id"];
            phoneField.text=[NSString stringWithFormat:@"%@",[passDict objectForKey:@"mobile_number"]];
            
        }
    }
    
    [Alerts show];
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
        
        [self ShowAlertView:@"Unable to process the request"];
    }
    
    
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
