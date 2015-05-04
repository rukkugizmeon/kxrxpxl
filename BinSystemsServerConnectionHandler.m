//
//  BinSystemsServerConnectionHandler.m
//  NGOApp
//
//  Created by Febin Babu Cheloor on 25/01/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import "BinSystemsServerConnectionHandler.h"
#import "NSDictionary+BinSystemsDicitonary.h"
#import "DefineMainValues.h"
#import "CredentialManager.h"

@implementation BinSystemsServerConnectionHandler


@synthesize ServerRequest,ResponseData,HTTPResponse,ConnectionFail,ConnectionURL,ConnectionPostData,ConnectionSucess,JSONParserDictionary,NetworkActivityStatus,ServerConnection;



-(void)DisableNetworkActivityStatus{
    
  self.NetworkActivityStatus =NO;
}

- (id)initWithURL:(NSString*)URL PostData:(NSString*)Post
{
    self = [super init];
    if (self) {
        
        self.ConnectionURL = URL;
        self.ConnectionPostData = Post;
        self.NetworkActivityStatus =YES;
    }
    return self;
}



-(BOOL)StartServerConnectionWithCompletionHandler:(NSString*)connectionMethod :
(ConnectionCompletionBlock)CompletionBlock
                                        FailBlock: (ConnectionFailBlock)FailBlock
{
    
    
    NSLog(@"*****ServerConnectionStarted*****");
    NSLog(@"Checking for Stored Cookies\n\n\n");
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n\n",   [cookie path]);
    }
    NSLog(@"Cookies Check Done\n");
    
    
    if (self.ConnectionURL) {
        
        NSURL * ServerConnectionURL = [NSURL URLWithString:self.ConnectionURL];
        
        if (ServerConnectionURL) {
            
            NSLog(@"Started Server Connection For URL : %@",self.ConnectionURL);
            
            self.ConnectionSucess = CompletionBlock;
            self.ConnectionFail = FailBlock;
            
            if (self.ConnectionPostData) {
                
                NSLog(@"Server Connection Post String :\n\n %@\n\n",self.ConnectionPostData);
                
                
                // Connection  with Post Data
                
                // Create the request.
                
                ServerRequest = [NSMutableURLRequest requestWithURL:ServerConnectionURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServerConnectionTimeOut];
                
                [ServerRequest setHTTPShouldHandleCookies:YES];
                
                              // Specify POST request
                ServerRequest.HTTPMethod = connectionMethod;
                
                NSString * Token =
                [CredentialManager FetchCredentailsSavedOffline][@"Token"];
                
                
              //  [ServerRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                
                [ServerRequest setValue:Token
                     forHTTPHeaderField:@"Authorization"];
                
                
                NSData *requestBodyData = [self.ConnectionPostData dataUsingEncoding:NSUTF8StringEncoding];
                
                ServerRequest.HTTPBody = requestBodyData;
                
                
            }
            
            
            else{
                
                
                ServerRequest = [NSMutableURLRequest requestWithURL:ServerConnectionURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kServerConnectionTimeOut];
                [ServerRequest setHTTPShouldHandleCookies:YES];
                
                
            }

            // Starting the Server Conneciton
            
            ServerConnection = [[NSURLConnection alloc]init];
            (void)[ServerConnection initWithRequest:ServerRequest delegate:self startImmediately:NO];
            
            [ServerConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                        forMode:NSDefaultRunLoopMode];
            
            [ServerConnection start];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.NetworkActivityStatus) ? YES : NO;
            
            return YES;
            
            
        }
        
    }
    
    
    return NO;
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary* Headers =[self.HTTPResponse allHeaderFields];
    NSLog(@" Server Data Header Response :\n%@\n",Headers);
    
    ResponseData = [[NSMutableData alloc] init];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        // Append the new data to the instance variable you declared
    [ResponseData appendData:data];
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    
    NSLog(@"Raw Server Data Recived is \n\n\n__**_____%@____**___\n\n\n",[NSString stringWithUTF8String:[ResponseData bytes]]);
    
    if ([self SerializeJSONData]) {
            
           NSLog(@"\n\nServer Data Recived : \n%@\n\n",self.JSONParserDictionary);
        

        
        if (self.ConnectionSucess) {
            
            self.ConnectionSucess(self.JSONParserDictionary);
            
        }
        else{
            NSLog(@"\n\nInternal Error : Critical - 43200 \n\n");
        }
        
            
        }
    
        else{
            
            NSLog(@"Server Data is Invalid - Not JSON");
            self.ConnectionFail(@"Invalid Server Response : 11002");
        }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    NSString * ErrorLocalDescript = [error localizedDescription];
    NSLog(@"Server Connection Data Error : %@",ErrorLocalDescript);
    
    if (self.ConnectionFail) {
        self.ConnectionFail(ErrorLocalDescript);
    }
}


-(BOOL)SerializeJSONData{
    
    NSError * JsonParseError;

     id SerializedData =[NSJSONSerialization JSONObjectWithData:self.ResponseData options:kNilOptions error:&JsonParseError];
    
 
    if (JsonParseError==nil && SerializedData != nil) {
        
        JSONParserDictionary = SerializedData;
        
        return YES;
        
    }else{
        
        NSLog(@"JSON Parsing Error : %@ ",JsonParseError.localizedDescription);
        return NO;
    }
    
}


@end
