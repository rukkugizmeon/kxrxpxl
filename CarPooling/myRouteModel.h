//
//  myRouteModel.h
//  CarPooling
//
//  Created by atk's mac on 07/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myRouteModel : NSObject

@property (strong, nonatomic) NSString *journey_start_latitude;
@property (strong, nonatomic) NSString *journey_start_longitude;
@property (strong, nonatomic) NSString *journey_start_point;
@property (strong, nonatomic) NSString *journey_id;
@property (strong, nonatomic) NSString *time_intervals;
@property (strong, nonatomic) NSString *seats_count;
@property (strong, nonatomic) NSString *journey_end_point;
@property (strong, nonatomic) NSString *active;
@property (strong, nonatomic) NSString *active_days;
@property (strong, nonatomic) NSString *active_raw;
@end
