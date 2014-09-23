//
//  MapViewController.m
//  CarPooling
//
//  Created by atk's mac on 25/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()<GMSMapViewDelegate,GMDraggableMarkerManagerDelegate>
{
    BOOL isUpdatingEnd;
    BOOL isUpdatingStart;
    NSString *journey_ids;
    NSString *GTuser_ids;
    NSString *GlobalpostString;
    UIAlertView * Alert ;
}

@end

@implementation MapViewController
@synthesize gAddressField,gAgeField,gCarModelField,gCityField,gMinDistField,gMinTimeField,gNameField,gSeatsField;
@synthesize mymap,LocationCoordinates,mNameField,mAgeField,mAddressField,mDriverImageField,minDistField,minTimeField,mIntervalPicker;
@synthesize submitButton,cancelButton,searchButton;
PolyLineDecoder *decoder;
ServerConnection *ConnectToServer;
NSString *start_Latitude;
NSString *start_Longitude;
NSString *stop_Latitude;
NSString *stop_Longitude;
NSString *origin;
NSString *destination;
NSString *OverViewPolyline;
NSString *start;
NSString *end;
NSString *uId;
NSString *types;
NSString *company;
NSString *distText;
NSString *durText;
NSMutableArray *days;
NSArray *options;
   float zoom;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
     self.addRouteButton.userInteractionEnabled=NO;
    options= @[@"12-1 AM", @"1-2 AM",@"2-3 AM", @"3-4 AM",@"4-5 AM",@"5-6 AM", @"6-7 AM", @"8-9 AM",@"9-10 AM", @"10-11 AM", @"11-12 AM",@"12-1 PM", @"1-2 PM",@"2-3 PM", @"3-4 PM",@"4-5 PM",@"5-6 PM", @"6-7 PM", @"8-9 PM",@"9-10 PM", @"10-11 PM",@"11-12 PM"];
    
    [mIntervalPicker selectRow:8 inComponent:0 animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   days = [NSMutableArray arrayWithObjects: @"Sunday", @"Monday", @"Tuesday", @"Wednesday",@"Thursday", @"Friday", @"Saturday", nil];
    zoom=kGoogleMapsZoomLevelDefault;
    
    self.seatsField.delegate=self;
    self.daysTable.layer.cornerRadius=5;
    mSelectedArray=[[NSMutableArray alloc]init];
    ConnectToServer=[[ServerConnection alloc]init];
    self.timeInterval=@"9-10 AM";
    isUpdatingEnd=NO;
    isUpdatingStart=NO;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    uId=[prefs stringForKey:@"id"];
    types=[prefs stringForKey:@"role"];
    company=[prefs stringForKey:@"company"];
    if([types isEqualToString:@"T"])
    {
        self.seatsField.hidden=YES;
        self.seatsLabel.hidden=YES;
   //     searchButton.hidden=YES;
    }
    else{
    //    searchButton.hidden=YES;
    }
    NSLog(@"id %@ type %@ options %@",uId,types,self.options);
    searchListArray=[[NSMutableArray alloc]init];

    [self LoadMaps];
   
   }

//Load Google Maps

-(void)LoadMaps
    {
        if([self.options isEqualToString:@"active_shedule"])
        {
            self.seatsField.hidden=YES;
            self.seatsLabel.hidden=YES;
            submitButton.hidden=YES;
            [self MoveDown];
            
        }
    mymap.delegate=self;
    mymap.myLocationEnabled = YES;
        [mymap addSubview:self.zoomIn];
        [mymap addSubview:self.zoomOut];
    [self.view addSubview:mymap];
      
    [mymap setMapType:kGMSTypeNormal];
      GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
        mymap.camera=cameraPosition;
       self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:mymap delegate:self];
        start=self.starts;
        end=self.stops;
        [self fetchFromGoogleDirectionsApi:start end:end];
    }

//Calling Directtions Api

