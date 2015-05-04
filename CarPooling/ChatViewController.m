//
//  ChatViewController.m
//  CarPooling
//
//  Created by Gizmeon Technologies on 12/12/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "ChatViewController.h"

#import "ChatCells.h"

@interface ChatViewController ()
{
    NSString * roomName;
    NSString * myName;
    NSString * myId;
}
@property SIOSocket *socket;

@end

    NSMutableArray *arrayChatContents,*arrayColors,*arrayUsers;
    


@implementation ChatViewController
@synthesize roomDetails;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //  room:'ROOMNAMEKANNUR', message:'HELLO KANNUR'
    
    
    myName =[prefs stringForKey:@"name"];
    myId = [prefs stringForKey:@"id"];
    
  

    
    UIColor *u0=[UIColor colorWithRed:0.84 green:0.91 blue:0.78 alpha:1];
    UIColor *u1=[UIColor colorWithRed:0.99 green:0.85 blue:0.16 alpha:1];
    UIColor *u2=[UIColor colorWithRed:0.63 green:0.75 blue:0.93 alpha:1];
    UIColor *u3=[UIColor colorWithRed:0.31 green:0.5 blue:0.14 alpha:1];
    UIColor *u4=[UIColor colorWithRed:0.9 green:0.44 blue:0.48 alpha:1];
  


    arrayColors= [[NSMutableArray alloc]initWithObjects:u0,u1,u2,u3,u4, nil];
    
    
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:arrayColors[0],@"color",myName,@"name",myId,@"originator_id", nil];
    
    [arrayUsers addObject:dic];
    
    
    arrayUsers =[[NSMutableArray alloc]initWithObjects:myName, nil];
    
    self.navigationItem.title = [roomDetails valueForKey:@"route"];
    self.navigationItem.hidesBackButton = NO;
    
    roomName = [[roomDetails valueForKey:@"journey_id"] stringValue];
 
    _tableViewChatView.delegate=self;
    _tableViewChatView.dataSource=self;
    arrayChatContents = [NSMutableArray new];
    
    roomName=@"592";
    
    [SIOSocket socketWithHost: @"http://chat1.ridewithme.in:8000" response: ^(SIOSocket *socket)
     {
         self.socket = socket;
         
         __weak typeof(self) weakSelf = self;
         __weak typeof(roomName) weakRoomName = roomName;
         self.socket.onConnect = ^()
         {
             
             NSLog(@"Connected");
             
             [weakSelf.socket emit:@"subscribe" args:[NSArray arrayWithObjects:weakRoomName, nil]];
             
             
             
         };
         
         self.socket.onDisconnect=^()
         {
             NSLog(@"Disconnected");
         };
         
         
         //  [weakSelf.socket emit:@"subscribe" args:[NSArray arrayWithObjects:roomName, nil]];
         
         
        [self.socket on: roomName callback: ^(SIOParameterArray *args)
        
         {
              
           //   @try {
                 NSString * msg = [args[0] valueForKey:@"message"];
             NSString * sender = [args[0] valueForKey:@"originator"];
             
//             BOOL Found = false;
//             NSDictionary * dicForColor;
//             
//             for (int i = 0; i<arrayUsers.count;i++) {
//                 
//                 if (Found) {
//                     
//                     break;
//                     
//                 }
//                 
//                 if (![[arrayUsers[i] valueForKey:@"name"] isEqualToString:sender]) {
//                     
//                     
//                     
//                     Found=true;
//                 }
//                 
//                 
//             }
//             
//             if (!Found) {
//                 
//                 dicForColor = [[NSDictionary alloc]initWithObjectsAndKeys:arrayColors[arrayUsers.count+1],@"color",myName,@"name",myId,@"originator_id", nil];
//                 
//             }
             
             
                  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:sender,@"Sender",msg,@"message", nil];
                  
                  if (![msg isEqualToString:@""]) {
                      
                      
                      [arrayChatContents addObject:dic];
                      
                      [_tableViewChatView reloadData];
                      
                      
                      [self goToBottom];
                  }

                  
                  
                  
                  
                  
             // }
         //     @catch (NSException *exception) {
                  
          //    }
          //    @finally {
                  
                  
                  NSLog(@"Inside finally: chat room, array index OB");
           //   }
              
           
              
              
          }];
         
         
     }];
}

#pragma Table View Delegates

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    
    
    
    return arrayChatContents.count;
   
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCells *incomingCell=(ChatCells*)[tableView dequeueReusableCellWithIdentifier:@"incommingCell"];
    ChatCells *outgoingCell=(ChatCells*)[tableView dequeueReusableCellWithIdentifier:@"outgoingCell"];
    
    
    if (incomingCell == nil || outgoingCell ==nil) {
        
         NSArray *cell_array = [[NSBundle mainBundle]loadNibNamed:@"ChatCells" owner:self options:nil];
               if (![[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"Sender"] isEqualToString:@"You"]) {
            
            incomingCell = [cell_array objectAtIndex:0];
        }
        else
        {
            outgoingCell=[cell_array objectAtIndex:1];
        }
    }

    NSString *userRealName=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"Sender"];

    
        if ([userRealName isEqualToString:@"You"] || [userRealName isEqualToString:myName]) {
            outgoingCell.labelYourName.text=@"You";
            outgoingCell.labelYourMessage.text=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"message"];
            outgoingCell.backgroundColor=[arrayColors objectAtIndex:0];
            return outgoingCell;

        }else if([userRealName isEqualToString:[arrayUsers[1]valueForKey:@"name"]]){
            
            incomingCell.labelSenderName.text=userRealName;
            
            incomingCell.labelSenderMessage.text=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"message"];
            incomingCell.backgroundColor=[arrayColors objectAtIndex:1];
            
            return incomingCell;
            
        }else if([userRealName isEqualToString:[arrayUsers[2]valueForKey:@"name"]]){
            incomingCell.labelSenderName.text=userRealName;
            
            incomingCell.labelSenderMessage.text=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"message"];
            incomingCell.backgroundColor=[arrayColors objectAtIndex:2];
            
            return incomingCell;

            
        }else if([userRealName isEqualToString:[arrayUsers[3]valueForKey:@"name"]]){
            incomingCell.labelSenderName.text=userRealName;
            
            incomingCell.labelSenderMessage.text=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"message"];
            incomingCell.backgroundColor=[arrayColors objectAtIndex:3];
            
            return incomingCell;

        }else{
            
            incomingCell.labelSenderName.text=userRealName;
            
            incomingCell.labelSenderMessage.text=[[arrayChatContents objectAtIndex:indexPath.row] valueForKey:@"message"];
            incomingCell.backgroundColor=[arrayColors objectAtIndex:4];
            
            return incomingCell;

            
        }
        
        

   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
        

    
}

#pragma Button Actions

- (IBAction)ActionSend:(id)sender {
    if (![_textFieldSendText.text isEqualToString:@""]) {
        
    
   NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  //  room:'ROOMNAMEKANNUR', message:'HELLO KANNUR'
        
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:roomName, @"room",[prefs stringForKey:@"name"],@"originator",_textFieldSendText.text, @"message", nil];
        
        
        
    [self.socket emit:@"message" args:[NSArray arrayWithObjects:newDatasetInfo, nil]];
        
        NSString * msg = _textFieldSendText.text;
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"You",@"Sender",msg,@"message", nil];
        
    [arrayChatContents addObject:dic];
    _textFieldSendText.text=@"";
    [_tableViewChatView reloadData];
    
    [self goToBottom];
    }
}

#pragma mark - Private Methods

-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [_tableViewChatView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [_tableViewChatView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [_tableViewChatView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}
@end
