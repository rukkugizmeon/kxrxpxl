//
//  MapViewController.m
//  CarPooling
//
//  Created by atk's mac on 25/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "MapViewController.h"
#import "StarRatingView.h"




@interface MapViewController ()<GMSMapViewDelegate,GMDraggableMarkerManagerDelegate>
{
    BOOL isUpdatingEnd;
    BOOL isUpdatingStart;
    NSString *journey_ids;
    NSString *GTuser_ids;
    NSString *GlobalpostString;
    UIBarButtonItem *addButton;
    UIButton *aButton1;
    
    NSString *searchOption;
    NSString *selectedCity;
    UITableView * autocompleteTableView;
    NSMutableArray *descriptionArray;
    BOOL didSelectedDefaultValueInCPicker,didSelectedDefaultValueInOPicker,didSelectedDefaultValueIntervelPicker;
    
    CGSize KBSIZE;
    CGRect screenOriginalFram;
    GMSMarker * markerStart,*markerDestination;
    StarRatingView * viewR;
    
    
    
}

@end

@implementation MapViewController
@synthesize gAddressField,gAgeField,gCarModelField,gCityField,gMinDistField,gMinTimeField,gNameField,gSeatsField,toField,fromField,optionsField,cityField;
@synthesize mymap,LocationCoordinates,mNameField,mAgeField,mAddressField,mDriverImageField,minDistField,minTimeField,mIntervalPicker,searchContainer;
@synthesize submitButton,cancelButton,searchButton,cityPicker,optionsPicker;
@synthesize viewRatingTaker,viewRatingGiver;
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
NSArray *timeIntervalArray;
   float zoom;
UIAlertView * alertPleaseWait;
NSString *overviewPolyline;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    didSelectedDefaultValueInCPicker=didSelectedDefaultValueInOPicker=didSelectedDefaultValueIntervelPicker=YES;
     aButton1.userInteractionEnabled=NO;
    
   timeIntervalArray= @[@"12-12:30AM", @"12:30-1AM",@"1:30-2AM", @"2-2:30AM",@"2:30-3AM",@"3-3:30AM", @"3:30-4AM",@"4-4:30AM",@"4:30-5AM", @"5-5:30AM", @"5:30-6AM",@"6-6:30AM", @"6:30-7AM",@"7-7:30AM", @"7:30-8AM",@"8-8:30AM",@"8:30-9AM", @"9-9:30AM", @"9:30-10AM",@"10-10:30AM", @"10:30-11PM",@"11-11:30AM",@"11:30-12PM",@"12-12:30PM", @"12:30-1PM",@"1:30-2PM", @"2-2:30PM",@"2:30-3PM",@"3-3:30PM", @"3:30-4PM",@"4-4:30PM",@"4:30-5PM", @"5-5:30PM", @"5:30-6PM",@"6-6:30PM", @"6:30-7PM",@"7-7:30PM", @"7:30-8PM",@"8-8:30PM",@"8:30-9PM", @"9-9:30PM", @"9:30-10PM",@"10-10:30PM", @"10:30-11PM",@"11-11:30PM",@"11:30-12PM"];
    
    optionsArray= @[@"None",@"Favourite Users",@"Same Company", @"Nearest to starting", @"Nearest to Destination",@"Already interested", @"Highest Rating", @"Schedule"];
    
    subOptions=@[@" ",@"fav_users",@"same_company",@"near_origin",@"near_destination",@"interested",@"highest_rating",@"active_shedule"];
    
    
    cityArray = @[@"Bangalore",
                  @"Chennai",@"Kannur", @"Cochin", @"Delhi"];
    
    
    [optionsPicker selectRow:3 inComponent:0 animated:YES];
    [cityPicker selectRow:3 inComponent:0 animated:YES];
    [mIntervalPicker selectRow:8 inComponent:0 animated:YES];
}

-(void)slider:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}


-(void)addRouteActions:(id)sender
{
    searchButton.hidden=YES;
    submitButton.hidden=NO;
    [self.daysTable reloadData];
    [self MoveDown];
}