-(void) fetchFromGoogleDirectionsApi:(NSString*)start end:(NSString*)end
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
     [mymap clear];
    if(isUpdatingEnd)
    {
        self.stops=end;
    }
    else if (isUpdatingStart)
    {
        self.starts=start;
    }
     NSLog(@"Origin=%@",start);
     NSLog(@"Destina=%@",end);
    decoder=[[PolyLineDecoder alloc]init];
    start=[start stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    end =[end stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * PostString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",start,end];
    #define kSearchURL [NSURL URLWithString:PostString]
    dispatch_async(kBgQueue, ^{
        NSError *err;
      //  NSURLResponse *response;
        NSData *data= [NSData dataWithContentsOfURL:
                       kSearchURL options:0 error:&err];
        if(!err)
        {
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        }  else{
             [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
               [self ShowAlertView:UnableToProcess];
            }
        
    });
    
   
}

//Parsing the response from google Directions APi
- (void)fetchedData:(NSData *)responseData
{
    
    NSError *jsonParsingError;
    NSDictionary *LocationData= [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0 error:&jsonParsingError];
    //[self parseResponse:LocationData];
     NSArray *Route=[LocationData objectForKey:@"routes"];
    NSDictionary *RoutePos= [Route objectAtIndex:0];

     NSArray *Legs=[RoutePos objectForKey:@"legs"];
     NSDictionary *legPos= [Legs objectAtIndex:0];
    
   //Start Points
    origin=[legPos objectForKey:@"start_address"];
    NSDictionary *startPoints= [legPos objectForKey:@"start_location"];
    start_Latitude=[startPoints objectForKey:@"lat"];
    start_Longitude=[startPoints objectForKey:@"lng"];
    
  // end points
    destination=[legPos objectForKey:@"end_address"];
    NSDictionary *stopPoints= [legPos objectForKey:@"end_location"];
    stop_Latitude=[stopPoints objectForKey:@"lat"];
    stop_Longitude=[stopPoints objectForKey:@"lng"];
  
   // [self setMapBounds:nE_Latitude nLng:nE_Longitude sLat:sW_Latitude sLng:sW_Longitude];
    [self getStartLocation:origin lat:start_Latitude lng:start_Longitude];
    [self getStopLocation:destination lat:stop_Latitude lng:stop_Longitude];
    [self parseResponseAndDrawPolyline:LocationData];
   // NSString  *sOption=@"";
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
  
    NSLog(@"***************************************");

}

// Searching Giver/Taker on a particular route

- (void)SearchMarkers:(NSData *)responseData {
     [WTStatusBar setLoading:YES loadAnimated:YES];
    [searchListArray removeAllObjects];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSString  *sOption=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSLog(@"Response %@",sOption);
    NSArray *routeArray=[data objectForKey:@"routes"];
    NSLog(@"Response %@",data);
    for(int i=0;i<[routeArray count];i++)
    {
        NSDictionary *main=[routeArray objectAtIndex:i];
        NSArray *routeSubArray=[main objectForKey:@"route"];
        for(int j=0;j<[routeSubArray count];j++)
        {
            mSearchModel=[[SearchRouteModel alloc] init];
            NSDictionary *journeyArray=[routeSubArray objectAtIndex:j];
        mSearchModel.journey_id=[journeyArray objectForKey:@"journey_id"];
        mSearchModel.user_id=[journeyArray objectForKey:@"user_id"];
        mSearchModel.journey_start=[journeyArray objectForKey:@"journey_start_point"];
        mSearchModel.journey_latitude=[journeyArray objectForKey:@"journey_start_latitude"];
        mSearchModel.journey_longitude=[journeyArray objectForKey:@"journey_start_longitude"];
        mSearchModel.journey_end_latitude=[journeyArray objectForKey:@"journey_end_latitude"];
        mSearchModel.journey_end_longitude=[journeyArray objectForKey:@"journey_end_longitude"];
        NSLog(@"JID %@",[journeyArray objectForKey:@"journey_id"]);
        [searchListArray addObject:mSearchModel];
        }}
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
    [self PlaceMarkersOnMap];
    
}

// Setting up the Search Markers
-(void)PlaceMarkersOnMap{
    
    NSLog(@"PlaceMarkersOnMap");
    
    for (SearchRouteModel * model in searchListArray) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([model.journey_latitude doubleValue],[model.journey_longitude doubleValue]);
        marker.icon = [UIImage imageNamed:@"marker"];
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = mymap;
        GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.journey_latitude doubleValue] longitude:[model.journey_longitude doubleValue] zoom:10];
        mymap.camera=cameraPosition;
    }
}

