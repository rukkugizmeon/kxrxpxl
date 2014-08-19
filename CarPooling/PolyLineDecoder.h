//
//  PolyLineDecoder.h
//  CarPooling
//
//  Created by atk's mac on 04/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PolyLineDecoder : NSObject

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr;
- (GMSPolyline *)fetchedData:(NSData *)responseData ;
- (GMSMarker *)endPointMarker:(NSData *)responseData ;
@end
