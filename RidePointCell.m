//
//  RidePointCell.m
//  CarPooling
//
//  Created by atk's mac on 25/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "RidePointCell.h"

@implementation RidePointCell

@synthesize index,points,type,date;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
