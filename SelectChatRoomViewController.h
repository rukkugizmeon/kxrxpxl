//
//  SelectChatRoomViewController.h
//  CarPooling
//
//  Created by Gizmeon Technologies on 15/12/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectChatRoomViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewChatRooms;

@end
