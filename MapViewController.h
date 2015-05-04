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
#import "REFrostedViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StarRatingView.h"
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate>
{
    NSMutableArray *path;
    NSMutableArray * mSelectedArray;
    NSMutableArray * searchListArray;
    SearchRouteModel *mSearchModel;
    NSString *blockingId;
    GiverDataView *AccessoryView;
    UserDataView *AccessoryView1;
    NSArray *optionsArray;
    NSArray *cityArray;
    NSArray *subOptions;
    int optionFlag;
    int cityFlag;
}
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *animatedContainer;
@property (weak, nonatomic) IBOutlet UIView *doneButton;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *optionsPicker;
- (IBAction)actionDone:(id)sender;
- (IBAction)searchAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *searchContainer;
@property (weak, nonatomic) IBOutlet UITextField *toField;
@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UIButton *cityField;
@property (weak, nonatomic) IBOutlet UIButton *optionsField;


- (IBAction)selectOptions:(id)sender;
- (IBAction)selectCity:(id)sender;


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

//Add route Options
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITableView *daysTable;
@property (weak, nonatomic) IBOutlet UITextField *seatsField;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *mIntervalPicker;



//Taker Datas

- (IBAction)showTakerRoute:(id)sender;
- (IBAction)clearTakerView:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *minTimeField;
@property (weak, nonatomic) IBOutlet UILabel *minDistField;
@property (weak, nonatomic) IBOutlet UIImageView *mDriverImageField;
@property (weak, nonatomic) IBOutlet UILabel *mNameField;
@property (weak, nonatomic) IBOutlet UILabel *mAgeField;
@property (weak, nonatomic) IBOutlet UILabel *mAddressField;
@property (weak, nonatomic) IBOutlet UIButton *mBlockButton;
@property (weak, nonatomic) IBOutlet UIButton *mRequestButton;


//Giver Datas
- (IBAction)showGiverRoute:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeGiverView;

- (IBAction)closeGiver:(id)sender;

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

@property (strong, nonatomic) IBOutlet StarRatingView *viewRatingTaker;
@property (strong, nonatomic) IBOutlet StarRatingView *viewRatingGiver;

@end
