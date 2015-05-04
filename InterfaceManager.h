//
//  InterfaceManager.h
//  Lubna Foods
//
//  Created by Febin Babu Cheloor on 25/02/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DefineMainValues.h"

@interface InterfaceManager : NSObject

@property (retain,nonatomic) UIImage * backgroundImage;

+(void)DisplayAlertWithMessage:(NSString*)Message;

+ (id)sharedInterfaceManager;

@end
