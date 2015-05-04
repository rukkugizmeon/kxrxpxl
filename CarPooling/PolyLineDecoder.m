//
//  PolyLineDecoder.m
//  CarPooling
//
//  Created by atk's mac on 04/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "PolyLineDecoder.h"

@implementation PolyLineDecoder

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    
    @try {
        NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
        [encoded appendString:encodedStr];
        [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
        NSInteger len = [encoded length];
        NSInteger index = 0;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSInteger lat=0;
        NSInteger lng=0;
        while (index < len) {
            NSInteger b;
            NSInteger shift = 0;
            NSInteger result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
            lat += dlat;
            shift = 0;
            result = 0;
            do {
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            } while (b >= 0x20);
            NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
            lng += dlng;
            NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
            NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
            [array addObject:location];
            
            return array;
        }

    }
    @catch (NSException *exception) {
        
        
        
        
    }
    @finally {
        
        NSLog(@"Decoding Error, Entered in Finally Block: Class PolyLineDecoder");
        
    }
    
    
}

- (GMSPolyline *)fetchedData:(NSData *)responseData {
        NSLog(@"Plotting polyline");
    NSError *jsonParsingError;
    GMSPolyline *rectangle ;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    
    GMSMutablePath *Polylinepaths= [GMSMutablePath path];
    NSArray *routeArray=[data objectForKey:@"routes"];
    //NSLog(@"Response %@",data);
    for(int i=0;i<[routeArray count];i++)
    {
        NSDictionary *main=[routeArray objectAtIndex:i];
        NSArray *routeSubArray=[main objectForKey:@"route"];
        for(int j=0;j<[routeSubArray count];j++)
        {
            NSDictionary *journeyArray=[routeSubArray objectAtIndex:j];
            NSString *break_latitude=[journeyArray objectForKey:@"break_latitude"];
        NSString *break_longitude=[journeyArray objectForKey:@"break_longitude"];
            NSLog(@"Lat=%@ Long=%@",break_latitude,break_longitude);
        [Polylinepaths addCoordinate:CLLocationCoordinate2DMake([break_latitude  doubleValue],[break_longitude doubleValue])];
       rectangle = [GMSPolyline polylineWithPath:Polylinepaths];
      
            

        }}
    
    
    
    
   return rectangle;
}
- (GMSMarker *)endPointMarker:(NSData *)responseData {
    NSLog(@"Plotting end point marker");
    GMSMarker *marker= [[GMSMarker alloc] init];
    NSError *jsonParsingError;
    NSString *break_latitude;
    NSString *break_longitude;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSArray *routeArray=[data objectForKey:@"routes"];
    //
    for(int i=0;i<[routeArray count];i++)
    {
        NSDictionary *main=[routeArray objectAtIndex:i];
        NSArray *routeSubArray=[main objectForKey:@"route"];
        for(int j=0;j<[routeSubArray count];j++)
        {
            NSDictionary *journeyArray=[routeSubArray objectAtIndex:j];
           break_latitude=[journeyArray objectForKey:@"break_latitude"];
            break_longitude=[journeyArray objectForKey:@"break_longitude"];
            
        }
    }
    marker.position = CLLocationCoordinate2DMake([break_latitude doubleValue],[break_longitude doubleValue]);
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    return marker;
}

@end
