//
//  SearchRouteViewController.m
//  CarPooling
//
//  Created by atk's mac on 08/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "SearchRouteViewController.h"

@interface SearchRouteViewController ()<GMSMapViewDelegate,GMDraggableMarkerManagerDelegate>

@end

@implementation SearchRouteViewController
@synthesize myMap,postString,zoomOut,zoomIn;
float zoom;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadMaps];
    zoom=kGoogleMapsZoomLevelDefault;
    [myMap addSubview:zoomOut];
    [myMap addSubview:zoomIn];
    ServerConnection *ConnectToServer=[[ServerConnection alloc]init];
    NSData *driverPolyLine=[ConnectToServer ServerCall:kServerLink_UserPolyline post:postString];
    [self UserRoute:driverPolyLine];
    GMSMarker *marker= [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.start_marker_lat doubleValue],[self.start_marker_lng doubleValue]);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.map=myMap;
    
}

-(void)LoadMaps
{
    myMap.delegate=self;
    myMap.myLocationEnabled = YES;
    [self.view addSubview:myMap];
    [myMap setMapType:kGMSTypeNormal];
     GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
    self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:myMap delegate:self];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            userRoute.map = myMap;
            
        }
    }

    marker.position = CLLocationCoordinate2DMake([break_latitude doubleValue],[break_longitude doubleValue]);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.map=myMap;
    [self CameraPos:responseData];
}

-(void) CameraPos:(NSData *)responseData
{
      NSError *jsonParsingError;
    NSString *break_latitude1;
    NSString  *break_longitude1;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSArray *routeArray1=[data objectForKey:@"routes"];
   
    for(int i=0;i<[routeArray1 count];i++)
    {
        NSDictionary *main=[routeArray1 objectAtIndex:i];
        NSArray *routeSubArray=[main objectForKey:@"route"];
        NSString *count=[NSString stringWithFormat:@"%lu",([routeSubArray count])];
        NSLog(@"Count=%@",count);
        for(int j=0;j<([routeSubArray count])/2;j++)
        {
            NSDictionary *journeyArray=[routeSubArray objectAtIndex:j];
            break_latitude1=[journeyArray objectForKey:@"break_latitude"];
            break_longitude1=[journeyArray objectForKey:@"break_longitude"];
            
        }}
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:[break_latitude1 doubleValue] longitude:[break_longitude1 doubleValue] zoom:11];
    myMap.camera=cameraPosition;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backOn"]) {
        SearchRouteViewController *serVC = segue.destinationViewController;
        serVC.starts=self.starts;
        serVC.stops=self.stops;
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

@end
