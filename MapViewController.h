//
//  MapViewController.h
//  CarPooling
//
//  Created by atk's mac on 25/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DefineMainValues.h"
#import "PolyLineDecoder.h"
#import "SearchRouteModel.h"
#import "ServerConnection.h"
#import "MZLoadingCircle.h"
#import "GMDraggableMarkerManager.h"
#import "WTStatusBar.h"
#import "UserDataView.h"
#import "GiverDataView.h"
#import "SearchRouteViewController.h"


@interface MapViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *path;
    NSMutableArray * mSelectedArray;
    NSMutableArray * searchListArray;
    SearchRouteModel *mSearchModel;
    NSString *blockingId;
}
@property (weak, nonatomic) IBOutlet GMSMapView *mymap;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (strong, nonatomic, readwrite) GMDraggableMarkerManager *draggableMarkerManager;
@property (assign,nonatomic) CLLocationCoordinate2D  LocationCoordinates;
@property (strong, nonatomic)  NSString *starts;
@property (strong, nonatomic)  NSString *timeInterval;
@property (strong, nonatomic)  NSString *options;
@property (strong, nonatomic)  NSString *stops;
@property (strong, nonatomic)  NSString *start_marker_lat;
@property (strong, nonatomic)  NSString *start_marker_lng;
@property (weak, nonatomic) IBOutlet UIButton *addRouteButton;

//Add route Options
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITableView *daysTable;
@property (weak, nonatomic) IBOutlet UITextField *seatsField;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *mIntervalPicker;



//Taker Datas
@property (weak, nonatomic) IBOutlet UILabel *minTimeField;
@property (weak, nonatomic) IBOutlet UILabel *minDistField;
@property (weak, nonatomic) IBOutlet UIImageView *mDriverImageField;
@property (weak, nonatomic) IBOutlet UILabel *mNameField;
@property (weak, nonatomic) IBOutlet UILabel *mAgeField;
@property (weak, nonatomic) IBOutlet UILabel *mAddressField;
@property (weak, nonatomic) IBOutlet UIButton *mBlockButton;
@property (weak, nonatomic) IBOutlet UIButton *mRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *TakerStar1;
@property (weak, nonatomic) IBOutlet UIButton *TakerStar2;
@property (weak, nonatomic) IBOutlet UIButton *TakerStar3;
@property (weak, nonatomic) IBOutlet UIButton *TakerStar4;
@property (weak, nonatomic) IBOutlet UIButton *TakerStar5;

//Giver Datas
@property (weak, nonatomic) IBOutlet UILabel *gMinTimeField;
@property (weak, nonatomic) IBOutlet UILabel *gMinDistField;
@property (weak, nonatomic) IBOutlet UILabel *gNameField;
@property (weak, nonatomic) IBOutlet UILabel *gAgeField;
@property (weak, nonatomic) IBOutlet UILabel *gAddressField;
@property (weak, nonatomic) IBOutlet UILabel *gCityField;
@property (weak, nonatomic) IBOutlet UILabel *gCarModelField;
@property (weak, nonatomic) IBOutlet UILabel *gSeatsField;
@property (weak, nonatomic) IBOutlet UIButton *gBlockButton;
@property (weak, nonatomic) IBOutlet UIButton *gRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *GiverStar1;
@property (weak, nonatomic) IBOutlet UIButton *GiverStar2;
@property (weak, nonatomic) IBOutlet UIButton *GiverStar3;
@property (weak, nonatomic) IBOutlet UIButton *GiverStar4;
@property (weak, nonatomic) IBOutlet UIButton *GiverStar5;

@end