//Draws Driving routes
- (void)parseResponseAndDrawPolyline:(NSDictionary *)response {
    
    
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        
//Polyline Plotting
        
        GMSPath *paths=[GMSPath pathFromEncodedPath:overviewPolyline];
        GMSPolyline *line=[GMSPolyline polylineWithPath:paths];
         self.addRouteButton.userInteractionEnabled=YES;
        UIColor * Cgreen =[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        line.strokeWidth = 2.f;
        line.strokeColor = Cgreen;
        line.map=mymap;

// fethching points from overview polyline
        [path removeAllObjects];
        [searchListArray removeAllObjects];
        path = [decoder decodePolyLine:overviewPolyline];
        NSInteger numberOfSteps = path.count;
        NSString *latlngs;
        CLLocationCoordinate2D coordinates[numberOfSteps];
        for (NSInteger index = 0; index < numberOfSteps; index++) {
            CLLocation *location = [path objectAtIndex:index];
            CLLocationCoordinate2D coordinate = location.coordinate;
            coordinates[index] = coordinate;
            latlngs=[NSString stringWithFormat: @"{\"lat\":%f,\"lon\":%f}", location.coordinate.latitude,location.coordinate.longitude];
            [searchListArray addObject:latlngs];
          
      }
  
//Setting up the waypoint format to pass to server
        
       OverViewPolyline= [[NSString stringWithFormat:@"%@",searchListArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
        
    }
    NSInteger numberOfSteps = path.count/2;

    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        coordinates[index] = coordinate;
        
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:kGoogleMapsZoomLevelDefault];
    mymap.camera=cameraPosition;
    }
    if(![self.options isEqualToString:@"active_shedule"])
    {
        [self searchUsers];
    }
}


-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

//Marker Activities

-(void) setMapBounds:(NSString*)nLat nLng:(NSString*)nLng sLat:(NSString*)sLat sLng:(NSString*)sLng
{
  
    CLLocationCoordinate2D northeast = CLLocationCoordinate2DMake([nLat doubleValue],[nLng doubleValue]);
    CLLocationCoordinate2D soutwest = CLLocationCoordinate2DMake([sLat doubleValue],[sLng doubleValue]);
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:northeast coordinate:soutwest];
    GMSCameraPosition *camera = [mymap cameraForBounds:bounds insets:UIEdgeInsetsZero];
  
    mymap.camera = camera;
}

-(void) getStartLocation:(NSString*)starts lat:(NSString*)lat lng:(NSString*)lng {
   
  
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Origin";
    Marker.snippet=starts;
    
    Marker.map  = self.mymap;
    
}

-(void)getStopLocation:(NSString*)stops lat:(NSString*)lat lng:(NSString*)lng {
    
    
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Destination";
    Marker.snippet=stops;
    Marker.map  = self.mymap;
   
    
}
//Marker Activities ends


//Add route

-(void)addRouteToServer{
    [WTStatusBar setLoading:YES loadAnimated:YES];
   
    NSLog(@" type %@", types);
    NSString *activedaysFinal= [[NSString stringWithFormat:@"%@",mSelectedArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
    activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@")" withString:@"}"];
     NSString *noSeats=[types isEqualToString:@"T"]? @"0":self.seatsField.text;
    noSeats=[NSString stringWithFormat:@"%@",noSeats];
    origin=[self formatOrigin:origin];
    destination=[self formatDest:destination];
    
    NSString * PostString = [NSString stringWithFormat:@"userId=%@&startLatLong[1]=%@&startLatLong[0]=%@&endLatLong[1]=%@&endLatLong[0]=%@&routeType=%@&from=%@&to=%@&activeDays=%@&timeInterval=%@&seatsCount=%@&overview_path=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,types,origin,destination,activedaysFinal,self.timeInterval,noSeats,OverViewPolyline];
    NSLog(@"postString %@",PostString);
    NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_AddRoute]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if(!err)
        {
            [self performSelectorOnMainThread:@selector(addRouteResponse:)
                                   withObject:data waitUntilDone:YES];
        }else{
            [self ShowAlertView:UnableToProcess];
            
        }
    });
 }

