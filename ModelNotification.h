//
//  ModelNotification.h
//  CarPooling
//
//  Created by Gizmeon Technologies on 31/01/15.
//  Copyright (c) 2015 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelNotification : NSObject
@property (nonatomic,strong) NSString * Id;
@property (nonatomic,strong) NSString * reqId;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * date;
@property (nonatomic,strong)NSString * description;
@property (nonatomic,strong)NSString * route;
@property (nonatomic,strong)NSString * status;

@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * roleType;

@end
