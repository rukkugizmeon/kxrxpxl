//
//  DetailRouteViewController.h
//  CarPooling
//
//  Created by atk's mac on 07/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DefineMainValues.h"
#import "DetailedRouteModel.h"
#import "GMDraggableMarkerManager.h"
#import "WTStatusBar.h"
#import "PolyLineDecoder.h"

@interface DetailRouteViewController : UIViewController<UIAlertViewDelegate>
{
    NSMutableArray * journeyListArray;
    NSMutableArray *path;
    NSMutableArray * searchListArray;
    DetailedRouteModel *mDetaileModel;
}
@property (strong, nonatomic)  NSString *starts;
@property (strong, nonatomic)  NSString *stops;
@property (strong, nonatomic)  NSString *journeyId;
@property (weak, nonatomic) IBOutlet GMSMapView *myMap;
@property (strong, nonatomic, readwrite) GMDraggableMarkerManager *draggableMarkerManager;
@end
