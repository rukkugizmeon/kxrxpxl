//
//  ServerConnection.h
//  CarPooling
//
//  Created by atk's mac on 26/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefineMainValues.h"

@interface ServerConnection : NSObject

- (NSData*)ServerCall:(NSString*)url post:(NSString*)postString;
-(float) DistanceDatas:(NSString*)responseData;
@end
