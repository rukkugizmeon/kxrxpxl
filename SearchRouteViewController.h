//
//  SearchRouteViewController.h
//  CarPooling
//
//  Created by atk's mac on 08/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GMDraggableMarkerManager.h"
#import "ServerConnection.h"

@interface SearchRouteViewController : UIViewController
@property (strong, nonatomic)  NSString *postString;
@property (strong, nonatomic)  NSString *starts;
@property (strong, nonatomic)  NSString *stops;
@property (strong, nonatomic)  NSString *start_marker_lat;
@property (strong, nonatomic)  NSString *start_marker_lng;
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (strong, nonatomic, readwrite) GMDraggableMarkerManager *draggableMarkerManager;
@end
