//
//  DetailRouteViewController.m
//  CarPooling
//
//  Created by atk's mac on 07/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "DetailRouteViewController.h"

@interface DetailRouteViewController ()<GMSMapViewDelegate,GMDraggableMarkerManagerDelegate>
{
    BOOL isUpdatingEnd;
    BOOL isUpdatingStart;
    NSString *start;
    NSString *end;
    NSString *origin;
    NSString *destination;
    NSString *OverViewPolyline;
    PolyLineDecoder *decoder;
    float zoom;
}
@end

@implementation DetailRouteViewController
@synthesize myMap,zoomIn,zoomOut;

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
     zoom=kGoogleMapsZoomLevelDefault;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    [super viewDidLoad];
    isUpdatingEnd=NO;
    isUpdatingStart=NO;
    searchListArray=[[NSMutableArray alloc]init];
    journeyListArray=[[NSMutableArray alloc]init];
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
    self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:myMap delegate:self];
   // [self ShowAlertView:self.journeyId];
  //  GMSCameraUpdate *a=[GMSCameraUpdate zoomIn];
    
    [self fetchMyRoutesFromServer];
    
}


-(void)ShowSubmitRouteAlertWithMessage:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    
    
    
    [Alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==1) {
        [self UpdateRouteToServer];
    }
    else{
        NSLog(@"Cancelled");
    }
}


-(void)fetchMyRoutesFromServer{
    [WTStatusBar setLoading:YES loadAnimated:YES];
   
    @try {
        NSString * PostString = [NSString stringWithFormat:@"journey_id=%@",self.journeyId];
        NSLog(@"postString %@",PostString);
        NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_JourneyPoints]];
        
        
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
    @catch (NSException *exception) {
        
    }
    @finally {
        NSLog(@"Inside Finally:Detail Route VC- fetch my routes from server");
    }
    
    
    
    
}
- (void)fetchedData:(NSData *)responseData {
    [journeyListArray removeAllObjects];
    
    NSError *jsonParsingError;
   
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
    GMSMutablePath *Polylinepaths= [GMSMutablePath path];
    
    for(int i=0;i<[data count]-1;i++)
    {
        mDetaileModel=[[DetailedRouteModel alloc]init];
        NSString *position= [NSString stringWithFormat:@"%i",i];
        NSDictionary *journeyArray=[data objectForKey:position];
        mDetaileModel.journey_id=[journeyArray objectForKey:@"journey_id"];
        mDetaileModel.break_id=[journeyArray objectForKey:@"break_id"];
        mDetaileModel.break_latitude=[journeyArray objectForKey:@"break_latitude"];
        mDetaileModel.break_longitude=[journeyArray objectForKey:@"break_longitude"];
         NSLog(@"Lats %@ and %@",mDetaileModel.break_latitude,mDetaileModel.break_longitude);
        [Polylinepaths addCoordinate:CLLocationCoordinate2DMake([mDetaileModel.break_latitude  doubleValue],[mDetaileModel.break_longitude doubleValue])];
          UIColor * Cblue =[UIColor colorWithRed:115.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
        GMSPolyline *rectangle = [GMSPolyline polylineWithPath:Polylinepaths];
        rectangle.strokeColor =Cblue;
        rectangle.strokeWidth = 3.f;
        rectangle.map = myMap;

        [journeyListArray addObject:mDetaileModel];
        
    }
    
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
    [self getStartLocation];
    [self getStopLocation];
}

-(void) getStartLocation {
    DetailedRouteModel * model = [journeyListArray objectAtIndex:0];
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[model.break_latitude doubleValue] longitude:[model.break_longitude doubleValue] zoom:kGoogleMapsZoomLevelDefault];
    myMap.camera=cameraPosition;
    self.starts=[model.break_latitude  stringByAppendingString:@","];
    self.starts=[self.starts stringByAppendingString:model.break_longitude];
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([model.break_latitude doubleValue],[model.break_longitude doubleValue]);
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Origin";
   // Marker.snippet=stops;
    // Marker.icon = [UIImage imageNamed:@"ridewithme_mobile_starttracker"];
    Marker.map  = self.myMap;
    
}
-(void)getStopLocation{
    NSString *lat;
    NSString *lng;
    for(int i=0;i<[journeyListArray count];i++)
    {
        DetailedRouteModel * model = [journeyListArray objectAtIndex:i];
      lat= model.break_latitude;
      lng= model.break_longitude;
      
    }
    self.stops=[lat  stringByAppendingString:@","];
    self.stops=[self.stops stringByAppendingString:lng];
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Destination";
   //  Marker.icon = [UIImage imageNamed:@"ridewithme_mobile_starttracker"];
    Marker.map  = self.myMap;
   
}

    
-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alert = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else
    {
        isUpdatingStart=YES;
        isUpdatingEnd=NO;
        NSLog(@"Origin Marker dragg ended");
        start=[NSString stringWithFormat:@"%f,%f",marker.position.latitude,marker.position.longitude];
        end=self.stops;
        [self fetchFromGoogleDirectionsApi:start end:end];
        
        
    }
    
}

