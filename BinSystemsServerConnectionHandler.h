//
//  BinSystemsServerConnectionHandler.h
//  NGOApp
//
//  Created by Febin Babu Cheloor on 25/01/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ConnectionCompletionBlock) (NSDictionary * JSONDict);
typedef void (^ConnectionFailBlock) (NSString * Error);

@interface BinSystemsServerConnectionHandler : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSURLConnection  * ServerConnection;
@property (strong,nonatomic) NSMutableURLRequest * ServerRequest;
@property (strong,nonatomic) NSMutableData * ResponseData;
@property (strong,nonatomic) NSHTTPURLResponse * HTTPResponse;


@property (strong,nonatomic) NSString * ConnectionURL;
@property (strong,nonatomic) NSString * ConnectionPostData;
@property (strong,nonatomic) NSDictionary * JSONParserDictionary;

@property (assign,nonatomic) BOOL NetworkActivityStatus;

// Blocks iVars

@property (nonatomic,copy) ConnectionCompletionBlock ConnectionSucess;
@property (nonatomic,copy) ConnectionFailBlock ConnectionFail;

- (id)initWithURL:(NSString*)URL PostData:(NSString*)Post;

-(void)DisableNetworkActivityStatus;

-(BOOL)StartServerConnectionWithCompletionHandler:(NSString*)connectionMethod :
(ConnectionCompletionBlock)CompletionBlock
                                        FailBlock: (ConnectionFailBlock)FailBlock ;


@end
