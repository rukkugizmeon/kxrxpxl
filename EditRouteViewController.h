//
//  EditRouteViewController.h
//  CarPooling
//
//  Created by atk's mac on 20/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRouteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
  NSArray * DaysArray;
     NSMutableArray * mSelectedArray;
}
@property (weak, nonatomic) IBOutlet UITableView *daysTableView;
@property (weak, nonatomic) IBOutlet UITextField *noOfSeatField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalSegment;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic)  NSString *seats;
@property (strong, nonatomic)  NSString *activeDays;
@property (strong, nonatomic)  NSString *timeInterval;
@property (strong, nonatomic)  NSString *journeyId;
@end