// Calling DirectionAPI

-(void) fetchFromGoogleDirectionsApi:(NSString*)starts end:(NSString*)ends
{
    [myMap clear];
    if(isUpdatingEnd)
    {
        self.stops=ends;
    }
    else if (isUpdatingStart)
    {
        self.starts=starts;
    }
    NSLog(@"Origin=%@",starts);
    NSLog(@"Destina=%@",ends);
    decoder=[[PolyLineDecoder alloc]init];
    starts=[starts stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ends =[ends stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * PostString =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",starts,ends];
#define kSearchURL [NSURL URLWithString:PostString]
    dispatch_async(kBgQueue, ^{
        NSData *data= [NSData dataWithContentsOfURL:
                       kSearchURL];
        [self performSelectorOnMainThread:@selector(fetchedDataFromGoogleApi:)
                               withObject:data waitUntilDone:YES];
        
    });
    
    
}

- (void)fetchedDataFromGoogleApi:(NSData *)responseData
{
    
    NSError *jsonParsingError;
    NSDictionary *LocationData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:0 error:&jsonParsingError];
    //[self parseResponse:LocationData];
    NSArray *Route=[LocationData objectForKey:@"routes"];
    NSDictionary *RoutePos= [Route objectAtIndex:0];
    //Bounds
    //     NSDictionary *bounds= [RoutePos objectForKey:@"bounds"];
    //     NSDictionary *northEast= [bounds objectForKey:@"northeast"];
    //     NSString *nE_Latitude=[northEast objectForKey:@"lat"];
    //     NSString *nE_Longitude=[northEast objectForKey:@"lng"];
    //    NSDictionary *southWest= [bounds objectForKey:@"southwest"];
    //    NSString *sW_Latitude=[southWest objectForKey:@"lat"];
    //    NSString *sW_Longitude=[southWest objectForKey:@"lng"];
    NSArray *Legs=[RoutePos objectForKey:@"legs"];
    NSDictionary *legPos= [Legs objectAtIndex:0];
    
    //Start Points
    origin=[legPos objectForKey:@"start_address"];
    NSDictionary *startPoints= [legPos objectForKey:@"start_location"];
    NSString *start_Latitude=[startPoints objectForKey:@"lat"];
     NSString *start_Longitude=[startPoints objectForKey:@"lng"];
    
    // end points
    destination=[legPos objectForKey:@"end_address"];
    NSDictionary *stopPoints= [legPos objectForKey:@"end_location"];
     NSString *stop_Latitude=[stopPoints objectForKey:@"lat"];
     NSString *stop_Longitude=[stopPoints objectForKey:@"lng"];
    
    // [self setMapBounds:nE_Latitude nLng:nE_Longitude sLat:sW_Latitude sLng:sW_Longitude];
    [self getUpdatedStartLocation:origin lat:start_Latitude lng:start_Longitude];
    [self getUpdatedStopLocation:destination lat:stop_Latitude lng:stop_Longitude];
    [self parseResponseAndDrawPolyline:LocationData];
    
}

//Draws Driving routes
- (void)parseResponseAndDrawPolyline:(NSDictionary *)response {
    //NSMutableArray  *points= [[NSMutableArray alloc]init];
    //GMSMutablePath *Polylinepaths= [GMSMutablePath path];;
    
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        
        //Polyline Plotting
          UIColor * Cblue =[UIColor colorWithRed:115.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
        GMSPath *paths=[GMSPath pathFromEncodedPath:overviewPolyline];
        GMSPolyline *line=[GMSPolyline polylineWithPath:paths];
        line.strokeWidth = 3.f;
        line.strokeColor = Cblue;
        line.map=myMap;
        
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
            //            NSString *duplicate=[@"[" stringByAppendingString:latlngs];
            //            duplicate=[duplicate stringByAppendingString:@"]"];
            //  [points addObject:duplicate];
            
        }
        
        OverViewPolyline= [[NSString stringWithFormat:@"%@",searchListArray] stringByReplacingOccurrencesOfString:@"\\"
                                                                                                       withString:@""];
        
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"(" withString:@"["];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@")" withString:@"]"];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
        OverViewPolyline= [OverViewPolyline stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
        // [self ShowAlertView:OverViewPolyline];
        [self ShowSubmitRouteAlertWithMessage:@"Are You sure you want to update Route"];
        
    }
    
}

