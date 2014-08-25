//
//  RidePointCell.h
//  CarPooling
//
//  Created by atk's mac on 25/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RidePointCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *index;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
