//
//  InterfaceManager.m
//  Lubna Foods
//
//  Created by Febin Babu Cheloor on 25/02/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//

#import "InterfaceManager.h"

@implementation InterfaceManager


#pragma mark Singleton Methods

@synthesize backgroundImage;

+ (id)sharedInterfaceManager{
    
    static InterfaceManager *sharedInterfaceMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInterfaceMgr = [[self alloc] init];
    });
    return sharedInterfaceMgr;
}

- (id)init {
    if (self = [super init]) {
        
        backgroundImage = [UIImage imageNamed:@"BackgroundPattern"];
        
    }
    return self;
}


+(void)DisplayAlertWithMessage:(NSString *)Message{

    UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:kApplicationName message:[NSString stringWithFormat:@"\n%@\n",Message] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alert show];
}

-(void)test:(UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}



@end