//Submit rout alert

-(NSString*)formatOrigin:(NSString*)origin
{
    origin=[origin stringByReplacingOccurrencesOfString:@" " withString:@""];
    origin=[origin stringByReplacingOccurrencesOfString:@"UnnamedRoad," withString:@""];
     origin=[origin stringByReplacingOccurrencesOfString:@",India" withString:@""];
    origin=[NSString stringWithFormat:@"%@",origin];
    origin=[origin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return origin;
   
}

-(NSString*)formatDest:(NSString*)destination
{
    
    destination=[destination stringByReplacingOccurrencesOfString:@" " withString:@""];
    destination=[destination stringByReplacingOccurrencesOfString:@"UnnamedRoad," withString:@""];
    destination=[destination stringByReplacingOccurrencesOfString:@",India" withString:@""];
    destination=[NSString stringWithFormat:@"%@",destination];
     destination=[destination stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return destination;
}

-(void)ShowSubmitRouteAlertWithMessage:(NSString*)Message{
    
    UIAlertView * Alerts = [[UIAlertView alloc]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    
    
    
    [Alerts show];
}

// ***************** Alert View Delagates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Submit"]) {
         [self MoveUp];
        [self addRouteToServer];
    }
    else if ([title isEqualToString:@"Show route"])
    {
        [self drawPolylineAndMarker];
    }
    else if ([title isEqualToString:@"Cancel"]){
        [days removeAllObjects];
        [self.daysTable reloadData];
        [self MoveUp];
     //
    }
}

//Add route response

- (void)addRouteResponse:(NSData *)responseData
{
    [days removeAllObjects];
    [self.daysTable reloadData];
    self.addView.hidden=YES;
    NSError *jsonParsingError;
    NSDictionary *AddResponseData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:0 error:&jsonParsingError];
   
     NSLog(@"Add Response :%@",AddResponseData);
    if(!jsonParsingError || AddResponseData!=nil){
   NSString *status=[NSString stringWithFormat:@"%@",[AddResponseData objectForKey:@"status"]];
    if([status isEqualToString:@"1"])
    {
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:@"Route Added Successfull!!"];
       // [self performSegueWithIdentifier:@"toLogin" sender:nil];
        
    }
    else if([status isEqualToString:@"0"]){
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:@"Route Addition Failed!!"];
    }}else{
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
         [self ShowAlertView:UnableToProcess];
    }
}


-(void) drawPolylineAndMarker
{
     [self performSegueWithIdentifier:@"toUserDetailedRoute" sender:nil];
  
}

//Parsing Taker from search 
- (void)fetchedDriverData:(NSData *)responseData time:(NSString*)time dist:(NSString*)dist
{
   
    NSError *jsonParsingError;
    NSArray *DriverData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:0 error:&jsonParsingError];
    NSDictionary *DataPos= [DriverData objectAtIndex:0];
    NSString *name=[DataPos objectForKey:@"name"];
    NSString *age=[DataPos objectForKey:@"age"];
    age=[NSString stringWithFormat:@"%@",age];
    NSString *address=[DataPos objectForKey:@"address"];
    NSString *rating=[DataPos objectForKey:@"rate"];
    rating=[NSString stringWithFormat:@"%@",rating];
      NSLog(@"DriverData%@",name);
    [self ShowUserRouteDataAlert:name age:age address:address time:time dist:dist rate:rating];
}
                    
