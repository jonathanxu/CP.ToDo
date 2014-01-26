//
//  CPToDoListModel.h
//  CP.ToDo
//
//  Created by Jonathan Xu on 1/26/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPToDoListModel : NSObject
- (NSUInteger)count;
- (NSString *)getTodoAtIndex:(NSUInteger)index;
- (void)addNewToDo;
- (void)updateAtIndex:(NSUInteger)index newValue:(NSString *)value;
- (void)removeToDoAtIndex:(NSUInteger)index;
- (void)moveToDoFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)persist;
@end