- (void)viewDidLoad
{
   //  aButton1.userInteractionEnabled=NO;
    
   
     
    
    
    
    
    
    
    screenOriginalFram = [[UIScreen mainScreen]bounds];
    screenOriginalFram.size.height=screenOriginalFram.size.height-55;
    [super viewDidLoad];
    self.options=@"near_origin";
    [optionsField setTitle:@"Nearest to starting" forState:UIControlStateNormal];
      descriptionArray=[[NSMutableArray alloc]init];
     UIColor *placeholder =[UIColor colorWithRed:0.87 green:0.69 blue:0.09 alpha:1];
    [toField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    [fromField setValue:placeholder
             forKeyPath:@"_placeholderLabel.textColor"];
    UIColor * Cgrey =[UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    self.addView.backgroundColor=Cgrey;
    UIImage *buttonImage1 = [UIImage imageNamed:@"ridewithme_mobile_btnaddroute"];
    aButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton1 setImage:buttonImage1 forState:UIControlStateNormal];
    aButton1.frame = CGRectMake(0.0, 0.0,25,30);
    addButton = [[UIBarButtonItem alloc] initWithCustomView:aButton1];
     [aButton1 addTarget:self action:@selector(addRouteActions:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = addButton;
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
    [mymap addSubview:searchContainer];
           [mymap addSubview:self.animatedContainer];
   days = [NSMutableArray arrayWithObjects: @"Sunday", @"Monday", @"Tuesday", @"Wednesday",@"Thursday", @"Friday", @"Saturday", nil];
    zoom=kGoogleMapsZoomLevelDefault;
    
    [cityPicker setTag:0];
    [optionsPicker setTag:1];
    
    self.optionsPicker.delegate=self;
    self.optionsPicker.dataSource=self;
    self.cityPicker.delegate=self;
    toField.delegate=self;
    fromField.delegate=self;
    self.cityPicker.dataSource=self;
    cityFlag=1;
    optionFlag=1;
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
    [self.addView setBackgroundColor:[Cgrey colorWithAlphaComponent:1]];
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
 //   autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(toField.frame.origin.x+50,toField.frame.origin.y+toField.frame.size.height+20,toField.frame.size.width,90) style:UITableViewStylePlain];
    autocompleteTableView = [UITableView new];
    
    //autocompleteTableView.style UITableViewStylePlain;
    
    autocompleteTableView.delegate=self;
    autocompleteTableView.dataSource = self;
    
    autocompleteTableView.layer.masksToBounds=YES;
    autocompleteTableView.backgroundColor=[[UIColor lightGrayColor] colorWithAlphaComponent:1];
    
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.layer.cornerRadius=2;
    [autocompleteTableView setSeparatorInset:UIEdgeInsetsZero];
    [searchContainer addSubview:autocompleteTableView];
    autocompleteTableView.hidden = YES;

    
    alertPleaseWait =[[UIAlertView alloc]initWithTitle:kApplicationName message:@"Please Wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [self LoadMaps];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
   }

//Load Google Maps

-(void)LoadMaps
    {
     
    mymap.delegate=self;
    mymap.myLocationEnabled = YES;
[mymap addSubview:self.zoomIn];
    [mymap addSubview:self.zoomOut];
       
    [self.view addSubview:mymap];
    [mymap setMapType:kGMSTypeNormal];
      GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:12.9667 longitude:77.5667 zoom:kGoogleMapsZoomLevelDefault];
        mymap.camera=cameraPosition;
       self.draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:mymap delegate:self];
        
    }

//Calling Directtions Api

-(void) fetchFromGoogleDirectionsApi:(NSString*)start end:(NSString*)end
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    [alertPleaseWait show];
    
     [mymap clear];
    
    if(isUpdatingEnd)
    {
        
        self.stops=end;
        
    }
    else if (isUpdatingStart)
    {
        
        self.starts=start;
    }
    @try {
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
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        NSLog(@"Entered into Finally : Class-MapView, Methode-fetchFromGoogleDirectionsApi");
        
    }
    
   
}

//Parsing the response from google Directions APi
- (void)fetchedData:(NSData *)responseData
{
    
    NSError *jsonParsingError;
    NSDictionary *LocationData= [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0 error:&jsonParsingError];
    //[self parseResponse:LocationData];
     NSArray *Route=[LocationData objectForKey:@"routes"];
    
    if ([[LocationData valueForKey:@"status"] isEqualToString:@"OK"]) {
        
    
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
        
         }
   // NSString  *sOption=@"";
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];
  
    NSLog(@"***************************************");
    
        
    [self dismiss:alertPleaseWait];
//[self searchUsers];
    
                           
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
    
    NSString * status = [[data valueForKeyPath:@"status"] stringValue];
    
    if ([status isEqualToString:@"0"]) {
        
        [self ShowAlertView:@"No Routes Found"];
        
       
        
        
        
        
    }
    else
    {
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
                
            }
        }

    }
    
    [self dismiss:alertPleaseWait];
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
        marker.icon = [UIImage imageNamed:@"ridewithme_mobile_peopletracker"];
        marker.title =[NSString stringWithFormat:@"%@",model.journey_id];
        marker.map = mymap;
        
        
        
    }
     aButton1.userInteractionEnabled=YES;
}

