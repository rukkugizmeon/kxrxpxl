//
//  ChatViewController.h
//  CarPooling
//
//  Created by Gizmeon Technologies on 12/12/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "SIOSocket.h"

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableViewChatView;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSendText;

- (IBAction)ActionSend:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong,nonatomic) NSDictionary * roomDetails;


@end
