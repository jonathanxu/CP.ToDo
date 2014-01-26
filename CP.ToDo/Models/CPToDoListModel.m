//
//  CPToDoListModel.m
//  CP.ToDo
//
//  Created by Jonathan Xu on 1/26/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPToDoListModel.h"

@interface CPToDoListModel()
@property (strong, nonatomic) NSMutableArray *toDoList;
@property (nonatomic) BOOL dirty;
@end

@implementation CPToDoListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.toDoList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)count
{
    return self.toDoList.count;
}

- (NSString *)getTodoAtIndex:(NSUInteger)index
{
    return [self.toDoList objectAtIndex:index];
}

- (void)addNewToDo
{
    [self.toDoList insertObject:@"" atIndex:0];
    [self markDirty];
}

- (void)updateAtIndex:(NSUInteger)index newValue:(NSString *)value
{
    NSString *currValue = (NSString *)self.toDoList[index];
    if (![currValue isEqualToString:value]) {
        self.toDoList[index] = value;
        [self markDirty];
    }
}

- (void)removeToDoAtIndex:(NSUInteger)index
{
    [self.toDoList removeObjectAtIndex:index];
    [self markDirty];
}

- (void)moveToDoFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    NSString *temp = self.toDoList[fromIndex];
    [self.toDoList removeObjectAtIndex:fromIndex];
    [self.toDoList insertObject:temp atIndex:toIndex];
    [self markDirty];
}

- (void)markDirty
{
    self.dirty = YES;
}

- (void)persist
{
    
}

@end
