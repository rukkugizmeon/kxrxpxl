//
//  CredentialManager.h
//  Lubna
//
//  Created by Febin Babu Cheloor on 24/05/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialManager : NSObject


+(BOOL)SaveCredentialsOffline:(NSDictionary*)Credentials;
+(NSDictionary*)FetchCredentailsSavedOffline;

+(BOOL)SignOutCredentials;


@end