//Draws Driving routes
- (void)parseResponseAndDrawPolyline:(NSDictionary *)response {
    
    
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        
      //Polyline Plotting
        
        
        
        
        GMSPath *paths=[GMSPath pathFromEncodedPath:overviewPolyline];
        
        
        
        GMSPolyline *line=[GMSPolyline polylineWithPath:paths];
        
        
        
        
        GMSCoordinateBounds *bounds= [[GMSCoordinateBounds alloc] init];
        
        
        bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:markerStart.position    coordinate:markerDestination.position];
        
        
        
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:90];
        [mymap animateWithCameraUpdate:update];
        
        
        
        
         aButton1.userInteractionEnabled=YES;
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
    
    
    if(![self.options isEqualToString:@"active_schedule"])
    {
        [self searchUsers];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField==toField || textField==fromField)
    {
    NSString *substring;
    
    
    substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    
        substring =[substring stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(substring!=nil && substring.length>2)
    {
         [self Places:substring];
        
    }
    else if(substring.length==0){
        autocompleteTableView.hidden=YES;
    }
    
    }
    return YES;
}


-(void)Places:(NSString*)input
{
    @try {
        
        NSString *postData=[NSString stringWithFormat:@"%@&location=11.8689,75.3555&radius=500&sensor=true&key=%@",input,kGooglePlacesAPIKey];
        NSString *text=@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=";
        text=[text stringByAppendingString:postData];
        NSURL *url = [NSURL URLWithString:text];
        // NSLog(@"Url%@",url);
        
        
        dispatch_async(kBgQueue, ^{
            NSData *data= [NSData dataWithContentsOfURL:
                           url];
            [self performSelectorOnMainThread:@selector(fetchedPlaceData:)
                                   withObject:data waitUntilDone:YES];
            
            
        });

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        
        NSLog(@"Entered into Finally:Class - MapView, Method- Places");
        
    }
   }

- (void)fetchedPlaceData:(NSData *)responseData
{
    //  NSLog(@"@Parsing Info");
    [descriptionArray removeAllObjects];
    //[autocompleteTableView reloadData];
    
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    NSArray *predictions=[data objectForKey:@"predictions"];
    
    if (predictions.count) {
        
        for(int i=0;i<[predictions count];i++)
        {
            
        NSDictionary *predObj=[predictions objectAtIndex:i];
        NSString *desc=[predObj objectForKey:@"description"];
        NSLog(@"place = %@",desc);
        [descriptionArray addObject:desc];
            
        }
   // optionsArray = [[NSArray alloc] initWithArray:descriptionArray];
	
    autocompleteTableView.hidden=NO;
    [autocompleteTableView reloadData];
    
    }else{
        
        autocompleteTableView.hidden=YES;
    }
    
}



-(void)ShowAlertView:(NSString*)Message{
    
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
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
    markerStart = Marker;
    
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Origin";
    Marker.snippet=starts;
   // Marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    Marker.icon = [UIImage imageNamed:@"red-dot"];
    Marker.map  = self.mymap;
    
}

-(void)getStopLocation:(NSString*)stops lat:(NSString*)lat lng:(NSString*)lng {
    
    
    CLLocationCoordinate2D Location = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    
    GMSMarker * Marker  =[GMSMarker markerWithPosition:Location];
    markerDestination=Marker;
    [self.draggableMarkerManager addDraggableMarker:Marker];
    Marker.title =@"Destination";
   // Marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
   Marker.icon = [UIImage imageNamed:@"red-dot"];
    Marker.snippet=stops;
    Marker.map  = self.mymap;
   
    
}
//Marker Activities ends


//Add route

