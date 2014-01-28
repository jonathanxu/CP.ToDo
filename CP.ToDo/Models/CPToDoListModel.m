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
@property (strong, nonatomic) NSString *persistPath;
@end

@implementation CPToDoListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir = [path objectAtIndex:0];
        NSString *docPath = [dir stringByAppendingString:@"todolist"];
        self.persistPath = docPath;
        
        self.toDoList = [self load];
        if (self.toDoList) {
            NSLog(@"CPToDoListModel.init: loaded existing");
        } else {
            self.toDoList = [[NSMutableArray alloc] init];
            NSLog(@"CPToDoListModel.init: new");
        }
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

#pragma mark - persistence

- (void)markDirty
{
    self.dirty = YES;
    [self persist];
}

- (NSMutableArray *)load
{
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:self.persistPath] mutableCopy];
}

- (void)persist
{
    if (self.dirty) {
        if ([NSKeyedArchiver archiveRootObject:self.toDoList toFile:self.persistPath]) {
            self.dirty = NO;
            NSLog(@"CPToDoListModel.persist: success.");
        } else {
            NSLog(@"CPToDoListModel.persist: failure.");
        }
        
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.toDoList];
//        NSMutableArray *restored = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    }
}

@end
