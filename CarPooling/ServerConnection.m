//
//  ServerConnection.m
//  CarPooling
//
//  Created by atk's mac on 26/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection

- (NSData*)ServerCall:(NSString*)url post:(NSString*)postStrings
{
    NSLog(@"Server Request started");
    
   NSURLResponse *response;
    NSError *err;
    NSData *postData = [postStrings  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSLog(@"Url %@",url);
    NSLog(@"post %@",postStrings);
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&err];
    //  NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];

  if(!err)
  {
  return responseData;
  }
  else{
  
      return nil;
  }
}

-(float) DistanceDatas:(NSString*)responseData
{
  #define kSearchURLs [NSURL URLWithString:responseData]
        NSData *data= [NSData dataWithContentsOfURL:
                       kSearchURLs];
    NSError *jsonParsingError;
    NSDictionary *RouteDistance= [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0 error:&jsonParsingError];
    //   NSLog(@"Distance Api%@",RouteDistance);
    NSArray *Rows= [RouteDistance objectForKey:@"rows"];
    NSDictionary *rowPos=[Rows objectAtIndex:0];
    NSArray *Elements= [rowPos objectForKey:@"elements"];
    NSDictionary *elementPos=[Elements objectAtIndex:0];
    NSDictionary *distance=[elementPos objectForKey:@"distance"];
    NSString *distValue=[distance objectForKey:@"value"];
    
    int value=[distValue intValue];
    float distances=value/1000;
    return  distances;
}

@end