- (void)fetchedGiverData:(NSData *)responseData time:(NSString*)time dist:(NSString*)dist
                {
                    
                    NSError *jsonParsingError;
                    NSArray *DriverData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0 error:&jsonParsingError];
                    NSLog(@"DriverData%@",DriverData);
                    NSDictionary *DataPos= [DriverData objectAtIndex:0];
                    NSString *name=[DataPos objectForKey:@"name"];
                    NSString *age=[DataPos objectForKey:@"age"];
                    age=[NSString stringWithFormat:@"%@",age];
                    NSString *address=[DataPos objectForKey:@"address"];
                    NSString *city=[DataPos objectForKey:@"city"];
                    NSString *car_model=[DataPos objectForKey:@"car_model"];
                    car_model=[NSString stringWithFormat:@"%@",car_model];
                    NSString *seats=[DataPos objectForKey:@"number_of_seats"];
                    seats=[NSString stringWithFormat:@"%@",seats];
                    NSString *rating=[DataPos objectForKey:@"rate"];
                    rating=[NSString stringWithFormat:@"%@",rating];
                    NSLog(@"DriverData%@",name);
                    [self ShowGiverRouteDataAlert:name age:age address:address NofSeats:seats city:city model:car_model time:time dist:dist rate:rating];
                }


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    if(![marker.title isEqualToString:@"Destination"] && ![marker.title isEqualToString:@"Origin"])
    {
        for (SearchRouteModel * model in searchListArray)
        {
            journey_ids=[NSString stringWithFormat:@"%@",model.journey_id];
            GTuser_ids=[NSString stringWithFormat:@"%@",model.user_id];
            if([marker.title isEqualToString:journey_ids])
            {
                blockingId=model.user_id;
                //Distance api call
                self.start_marker_lat=model.journey_latitude;
                self.start_marker_lng=model.journey_longitude;
                NSString *st_latlng=[NSString stringWithFormat:@"%@,%@",model.journey_latitude,model.journey_longitude];
                NSString *end_latlng=[NSString stringWithFormat:@"%@,%@",start_Latitude,start_Longitude];
                NSLog(@"starts%@",st_latlng);
                 NSLog(@"stops%@",end_latlng);
                NSString * DistancePostString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@",st_latlng,end_latlng];
                #define kSearchURLs [NSURL URLWithString:DistancePostString]
                dispatch_async(kBgQueue, ^{
                    NSData *data= [NSData dataWithContentsOfURL:
                                   kSearchURLs];
                    [self performSelectorOnMainThread:@selector(DistanceData:)
                                           withObject:data waitUntilDone:YES];
                    
                });

                GlobalpostString=[NSString stringWithFormat:@"userId=%@&journeyId=%@",uId,journey_ids];
                
                
            }
        }
        
    }
    
	return YES;
}

-(void) DistanceData:(NSData*)responseData
{
    NSError *jsonParsingError;
    NSDictionary *RouteDistance= [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
 //   NSLog(@"Distance Api%@",RouteDistance);
    NSArray *Rows= [RouteDistance objectForKey:@"rows"];
    NSDictionary *rowPos=[Rows objectAtIndex:0];
    NSArray *Elements= [rowPos objectForKey:@"elements"];
    NSDictionary *elementPos=[Elements objectAtIndex:0];
    NSDictionary *distance=[elementPos objectForKey:@"distance"];
    distText=[distance objectForKey:@"text"];
    NSDictionary *duration=[elementPos objectForKey:@"duration"];
    durText=[duration objectForKey:@"text"];
    NSData *driverData=[ConnectToServer ServerCall:kServerLink_GTDetails post:GlobalpostString];
    if([types isEqualToString:@"G"])
    {
        [self fetchedDriverData:driverData time:distText dist:durText];
    }else
    {
        [self fetchedGiverData:driverData time:distText dist:durText];
    }

   
    
}
-(void)MoveUp
{
    self.zoomIn.hidden=NO;
    self.zoomOut.hidden=NO;
      self.addRouteButton.userInteractionEnabled=YES;
    const int movementDistance = 500; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    bool up=YES;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.addView.frame = CGRectOffset(self.addView.frame, 0, movement);
    [UIView commitAnimations];
      //self.addView.hidden=YES;
}
-(void)MoveDown
{
    self.zoomIn.hidden=YES;
    self.zoomOut.hidden=YES;
    self.addRouteButton.userInteractionEnabled=YES;
    const int movementDistance = 498; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    bool up=YES;
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.addView.frame = CGRectOffset(self.addView.frame, 0, movement);
    [UIView commitAnimations];
    self.addView.hidden=NO;
    [mymap addSubview:self.addView];
    [mymap bringSubviewToFront:self.addView];
    //self.addView.hidden=YES;
}
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
  if([marker.title isEqualToString:@"Origin"])
  {
      NSLog(@"Origin Marker dragged");
  }
  else
  {
   NSLog(@"Dest Marker dragged");
  }
}

