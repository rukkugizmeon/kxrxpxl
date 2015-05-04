//
//  SelectChatRoomViewController.m
//  CarPooling
//
//  Created by Gizmeon Technologies on 15/12/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "SelectChatRoomViewController.h"
#import "REFrostedViewController.h"
#import "ChatViewController.h"
#import "ServerConnection.h"
#import "DefineMainValues.h"
#import "WTStatusBar.h"

@interface SelectChatRoomViewController ()

@end
NSArray *arrayRooms;
@implementation SelectChatRoomViewController
{
    UIAlertView * alertPleaseWait;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
   
    
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [alertPleaseWait show];
    alertPleaseWait = [[UIAlertView alloc]initWithTitle:kApplicationName message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    self.navigationItem.title = @"Select Room";
    self.navigationItem.hidesBackButton = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"menuIcon.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0,30,20);
    UIBarButtonItem *slideButton =[[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(sliders:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = slideButton;
    
    
    arrayRooms = [NSMutableArray new];
    
    _tableViewChatRooms.dataSource=self;
    _tableViewChatRooms.delegate=self;
    
    
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    NSString *userId=[prefs stringForKey:@"id"];
    NSString *userRole=[prefs stringForKey:@"role"];

    
    
    
    
    NSString *postString = [NSString stringWithFormat:@"userId=%@&userRole=%@",userId,userRole];
    
    
    
    [alertPleaseWait show];
    
    [WTStatusBar setLoading:YES loadAnimated:YES];
    
    
   // NSString * PostString = [NSString stringWithFormat:@"user_id=%@",userId];
    
   
    NSLog(@"postString %@",postString);
    
    NSData *postData = [postString  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ridewithme.in/index.php?r=JourneyRequests/GetRouteNames"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    @try {
        dispatch_async(kBgQueue, ^{
            NSError *err;
            NSURLResponse *response;
            NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            if(!err)
            {
                [self performSelectorOnMainThread:@selector(processServerRequestWith:)
                                       withObject:data waitUntilDone:YES];
            }else{
                
                [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
                [self ShowAlertView:UnableToProcess];
                [WTStatusBar setLoading:NO loadAnimated:NO];
                [WTStatusBar clearStatus];
                
            }
        });
            
            
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
        
        NSLog(@"Entered in Finally block: Chat Room");
        
    }
    
       
    
    
    
    

}
-(void) processServerRequestWith : (NSData *) responseData
{
    [alertPleaseWait dismissWithClickedButtonIndex:0 animated:YES];
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Response %@",data);
    NSString *result=[NSString stringWithFormat:@"%@",[data objectForKey:@"status"]];
    
    if ([result isEqualToString:@"success"]) {
        
        
        arrayRooms = [data valueForKey:@"result"];
        
        if (arrayRooms.count>0) {
            
            [_tableViewChatRooms reloadData];
            
        }else{
            
            [self ShowAlertView:@"No chat Rooms Found"];
            
        }
        
        
        
    }else{
        
        
        [self ShowAlertView:@"Failed to load data"];
        
        
    }
    
    [WTStatusBar setLoading:NO loadAnimated:NO];
    [WTStatusBar clearStatus];

}

-(void)sliders:(id)sender
{
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return arrayRooms.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;// = [tableView dequeueReusableCellWithIdentifier:@"none"];
    
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
        
    }
    
    
    cell.textLabel.text=[[arrayRooms objectAtIndex:indexPath.row] valueForKey:@"route"];
    
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *VC =  [self.storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    
    VC.roomDetails=[arrayRooms objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
-(void)ShowAlertView:(NSString*)Message{
    [WTStatusBar clearStatus];
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}
@end
