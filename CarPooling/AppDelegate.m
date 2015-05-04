//
//  AppDelegate.m
//  CarPooling
//
//  Created by atk's mac on 23/07/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <HockeySDK/HockeySDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
        // Override point for customization after application launch.
    [GMSServices provideAPIKey:kGoogleMapsAPIKey];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"2762ac4e4f46d0fb40d3333cca4dc58c"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    [[BITHockeyManager sharedHockeyManager].crashManager setEnableMachExceptionHandler: YES];
    
    
    
    
    
    UIColor * yellow =[UIColor colorWithRed:237.0f/255.0f green:181.0f/255.0f blue:0.0f/255.0f alpha:1];
    [[UINavigationBar appearance] setBarTintColor:yellow];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    LoginViewController *logVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logVC];
    
    [self.window setRootViewController:nav];
    
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
   NSString *userid = [defaults objectForKey:@"id"];
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", devToken);
  //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:devToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//[alert show];

    NSString *isLoggedIn;
    isLoggedIn=[defaults stringForKey:@"isLogged"];
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    
    [defaults1 setObject:devToken forKey:@"token"];
    [defaults1 synchronize];
//
//    if([isLoggedIn isEqualToString:@"true"] && ![isLoggedIn isKindOfClass:[NSNull class]] )
//    {
//
//     NSLog(@"My userid is: %@", userid);
//    NSLog(@"My token is: %@", deviceToken);
//    NSString *devToken = [[[[deviceToken description]
//                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                           stringByReplacingOccurrencesOfString:@">" withString:@""]
//                          stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSLog(@"My token is: %@", devToken);
//    
//    NSLog(@"Authentication Login With Server Started");
//    NSLog(@"\n{");
//    
//    
//    NSString * PostString = [NSString stringWithFormat:@"userId=%@&token=%@",userid,devToken];
//    
//    
//    BinSystemsServerConnectionHandler *AuthenticationServer  = [[BinSystemsServerConnectionHandler alloc]initWithURL:kServerLink_saveDevicetoken PostData:PostString];
//    
//    //specify the request method in first argument
//    [AuthenticationServer StartServerConnectionWithCompletionHandler:@"POST" :^(NSDictionary *JSONDict) {
//        
//        
//        NSDictionary *data = JSONDict;
//        
//        
//   
//       
//        
//        
//        NSString *result=[data objectForKey:@"status"];
//        
//        
//        if([result isEqualToString:@"success"])
//        {
//            
//                      //  [self ShowAlertView:result];
//        }
//        else if([result isEqualToString:@"Invalid"]){
//            
//        }
//        
//        [WTStatusBar setLoading:NO loadAnimated:NO];
//        
//        [WTStatusBar clearStatus];
//        
//        
//        
//        
//        
//        
//        
//    } FailBlock:^(NSString *Error) {
//        
//        
//        
//        
//    }];
//}
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
