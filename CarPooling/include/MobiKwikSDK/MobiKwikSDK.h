//
//  MobiKwikSDK.h
//  MobiKwikSDK
//
//  Created by One MobiKwik Systems on 19/12/13.
//  Copyright (c) 2013 One Mobikwik Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobiKwikSDK : NSObject

-(void)StartTransaction_withData:(NSDictionary *)TxnData;


-(NSString *)getMeMerchantName;
-(NSString *)getMeMerchantid;
-(NSString *)getMeMerchanturl;
-(NSString *)getUserAmount;
-(NSString *)getUserEmailID;
-(NSString *)getUserPhoneNO;
-(NSString *)getMeChecksumURL;
-(NSString *)getMeFetchSavedCardURL;
-(NSString *)getMeOrderID;
-(NSString *)getMeSDKsign;
-(NSString *)getMeMode;
-(NSString *)getMeDebitWallet;
-(NSString *)getMeMerchCardNo;
-(NSString *)getMeMerchExpMon;
-(NSString *)getMeMerchExpYer;
-(NSString *)getMeMerchCVV;
-(NSString *)getMeMerchCardID;


-(void)defaultValues;

-(NSMutableDictionary *)showPaymentResponse;

@end
