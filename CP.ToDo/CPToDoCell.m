//
//  CPToDoCell.m
//  CP.ToDo
//
//  Created by Jonathan Xu on 1/25/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPToDoCell.h"

@interface CPToDoCell()
@end

@implementation CPToDoCell

@synthesize toDoValue = _toDoValue;

- (void)setToDoValue:(NSString *)toDoValue
{
    _toDoValue = toDoValue;
    self.toDoTextField.text = _toDoValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
