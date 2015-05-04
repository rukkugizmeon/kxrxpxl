//
//  NSDictionary+BinSystemsDicitonary.h
//  ProjectForDad
//
//  Created by Febin Babu Cheloor on 03/08/13.
//  Copyright (c) 2013 BinSystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BinSystemsDicitonary)

- (id)valueForKey:(NSString *)key ifKindOf:(Class)class defaultValue:(id)defaultValue;
@end