-(void) getUpdatedStartLocation:(NSString*)starts lat:(NSString*)lat lng:(NSString*)lng {
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[lat doubleValue] longitude:[lng doubleValue] zoom:kGoogleMapsZoomLevelDefault];
    myMap.camera=cameraPosition;
    
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Origin";
    Marker.snippet=starts;
    Marker.map  = self.myMap;
    
}
-(void)getUpdatedStopLocation:(NSString*)stops lat:(NSString*)lat lng:(NSString*)lng {
    
    
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Destination";
    Marker.snippet=stops;
    Marker.map  = self.myMap;
    
}

-(NSString*)formatOrigin:(NSString*)origins
{
    origins=[origins stringByReplacingOccurrencesOfString:@" " withString:@""];
    origins=[origins stringByReplacingOccurrencesOfString:@"UnnamedRoad," withString:@""];
    origins=[origins stringByReplacingOccurrencesOfString:@",India" withString:@""];
    origins=[NSString stringWithFormat:@"%@",origins];
    origins=[origins stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return origins;
    
}

-(NSString*)formatDest:(NSString*)destinations
{
    
    destinations=[destinations stringByReplacingOccurrencesOfString:@" " withString:@""];
    destinations=[destinations stringByReplacingOccurrencesOfString:@"UnnamedRoad," withString:@""];
    destinations=[destinations stringByReplacingOccurrencesOfString:@",India" withString:@""];
    destinations=[NSString stringWithFormat:@"%@",destinations];
    destinations=[destinations stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return destinations;
}
- (void)UpdateRouteToServer
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
  
    @try {
        NSUserDefaults *prefs;
        prefs = [NSUserDefaults standardUserDefaults];
        NSString *id=[prefs stringForKey:@"id"];
        NSLog(@" id %@",id);
        NSString *journeyId=self.journeyId;
        origin=[self formatOrigin:origin];
        destination=[self formatDest:destination];
        NSString * PostString = [NSString stringWithFormat:@"userId=%@&journeyId=%@&overview_path=%@&from=%@&to=%@",id,journeyId,OverViewPolyline,origin,destination];
        NSLog(@"postString %@",PostString);
        NSData *postData = [PostString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kServerLink_UpadteRoute]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
        
        dispatch_async(kBgQueue, ^{
            NSError *err;
            NSURLResponse *response;
            NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            if(!err)
            {
                [self performSelectorOnMainThread:@selector(updateRouteResponse:)
                                       withObject:data waitUntilDone:YES];
            }else{
                [self ShowAlertView:UnableToProcess];
                
            }
        });

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        NSLog(@"Inside ");
    }
    
    
    }

- (void)updateRouteResponse:(NSData *)responseData
{
    
    NSError *jsonParsingError;
    NSDictionary *UpdateResponseData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                   options:0 error:&jsonParsingError];
    
    NSLog(@"Add Response :%@",UpdateResponseData);
    if(!jsonParsingError || UpdateResponseData!=nil){
        NSString *status=[NSString stringWithFormat:@"%@",[UpdateResponseData objectForKey:@"status"]];
        if([status isEqualToString:@"1"])
        {
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"Route updated Successfully!!"];
            // [self performSegueWithIdentifier:@"toLogin" sender:nil];
            
        }
        else if([status isEqualToString:@"0"]){
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:@"Route updation Failed!!"];
        }}else{
             [self ShowAlertView:UnableToProcess];
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
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


@end