//*************ADD route button*********

- (IBAction)addRouteAction:(id)sender {
    self.addRouteButton.userInteractionEnabled=NO;
    searchButton.hidden=YES;
    submitButton.hidden=NO;
    [self.daysTable reloadData];
    [self MoveDown];
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
   // NSLog(@">>> mapView:didDragMarker: %@", [marker description]);
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
   
    if([marker.title isEqualToString:@"Destination"])
    {
        isUpdatingEnd=YES;
        isUpdatingStart=NO;
        end=[NSString stringWithFormat:@"%f,%f",marker.position.latitude,marker.position.longitude];
        start=self.starts;
        [self fetchFromGoogleDirectionsApi:start end:end];
      
    }
    else if([marker.title isEqualToString:@"Origin"])
    {
        isUpdatingStart=YES;
        isUpdatingEnd=NO;
        NSLog(@"Origin Marker dragg ended");
        start=[NSString stringWithFormat:@"%f,%f",marker.position.latitude,marker.position.longitude];
        end=self.stops;
        [self fetchFromGoogleDirectionsApi:start end:end];
     }
    
}

- (void)mapView:(GMSMapView *)mapView didCancelDraggingMarker:(GMSMarker *)marker
{
   
}

-(void)ShowUserRouteDataAlert:(NSString*)name age:(NSString*)age address:(NSString*)address  time:(NSString*)time dist:(NSString*)dist rate:(NSString*)rating //ActiveDays:(NSString*)activeDays active:(NSString*)action
{
    
   Alert = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Show route", nil];
    
    UserDataView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"UserDataView" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    mNameField.text=name;
    mAgeField.text=age;
    mAddressField.text=address;
        minTimeField.text=time;
        minDistField.text=dist;
     [self ratingTaker:rating];
        NSLog(@"Type=%@ =Dist%@,Time%@ ",types,distText,durText);
  
    // Set Values

    [Alert show];
}

