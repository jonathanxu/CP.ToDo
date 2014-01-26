//
//  CPToDoCell.h
//  CP.ToDo
//
//  Created by Jonathan Xu on 1/25/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPToDoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *toDoTextField;
@property (strong, nonatomic) NSString *toDoValue;
@end
