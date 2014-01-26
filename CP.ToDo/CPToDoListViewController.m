//
//  CPToDoListViewController.m
//  CP.ToDo
//
//  Created by Jonathan Xu on 1/25/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPToDoListViewController.h"
#import "CPToDoCell.h"

@interface CPToDoListViewController ()
@property (strong, nonatomic) NSMutableArray *toDoList;
@end

@implementation CPToDoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.toDoList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add
- (IBAction)touchAdd:(id)sender
{
    [self.toDoList insertObject:@"" atIndex:0];

    // Do not use UITableView's reloadData here.
    // It interferes with cell being active edited which needs to be saved using an out-of-date tag index.
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[firstIndexPath] withRowAnimation:UITableViewRowAnimationTop];

    // update tag for all rows on screen
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *currPath in visibleIndexPaths) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:currPath];
        CPToDoCell *toDoCell = ((CPToDoCell *)cell);
        toDoCell.toDoTextView.tag = currPath.row;
    }
    
    // set focus on first row and bring up keyboard
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:firstIndexPath];
    CPToDoCell *toDoCell = ((CPToDoCell *)cell);
    [toDoCell.toDoTextView becomeFirstResponder];
}

- (IBAction)touchEdit:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    if ([button.title isEqualToString:@"Edit"]) {
        button.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    } else {
        button.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CPToDoCell *toDoCell = ((CPToDoCell *)cell);
    
    NSLog(@"UITableViewCell width %.01f, height %.01f", toDoCell.bounds.size.width, toDoCell.bounds.size.height);
    NSLog(@"UITextView width %.01f, height %.01f", toDoCell.toDoTextView.bounds.size.width, toDoCell.toDoTextView.bounds.size.height);
    NSLog(@"UITextView font %@", toDoCell.toDoTextView.font);
    
    toDoCell.toDoTextView.text = (NSString *)[self.toDoList objectAtIndex:indexPath.row];
    // tag will be used to identify row index when textFieldDidEndEditing is fired
    toDoCell.toDoTextView.tag = indexPath.row;
    // set up delegate to this controller
    toDoCell.toDoTextView.delegate = self;
    
    NSLog(@"CPToDoListViewController.tableView:cellForRowAtIndexPath: index %d, %@",
          indexPath.row, toDoCell.toDoTextView.text);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoList removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"CPToDoListViewController.moveRowAtIndexPath: from %d to %d",
          fromIndexPath.row, toIndexPath.row);
    
    NSString *temp = self.toDoList[toIndexPath.row];
    self.toDoList[toIndexPath.row] = self.toDoList[fromIndexPath.row];
    self.toDoList[fromIndexPath.row] = temp;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.toDoList[indexPath.row];
    
    // subtract tableView padding from padding
    float width = self.tableView.bounds.size.width - 20;
    
    // Get a stock UITextView to calculate padding
    UITextView *textView = [[UITextView alloc] init];
    float textViewPadding = textView.textContainer.lineFragmentPadding * 2;
    width -= textView.textContainer.lineFragmentPadding * 2;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    
    // add UITextView padding, and UITableViewCell height padding
    float height = ceil(frame.size.height + textViewPadding) + 20;
    
    NSLog(@"CPToDoListViewController.tableView:heightForRowAtIndexPath: index %d, height %0.0f, padding %0.01f", indexPath.row, height, textViewPadding);
    
    return height;
}

#pragma mark - UITextFieldDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"CPToDoListViewController.textViewDidChange: row %d", textView.tag);
    if (textView.tag < [self.toDoList count]) {
        self.toDoList[textView.tag] = textView.text;
        NSLog(@"CPToDoListViewController.textViewDidChange: row %d, new value %@",
              textView.tag, textView.text);

        // when text change, update tableView to cause it to recalculate height and redraw
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

// Return should dismiss keyboard, not allow blank new lines
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    if ([text rangeOfCharacterFromSet:newlines].location == NSNotFound) {
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}

@end
