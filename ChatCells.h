//
//  ChatCells.h
//  CarPooling
//
//  Created by Gizmeon Technologies on 15/12/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCells : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelSenderName;
@property (strong, nonatomic) IBOutlet UILabel *labelSenderMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelYourName;
@property (weak, nonatomic) IBOutlet UILabel *labelYourMessage;

@end
