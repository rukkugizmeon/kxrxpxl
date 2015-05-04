    //
//  CredentialManager.m
//  Lubna
//
//  Created by Febin Babu Cheloor on 24/05/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import "CredentialManager.h"
#import "FDKeychain.h"
#import "DefineMainValues.h"

@import Security;

@implementation CredentialManager

+(BOOL)SaveCredentialsOffline:(NSDictionary*)Credentials{
    
    if (Credentials[@"username"]&& Credentials[@"password"]) {
        
        NSError * OperationError = nil;
    
  
        
        
        [FDKeychain saveItem: Credentials[@"username"] forKey: @"username" forService: kKeyChainCredStoreID error:&OperationError];
        
        [FDKeychain saveItem: Credentials[@"password"] forKey: @"password" forService: kKeyChainCredStoreID error:&OperationError];
        
        [FDKeychain saveItem: Credentials[@"UserId"] forKey: @"UserId" forService: kKeyChainCredStoreID error:&OperationError];
        
        [FDKeychain saveItem: Credentials[@"Token"] forKey: @"Token" forService: kKeyChainCredStoreID error:&OperationError];
       
        NSLog(@"Password__%@___%@",Credentials[@"UserId"] ,Credentials[@"password"] );
        
        return OperationError == nil ? YES : NO;
    
    }

    return NO;
}

+(NSDictionary*)FetchCredentailsSavedOffline {
    
      NSError * OperationError = nil;

    NSString *password = [FDKeychain itemForKey:@"password" forService:kKeyChainCredStoreID error:&OperationError];
    NSString *username = [FDKeychain itemForKey:@"username" forService:kKeyChainCredStoreID error:&OperationError];
     NSString * UserId = [FDKeychain itemForKey:@"UserId" forService:kKeyChainCredStoreID error:&OperationError];
     NSString *Token= [FDKeychain itemForKey:@"Token" forService:kKeyChainCredStoreID error:&OperationError];
    
    NSLog(@"Password__%@___%@",UserId,password);
    
    if (username
        &&password
        && OperationError == nil) {
        
        return @{@"username": username , @"password" : password,@"UserId" : UserId,@"Token" : Token} ;
    }
    
    return nil;
}

+(BOOL)SignOutCredentials {
    
    NSError * OperationError = nil;
    
    [FDKeychain deleteItemForKey: @"password"
                      forService: kKeyChainCredStoreID error:&OperationError];
    [FDKeychain deleteItemForKey: @"username"
                      forService: kKeyChainCredStoreID error:&OperationError];
    

    return OperationError == nil ? YES : NO;
}

@end