-(void)ShowGiverRouteDataAlert:(NSString*)name age:(NSString*)age address:(NSString*)address NofSeats:(NSString*)noSeats city:(NSString*)city model:(NSString*)model  time:(NSString*)time dist:(NSString*)dist rate:(NSString*)rate
{
    
    Alert = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Show route", nil];
    
    GiverDataView *AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"View" owner:self options:nil] objectAtIndex:0];
    
    [AccessoryView setBackgroundColor:[UIColor clearColor]];
    
    [Alert setValue:AccessoryView forKey:@"accessoryView"];
    gMinTimeField.text=dist;
    gMinDistField.text=time;
    NSLog(@"Type=%@ =Dist%@,Time%@ ",types,distText,durText);
    gNameField.text=name;
    gAgeField.text=age;
    gAddressField.text=address;
    gSeatsField.text=noSeats;
    gCityField.text=city;
    gCarModelField.text=model;
    [self ratingGiver:rate];
    
    [Alert show];
}
-(void)ratingGiver:(NSString*)rates
{
   int rate=[rates intValue];
    switch (rate) {
        case 1:
           [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [self.GiverStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
             [self.GiverStar5 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
//Rating taker

-(void)ratingTaker:(NSString*)rates
{
    int rate=[rates intValue];
    switch (rate) {
        case 1:
            [self.TakerStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.TakerStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.TakerStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.GiverStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.TakerStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [self.TakerStar1 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar2 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar3 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar4 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            [self.TakerStar5 setImage:[UIImage imageNamed: @"starhighlighted.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


//
- (void)UserRoute:(NSData *)responseData {
    NSLog(@"Plotting polyline");
    NSError *jsonParsingError;
    NSString *break_latitude;
    NSString *break_longitude;
    GMSMutablePath *Polylinepaths= [GMSMutablePath path];
    GMSMarker *marker= [[GMSMarker alloc] init];
    GMSPolyline *userRoute ;
    UIColor * Cblue =[UIColor colorWithRed:115.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    
    NSArray *routeArray=[data objectForKey:@"routes"];
    for(int i=0;i<[routeArray count];i++)
    {
        NSDictionary *main=[routeArray objectAtIndex:i];
        NSArray *routeSubArray=[main objectForKey:@"route"];
        for(int j=0;j<[routeSubArray count];j++)
        {
            NSDictionary *journeyArray=[routeSubArray objectAtIndex:j];
            break_latitude=[journeyArray objectForKey:@"break_latitude"];
            break_longitude=[journeyArray objectForKey:@"break_longitude"];
            NSLog(@"Lat=%@ Long=%@",break_latitude,break_longitude);
            [Polylinepaths addCoordinate:CLLocationCoordinate2DMake([break_latitude  doubleValue],[break_longitude doubleValue])];
            userRoute = [GMSPolyline polylineWithPath:Polylinepaths];
            userRoute.zIndex=1;
            userRoute.strokeColor = Cblue;
            userRoute.strokeWidth = 3.f;
            userRoute.map = mymap;
            
          }
    }
    marker.position = CLLocationCoordinate2DMake([break_latitude doubleValue],[break_longitude doubleValue]);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.map=mymap;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUserDetailedRoute"]) {
        SearchRouteViewController *serVC = segue.destinationViewController;
        serVC.postString=GlobalpostString;
        serVC.starts=self.starts;
        serVC.stops=self.stops;
        serVC.start_marker_lat=self.start_marker_lat;
        serVC.start_marker_lng=self.start_marker_lng;
    }
}

- (IBAction)mRequestButton:(id)sender {
    NSLog(@"request");
  
        NSString *postString=[NSString stringWithFormat:@"userId=%@",uId];
        NSData *earnings=[ConnectToServer ServerCall:kServerLink_GetEarnings post:postString];
        [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
        [self fetchedEarningsData:earnings];
    
    

   }
- (IBAction)mBlockButton:(id)sender {
         NSLog(@"Block");
    NSString *postString=[NSString stringWithFormat:@"blockUserId=%@&blockedByUserId=%@",blockingId,uId];
    NSData *response=[ConnectToServer ServerCall:kServerLink_BlockUser post:postString];
    [self blockedResponse:response];
}
- (IBAction)gRequestButton:(id)sender {
    
    NSLog(@"request");
        NSString *postString=[NSString stringWithFormat:@"userId=%@",uId];
        NSData *earnings=[ConnectToServer ServerCall:kServerLink_GetEarnings post:postString];
         [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
        [self fetchedEarningsData:earnings];
    

}
- (IBAction)gBlockButton:(id)sender {
    NSString *postString=[NSString stringWithFormat:@"blockUserId=%@&blockedByUserId=%@",blockingId,uId];
    NSData *response=[ConnectToServer ServerCall:kServerLink_BlockUser post:postString];
    [self blockedResponse:response];
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)fetchedEarningsData:(NSData *)responseData {
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    NSString *earnings=[NSString stringWithFormat:@"%@",[data objectForKey:@"Earnings"]];
    NSString *st_latlng=[NSString stringWithFormat:@"%@,%@",start_Latitude,start_Longitude];
    NSString *end_latlng=[NSString stringWithFormat:@"%@,%@",stop_Latitude,stop_Longitude];
    NSString * DistancePostString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@",st_latlng,end_latlng];
    float distance=[ConnectToServer DistanceDatas:DistancePostString];
    int cost=10;
    NSLog(@"Data %@",result);
    if([result isEqualToString:@"No data found"])
    {
      
        
        [self ShowAlertView:@"Insufficient ride points!!"];
        
        
        
    }
    else if(earnings!=nil){
       // NSString *value=[@"Your Earnings :" stringByAppendingString:earnings];
        int Minridepooints=distance*cost+(distance*cost)*10/100;
        int ridePoint=[earnings intValue];
        NSLog(@"Distance %i & %i",Minridepooints,ridePoint);
        if(ridePoint>=Minridepooints)
        {
            NSString *postString=[NSString stringWithFormat:@"userId=%@&journeyId=%@&ownerId=%@",uId,journey_ids,GTuser_ids];
            NSData *request=[ConnectToServer ServerCall:kServerLink_journeyRequest post:postString];
            [self requestData:request];
        }else{
        
            [self ShowAlertView:@"Insufficient RidePoints!!"];
        }
    }
    
}
-(void)requestData:(NSData *)responseData {
    NSLog(@"Processing response");
    //  NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    if([result isEqualToString:@"success"])
    {
        [self ShowAlertView:@"Your interest in co-rider is communicated. Please wait for their confirmation"];
    }
    else
    {
     [self ShowAlertView:@"Request cannot be sent now! Please try later!"];
    }
}

-(void)blockedResponse:(NSData *)responseData {
    NSLog(@"Processing response");
    NSLog(@"Data %@",responseData);
    NSError *jsonParsingError;
    if(!jsonParsingError)
    {
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    if([result isEqualToString:@"1"])
    {
        [self ShowAlertView:@"User blocked"];
    }
    else
    {
        [self ShowAlertView:UnableToProcess];
    }
    }
    else
    {
        [self ShowAlertView:UnableToProcess];
    }
}
- (IBAction)cancelAdding:(id)sender {
    [self MoveUp];
}




- (IBAction)addRouteSUbmission:(id)sender {
    NSLog(@"Array val %@",mSelectedArray);
    if(mSelectedArray.count>0){
        if(self.seatsField.hasText || [types isEqualToString:@"T"] ){
      
            [self ShowSubmitRouteAlertWithMessage:@"Are you sure you want to submit the route?"];
        }else
        {
        [self ShowAlertView:@"Please enter no:of seats"];
        }
    
    }
    else{
        [self ShowAlertView:@"Please select days"];
    }
}

//Table delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text = [days objectAtIndex:indexPath.row];
  
    
    return cell;
}

#pragma mark UITableViewDelegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
       
         [mSelectedArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    else
    {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [mSelectedArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
        return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.seatsField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
        [self animateTextField: textField up: YES];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
        [self animateTextField: textField up: NO];
    
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 55; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//picker

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Verdana" size:16]];
        [tView setTextAlignment:UITextAlignmentCenter];
    }
    

        tView.text=[options objectAtIndex:row];
    
    return tView;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
        return options.count;
   
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
        return options[row];
   
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
        
        self.timeInterval= options[row];
        NSLog(@"Selected = %@",self.timeInterval);
    
}

- (IBAction)zoomOut:(id)sender {
    zoom=zoom-0.5f;
    [mymap animateToZoom:zoom];
}
- (IBAction)zoomIn:(id)sender {
    zoom=zoom+0.5f;
    [mymap animateToZoom:zoom];
}

-(void)searchUsers
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    NSString *activedaysFinal;
    if([self.options isEqualToString:@"same_company"])
    {
        self.options=company;
        activedaysFinal=@"";
        self.timeInterval=@"";
    }
    else if([self.options isEqualToString:@"active_shedule"])
    {
        activedaysFinal = [[NSString stringWithFormat:@"%@",mSelectedArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
        activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@")" withString:@"}"];
    }
    else
    {
        activedaysFinal=@"";
        self.timeInterval=@"";
    }
    if([types isEqualToString:@"G"])
    {
        
        NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchoption=%@&active_shedule_time=%@&&active_shedule_days=%@&type=%@&companyName=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,self.options,activedaysFinal,self.timeInterval,@"T",company];
        NSData *searchData=[ConnectToServer ServerCall:kServerLink_SearchRoute post:postString];
        [self SearchMarkers:searchData];
    }
    else if([types isEqualToString:@"T"])
    {
        //        NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchoption=%@&type=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,sOption,@"G"];
        NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchoption=%@&active_shedule_time=%@&&active_shedule_days=%@&type=%@&companyName=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,self.options,activedaysFinal,self.timeInterval,@"G",company];
        NSData *searchData=[ConnectToServer ServerCall:kServerLink_SearchRoute post:postString];
        [self SearchMarkers:searchData];
    }
}

- (IBAction)searchUsers:(id)sender {
    [self MoveUp];
    [self searchUsers];
}




@end
