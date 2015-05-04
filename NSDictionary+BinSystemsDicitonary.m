//
//  NSDictionary+BinSystemsDicitonary.m
//  ProjectForDad
//
//  Created by Febin Babu Cheloor on 03/08/13.
//  Copyright (c) 2013 BinSystems. All rights reserved.
//

#import "NSDictionary+BinSystemsDicitonary.h"

@implementation NSDictionary (BinSystemsDicitonary)


- (id)valueForKey:(NSString *)key
         ifKindOf:(Class)class
     defaultValue:(id)defaultValue
{

    id obj = [self objectForKey:key];
    
 //   return [obj isKindOfClass:class] ? obj : defaultValue;
    
    if (obj) {
        
    if (obj && ![obj isKindOfClass:[NSNull class]]) {
        
    if ([obj isKindOfClass:class]) {
        
        //Array
        if (class == [NSArray class]) {
            
            if ([obj count]== 0) {
                return defaultValue;
            }else{
                return obj;
            }
        }
                //Number
        if (class == [NSNumber class]) {
            
            if (obj == nil) {
                return defaultValue;
            }else{
                return [obj stringValue];
            }
        }
        
        //Dicitionary
        
        if (class == [NSDictionary class]) {
            
            if ([[obj allKeys] count]==0
                ) {
                return defaultValue;
            }else{
                return obj;
            }
        }
        
        if (class == [NSString class]) {
            
            if (
                [obj length]==0 ||
                [obj isEqualToString:@" "]
                
                )
                 
            {
                return defaultValue;
            }else{
                return obj;
            }
        }
        
        
    }        
        
    }
    
}
    return defaultValue;
    
    
  
}


@end
