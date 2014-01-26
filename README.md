## CP.ToDo

CodePath iOS class week 2 assignment: a simple TODO List application.

Implementation Notes:
- Use a UITableViewController backed by CPToDoListViewController
- Use a custom UITableViewCell backed by CPToDoCell
  - it has a UITextView which user can input text values for their TODOs
- A "+" Bar Button Item is used to add a new TODO cell at top of list, and automatically becomes the first responder and brings up keyboard
 - not using UITableView's reloadData because it introduces strange interaction if there is a cell being actively edited. The active cell has delegate callback that requires saving of its value using UITableViewCell's UITextView's tag property, and requires UITableView's update to redraw current cell as its content gets longer or shorter.
 - instead, inject a row directly into the UITableView, and update tag property for all UITextView inside visible UITableViewCell.
- CPToDoCell's UITextView's delegate is set to CPToDoListViewController
  - CPToDoListViewController uses UITextView's tag property to update its internal NSMutableArray which holds the TODO list
  - CPToDoListViewController implements `textView:shouldChangeTextInRange:replacementText` in order to dismiss keyboard on return
- UITableView's tableView:heightForRowAtIndexPath quite tricky
  - use NSString's boundingRectWithSize:options:attributes:context to calculate a CGRect
  - add UITextView's lineFragmentPadding
  - add UITableViewCell's padding, which was set up as auto layout constraints
  - had to call UITableView's beginUpdates and endUpdates after UITextView's content changed.