-(void)addRouteToServer{
    
    
        @try {
            [WTStatusBar setLoading:YES loadAnimated:YES];
            
            NSLog(@" type %@", types);
            NSString *activedaysFinal= [[NSString stringWithFormat:@"%@",mSelectedArray] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            
            activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@"(" withString:@"{"];
            activedaysFinal= [activedaysFinal stringByReplacingOccurrencesOfString:@")" withString:@"}"];
            NSString *noSeats=[types isEqualToString:@"T"]? @"0":self.seatsField.text;
            noSeats=[NSString stringWithFormat:@"%@",noSeats];
            origin=[self formatOrigin:origin];
            destination=[self formatDest:destination];
            
            NSString * PostString = [NSString stringWithFormat:@"userId=%@&startLatLong[1]=%@&startLatLong[0]=%@&endLatLong[1]=%@&endLatLong[0]=%@&routeType=%@&from=%@&to=%@&activeDays=%@&timeInterval=%@&seatsCount=%@&overview_path=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,types,origin,destination,activedaysFinal,self.timeInterval,noSeats,overviewPolyline];
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
        @catch (NSException *exception) {
            
        }
        @finally {
            
            
            NSLog(@"Enterd into Finally: class- Map view, method- addroute to server");
            
            
        
        }
        
        
       
   
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
        
        didSelectedDefaultValueIntervelPicker=YES;
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
- (void)fetchedTakerData:(NSData *)responseData time:(NSString*)time dist:(NSString*)dist
{
   
    NSError *jsonParsingError;
    NSArray *DriverData= [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:0 error:&jsonParsingError];
    NSDictionary *DataPos= [DriverData objectAtIndex:0];
    NSString *name=[DataPos objectForKey:@"name"];
    NSString *age=[DataPos objectForKey:@"age"];
    age=[NSString stringWithFormat:@"%@",age];
    NSString *address=[DataPos objectForKey:@"address"];
    NSString * rateStng = [DataPos objectForKey:@"rate"];
    NSInteger rating = [rateStng integerValue];
    
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
                    NSString * rateStng = [DataPos objectForKey:@"rate"];
                    
                    if ([rateStng isKindOfClass:[NSNull class]] || rateStng == nil) {
                        
                        rateStng = @"0";
                    }
                    
                    NSInteger rating = [rateStng integerValue];
                    NSLog(@"DriverData%@",name);
                    [self ShowGiverRouteDataAlert:name age:age address:address NofSeats:seats city:city model:car_model time:time dist:dist rate:rating];
                }


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    @try {
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
                    
                    [alertPleaseWait show];
                    
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
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    NSLog(@"Entered into finally: Class- Map View, method- didtapmarker");
    
    }

-(void) DistanceData:(NSData*)responseData
{
    [self dismiss:alertPleaseWait];
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
        [self fetchedTakerData:driverData time:distText dist:durText];
    }else
    {
        [self fetchedGiverData:driverData time:distText dist:durText];
    }

   
    
}
-(void)MoveUp
{
    self.zoomIn.hidden=NO;
    self.zoomOut.hidden=NO;
       aButton1.userInteractionEnabled=YES;
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
      
         const int movementDistance = 816; // tweak as needed
         const float movementDuration = 0.3f; // tweak as needed
         bool up=YES;
         int movement = (up ? -movementDistance : movementDistance);
         
         [UIView beginAnimations: @"anim" context: nil];
         [UIView setAnimationBeginsFromCurrentState: YES];
         [UIView setAnimationDuration: movementDuration];
         self.addView.frame = CGRectOffset(self.addView.frame, 0, movement);
         [UIView commitAnimations];
     }else{
     
    const int movementDistance = 500; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    bool up=YES;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.addView.frame = CGRectOffset(self.addView.frame, 0, movement);
         [UIView commitAnimations];}
      //self.addView.hidden=YES;
}
-(void)MoveDown
{
      aButton1.userInteractionEnabled=NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
    {    self.zoomIn.hidden=YES;
        self.zoomOut.hidden=YES;
        const int movementDistance = 810; // tweak as needed
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
    
    }else{
    self.zoomIn.hidden=YES;
    self.zoomOut.hidden=YES;
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
    }
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
      aButton1.userInteractionEnabled=NO;
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

-(void)ShowUserRouteDataAlert:(NSString*)name age:(NSString*)age address:(NSString*)address  time:(NSString*)time dist:(NSString*)dist rate:(NSInteger )rating {
    
    
    AccessoryView1 =[ [[NSBundle mainBundle]loadNibNamed:@"UserDataView" owner:self options:nil] objectAtIndex:0];
    AccessoryView1.hidden=NO;
    [AccessoryView1 setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView1.frame=CGRectMake(20,self.view.frame.origin.y+20,AccessoryView1.frame.size.width-20,AccessoryView1.frame.size.height);
    AccessoryView1.layer.cornerRadius=5;

    
    
    mNameField.text=name;
    mAgeField.text=age;
    mAddressField.text=address;
        minTimeField.text=time;
        minDistField.text=dist;
    // [self ratingTaker:rating];
        NSLog(@"Type=%@ =Dist%@,Time%@ ",types,distText,durText);
  
    // Set Values
    
    
    
    
    
    
    [viewRatingTaker setBackgroundColor:[UIColor clearColor]];
    viewR  = [[StarRatingView alloc]initWithFrame:viewRatingTaker.frame andRating:rating  withLabel:NO animated:YES];
    
    
    
    
    
    viewRatingTaker=viewR;
    
    
    
    viewRatingTaker.userInteractionEnabled=NO;
    
    [AccessoryView1 addSubview:viewRatingTaker];
    
    
    
    
    
    [mymap addSubview:AccessoryView1];
  //  [Alert show];
}

-(void)ShowGiverRouteDataAlert:(NSString*)name age:(NSString*)age address:(NSString*)address NofSeats:(NSString*)noSeats city:(NSString*)city model:(NSString*)model  time:(NSString*)time dist:(NSString*)dist rate:(NSInteger )rating
{
    
    
    
    AccessoryView =[ [[NSBundle mainBundle]loadNibNamed:@"View" owner:self options:nil] objectAtIndex:0];
    
    //[AccessoryView setBackgroundColor:[UIColor clearColor]];
    AccessoryView.hidden=NO;
    [AccessoryView setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    AccessoryView.frame=CGRectMake(20,self.view.frame.origin.y+20,AccessoryView.frame.size.width-20,AccessoryView.frame.size.height);
    AccessoryView.layer.cornerRadius=5;
    //[Alert setValue:AccessoryView forKey:@"accessoryView"];
    
    gMinTimeField.text=dist;
    gMinDistField.text=time;
    NSLog(@"Type=%@ =Dist%@,Time%@ ",types,distText,durText);
    gNameField.text=name;
    gAgeField.text=age;
    gAddressField.text=address;
    gSeatsField.text=noSeats;
    gCityField.text=city;
    gCarModelField.text=model;
 //   [self ratingGiver:rate];
    
    
    [viewRatingTaker setBackgroundColor:[UIColor clearColor]];
    viewR  = [[StarRatingView alloc]initWithFrame:viewRatingGiver.frame andRating:rating  withLabel:NO animated:YES];
    
    
    viewR.backgroundColor = [UIColor clearColor];
    
    
    viewRatingTaker=viewR;
    
    
    
    viewRatingTaker.userInteractionEnabled=NO;
    
    [AccessoryView addSubview:viewRatingTaker];
    
    
    
    
    
    [mymap addSubview:AccessoryView];
   //[Alert show];
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
  
      //  NSString *postString=[NSString stringWithFormat:@"userId=%@",uId];
    NSString *postString=[NSString stringWithFormat:@"userId=%@&journeyId=%@&ownerId=%@",uId,journey_ids,GTuser_ids];
    NSData *request=[ConnectToServer ServerCall:kServerLink_journeyRequest post:postString];
    [self requestData:request];
//        NSData *earnings=[ConnectToServer ServerCall:kServerLink_GetEarnings post:postString];
//        [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
//        [self fetchedEarningsData:earnings];
    
    

   }
- (IBAction)mBlockButton:(id)sender {
         NSLog(@"Block");
    NSString *postString=[NSString stringWithFormat:@"blockUserId=%@&blockedByUserId=%@",blockingId,uId];
    NSData *response=[ConnectToServer ServerCall:kServerLink_BlockUser post:postString];
    [self blockedResponse:response];
}
- (IBAction)gRequestButton:(id)sender {
    
    NSLog(@"request");
    NSString *postString=[NSString stringWithFormat:@"userId=%@&journeyId=%@&ownerId=%@",uId,journey_ids,GTuser_ids];
    NSLog(@"post %@",postString);
    NSData *request=[ConnectToServer ServerCall:kServerLink_journeyRequest post:postString];
    [self requestData:request];
//        NSString *postString=[NSString stringWithFormat:@"userId=%@",uId];
//        NSData *earnings=[ConnectToServer ServerCall:kServerLink_GetEarnings post:postString];
//         [self performSelector:@selector(dismiss:) withObject:Alert afterDelay:1.0];
//        [self fetchedEarningsData:earnings];
    

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
        if(ridePoint<=Minridepooints)
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
    if (!jsonParsingError) {
        
    
    if([result isEqualToString:@"success"])
    {
        [self ShowAlertView:@"Your interest in co-rider is communicated. Please wait for their confirmation"];
    }else if ([result isEqualToString:@"error"]){
        
        [self ShowAlertView:[data valueForKey:@"msg"]];
        
        
    }
    else
    {
     [self ShowAlertView:@"Request cannot be sent now! Please try later!"];
    }
        
        [self ShowAlertView:@"Invalid Response"];
        
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
    
    if (didSelectedDefaultValueIntervelPicker) {
        [self ShowAlertView:@"Please Select a time interval"];
    }else
    {
    NSLog(@"Array val %@",mSelectedArray);
    if(mSelectedArray.count>0){
        
        NSInteger numOfseats = [self.seatsField.text integerValue];
        
        
        if(numOfseats>0  || [types isEqualToString:@"T"] ){
      
            [self ShowSubmitRouteAlertWithMessage:@"Are you sure you want to submit the route?"];
        }else
        {
        [self ShowAlertView:@"Please enter valid number of seats"];
        }
    
    }
    else{
        [self ShowAlertView:@"Please select days"];
    }
}
}
//Table delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if(tableView==autocompleteTableView)
    {
        return [descriptionArray count];
    }
    else{
    return [days count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor clearColor];
    if (tableView==autocompleteTableView) {
        cell.textLabel.text =[descriptionArray objectAtIndex:indexPath.row];
    }
    else{
    cell.textLabel.text = [days objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (tableView==autocompleteTableView) {
        if(toField.editing)
        {
           toField.text=[descriptionArray objectAtIndex:indexPath.row];
            
        }else if(fromField.editing){
            fromField.text=[descriptionArray objectAtIndex:indexPath.row];
        }
        NSLog(@"%@",[descriptionArray objectAtIndex:indexPath.row]);
        autocompleteTableView.hidden=YES;

    }
    else{
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
       
         [mSelectedArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    else
    {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [mSelectedArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }}
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
   
       if(textField==self.seatsField){
    

            [self animateTextField: textField up: YES];
        }else{
            
            
            autocompleteTableView.frame = CGRectMake(textField.frame.origin.x,textField.frame.origin.y+textField.frame.size.height,textField.frame.size.width,90);
            
            
        }
            
    if (textField==self.seatsField) {
        
        
        [self moveUpViewWithPicker];
        
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==self.seatsField){
        [self animateTextField: textField up: NO];
    }
    
    if (textField==self.seatsField) {
        
        [self moveDownViewWithPicker];
        
    }
    
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

//picker delegates

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        tView.textColor=[UIColor whiteColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [tView setFont:[UIFont fontWithName:@"Verdana" size:20]];}
        else{
            
            [tView setFont:[UIFont fontWithName:@"Verdana" size:16]];
        }
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
        if(pickerView==self.optionsPicker)
        {
             tView.text=[optionsArray objectAtIndex:row];
        }else if(pickerView==self.mIntervalPicker)
        {
            tView.text=[timeIntervalArray objectAtIndex:row];
        }
        else if(pickerView==self.cityPicker)
        {
            tView.text=[cityArray objectAtIndex:row];
        }
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
    if(pickerView==self.optionsPicker)
    {
        return optionsArray.count;
    }
    else if(pickerView==self.cityPicker)
    {
     return cityArray.count;
    }
    else{
        return timeIntervalArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if(pickerView==self.optionsPicker)
    {
     return optionsArray[row];
    }
    else if(pickerView==self.cityPicker)
    {
    return cityArray[row];
    }
    else
    {
        return timeIntervalArray[row];
    }
   
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if(pickerView==self.optionsPicker)
    {
        searchOption=[optionsArray objectAtIndex:row];
        self.options=[subOptions objectAtIndex:row];
        didSelectedDefaultValueInOPicker=NO;
    }
    else if(pickerView==self.cityPicker)
    {
        selectedCity=cityArray[row];
        didSelectedDefaultValueInCPicker=NO;
    }
    else{
        didSelectedDefaultValueIntervelPicker=NO;
        self.timeInterval= timeIntervalArray[row];
    }
    
    
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
    
    @try {
        
        NSString *activedaysFinal;
        if([self.options isEqualToString:@"same_company"])
        {
            // self.options=company;
            activedaysFinal=@"";
            self.timeInterval=@"";
        }
        else if([_options isEqualToString:@"active_shedule"])
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
            
            NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchOption=%@&active_shedule_time=%@&&active_shedule_days=%@&type=%@&companyName=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,self.options,activedaysFinal,self.timeInterval,@"T",company];
            NSData *searchData=[ConnectToServer ServerCall:kServerLink_SearchRoute post:postString];
            [self SearchMarkers:searchData];
        }
        else if([types isEqualToString:@"T"])
        {
            //        NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchoption=%@&type=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,sOption,@"G"];
            NSString *postString=[NSString stringWithFormat:@"userId=%@&OriginLat=%@&OriginLong=%@&DestLat=%@&DestLong=%@&searchOption=%@&active_shedule_time=%@&&active_shedule_days=%@&type=%@&companyName=%@",uId,start_Latitude,start_Longitude,stop_Latitude,stop_Longitude,self.options,activedaysFinal,self.timeInterval,@"G",company];
            NSData *searchData=[ConnectToServer ServerCall:kServerLink_SearchRoute post:postString];
            [self SearchMarkers:searchData];
        }
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        [self dismiss:alertPleaseWait];
        
        
        
    }
    
  
}

- (IBAction)searchUsers:(id)sender {
    [self MoveUp];
      [self fetchFromGoogleDirectionsApi:start end:end];
    
   
    
}




- (IBAction)showGiverRoute:(id)sender {
     AccessoryView.hidden=YES;
    [self drawPolylineAndMarker];
}

- (IBAction)showTakerRoute:(id)sender {
     AccessoryView1.hidden=YES;
    [self drawPolylineAndMarker];
}

- (IBAction)clearTakerView:(id)sender {
    AccessoryView1.hidden=YES;
    
}
- (IBAction)closeGiver:(id)sender {
    AccessoryView.hidden=YES;
}




- (IBAction)selectOptions:(id)sender {
    optionFlag=0;
    self.cityPicker.hidden=YES;
    self.optionsPicker.hidden=NO;
    [self.view endEditing:YES];
   // didSelectedDefaultValueInOPicker=YES;
    
    [self showViewWithPickers];
}

- (IBAction)selectCity:(id)sender {
    cityFlag=0;
    self.cityPicker.hidden=NO;
    self.optionsPicker.hidden=YES;
    [self.view endEditing:YES];
   // didSelectedDefaultValueInCPicker=YES;
    [self showViewWithPickers];
}


- (IBAction)actionDone:(id)sender {
    
    
    
//    UIPickerView * cPicekr=(UIPickerView*)[self.animatedContainer viewWithTag:0];
//    UIPickerView * oPicker = (UIPickerView*)[self.animatedContainer viewWithTag:1];
    
    if ([optionsPicker isHidden] && didSelectedDefaultValueInCPicker ) {
        
        [self pickerView:cityPicker didSelectRow:3 inComponent:0];
        
    }
    else if([cityPicker isHidden] && didSelectedDefaultValueInOPicker)
    {
        [self pickerView:optionsPicker didSelectRow:3 inComponent:0];
        
    }
    if(optionFlag==0)
    {
        [optionsField  setTitle:searchOption forState:UIControlStateNormal];
        optionFlag=1;
    }
    else if (cityFlag==0)
    {
     [cityField  setTitle:selectedCity forState:UIControlStateNormal];
        cityFlag=1;
    }
    [self hideViewWithPickers];
    self.cityPicker.hidden=NO;
    self.optionsPicker.hidden=NO;

}

- (IBAction)searchAction:(id)sender {
    
    
    
    if([cityField.titleLabel.text isEqualToString:@""] || [cityField.titleLabel.text isEqualToString:@""]){
        
        [self ShowAlertView:@"Please Select City"];
        
    }else if  ([toField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"From Field is Missing"];
        
    }else if ([fromField.text isEqualToString:@""]){
        
        [self ShowAlertView:@"To Field is Missing"];
        
    }else {
    
        [fromField resignFirstResponder];
        [toField resignFirstResponder];
        
    searchContainer.hidden=YES;
    self.starts=toField.text;
    self.stops=fromField.text;
    //self.starts=[self.starts stringByAppendingString:[NSString stringWithFormat:@",%@",cityField.currentTitle]];
   // self.stops=[self.stops stringByAppendingString:[NSString stringWithFormat:@",%@",cityField.currentTitle]];
    start=self.starts;
    end=self.stops;
    
    if([self.options isEqualToString:@"active_shedule"])
    {
        self.seatsField.hidden=YES;
        self.seatsLabel.hidden=YES;
        submitButton.hidden=YES;
        [self MoveDown];
        
    }
    else{
        
        
        [self fetchFromGoogleDirectionsApi:start end:end];
    }
  
}
}

-(void)showViewWithPickers
{
    
    [self.view endEditing:YES];
    self.zoomIn.hidden=YES;
    self.zoomOut.hidden=YES;
    self.optionsField.userInteractionEnabled=NO;
    self.cityField.userInteractionEnabled=NO;
    toField.userInteractionEnabled=NO;
    fromField.userInteractionEnabled=NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
    {
        
        
        const int movementDistance = 810; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        bool up=YES;
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.animatedContainer.frame = CGRectOffset(self.animatedContainer.frame, 0, movement);
        [UIView commitAnimations];
        self.animatedContainer.hidden=NO;
        
        
    }else{
        int movementDistance ;
        float movementDuration ;
            movementDistance=195;
        
        movementDuration=0.5f;
        bool up=YES;
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.animatedContainer.frame = CGRectOffset(self.animatedContainer.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    //self.addView.hidden=YES;
}
-(void)hideViewWithPickers
{
    self.zoomIn.hidden=NO;
    self.zoomOut.hidden=NO;
    self.optionsField.userInteractionEnabled=YES;
    self.cityField.userInteractionEnabled=YES;
    toField.userInteractionEnabled=YES;
    fromField.userInteractionEnabled=YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
    {
        const int movementDistance = 810; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        bool up=YES;
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.animatedContainer.frame = CGRectOffset(self.animatedContainer.frame, 0, movement);
        [UIView commitAnimations];
      //self.animatedContainer.hidden
        
        
    }else{
        int movementDistance ;
        movementDistance=195;
        
        float movementDuration=0.5f;
        bool up=YES;
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.animatedContainer.frame = CGRectOffset(self.animatedContainer.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    //self.addView.hidden=YES;
}
- (void)keyboardWillShown:(NSNotification *)notification {
    // Get the size of the keyboard.
     KBSIZE = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:.3 animations:^{
        
        
        
        //   self.animatedContainer.frame = CGRectMake(self.animatedContainer.frame.origin.x, self.animatedContainer.frame.origin.y-movementDistance, self.animatedContainer.frame.size.width, self.animatedContainer.frame.size.height);
        
        
        
        
    }];

  
}
-(void) moveUpViewWithPicker
{
    
    if (KBSIZE.height!=0) {
        
    
        const int movementDistance = KBSIZE.height-55; // tweak as needed
        [UIView animateWithDuration:.3 animations:^{
        
        
        
         //   self.animatedContainer.frame = CGRectMake(self.animatedContainer.frame.origin.x, self.animatedContainer.frame.origin.y-movementDistance, self.animatedContainer.frame.size.width, self.animatedContainer.frame.size.height);
            
        
       self.view.frame= CGRectOffset(self.view.frame, 0, -movementDistance);
        
        
        }];
        
        
    }
 
    
    
    
}
-(void) moveDownViewWithPicker
{
    
    if (KBSIZE.height!=0) {
        
        
        const int movementDistance = KBSIZE.height-55; // tweak as needed
        [UIView animateWithDuration:.3 animations:^{
            
            
            
            //   self.animatedContainer.frame = CGRectMake(self.animatedContainer.frame.origin.x, self.animatedContainer.frame.origin.y-movementDistance, self.animatedContainer.frame.size.width, self.animatedContainer.frame.size.height);
            
            
           self.view.frame= CGRectOffset(self.view.frame, 0, movementDistance);

            
            
        }];
        
        
    }
    
    
    
    
}

@end
