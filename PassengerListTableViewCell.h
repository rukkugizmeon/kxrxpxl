//
//  PassengerListTableViewCell.h
//  CarPooling
//
//  Created by atk's mac on 12/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassengerListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noField;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;


@end
