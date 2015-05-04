//
//  PGOrder.h
//  PaymentsSDK
//
//  Created by Mahadevaprabhu K S on 06/05/13.
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 PGOrder is a model class for Payment detail, which holds certain necessary parameters will be used by the SDK.
 It can also be used in the merchant app to maintain Order Details.
 */

@interface PGOrder : NSObject

@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *eMail;
@property (nonatomic, copy) NSString *mobile;


+ (PGOrder *)orderForOrderID:(NSString *)orderID
                  customerID:(NSString *)customerID
                      amount:(NSString *)amount
                customerMail:(NSString *)eMail
              customerMobile:(NSString *)mobile;

@end
