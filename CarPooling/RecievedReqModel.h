//
//  RecievedReqModel.h
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecievedReqModel : NSObject
@property (strong, nonatomic) NSString *journey_start;
@property (strong, nonatomic) NSString *journey_latitude;
@property (strong, nonatomic) NSString *journey_longitude;
@property (strong, nonatomic) NSString *journey_end_latitude;
@property (strong, nonatomic) NSString *journey_end_longitude;
@property (strong, nonatomic) NSString *journey_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *status;
@end
