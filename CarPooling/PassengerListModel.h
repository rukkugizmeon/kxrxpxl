//
//  PassengerListModel.h
//  CarPooling
//
//  Created by atk's mac on 13/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassengerListModel : NSObject
@property (strong, nonatomic) NSString *journey_id;
@property (strong, nonatomic) NSString *request_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *carModel;

@property (strong, nonatomic) NSString *sosNumber;
@property (strong, nonatomic) NSString *sosEmail;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *request_status;
@property (strong,nonatomic) NSDictionary * journeyDetails;
@end
