---
layout: post
title: Table view
tags:
- cellForRowAtIndexPath
- mutable array
- reloadData
- table
- table view controller
- tableview
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
So table views are a bit more trouble than I thought they'd be. As the second view in the tab bar, I want to display a table view with each item in a row. Tapping on a row should go to an item screen with more details and some actions. Currently, the items are added to a mutable array (probably to move to a database when I get around to learning how to implement one). The items are 'food' objects with a number of properties, the key one being the name which is in the property 'food'.

I initially thought that I could create an instance of a table object, pass it the array and tell the table how to arrange the array in rows and columns, as well as what to do when clicked. Not quite so easy. Turns out there's a whole heap of pieces that need to be implemented to get this working, not many of which are intuitive. First up is making sure the file knows that it's working on a table, so the .h file needs to include

    @interface TrackingTableViewController : UITableViewController

After this, there's a set of functions that need to be implemented. I found these out through much Googling and trawling Apple documentation, but mostly ended up keeping the bare bones structure of the functions. The fuctions that were basically copypasta included:

    - (id)initWithStyle:(UITableViewStyle)style
    - (void)viewDidLoad
    - (void)viewDidUnload
    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

The prototype functions I left commented out, most of which I believe are editing functions, included:

    - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
    - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
    - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
    - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath

The trickiest part (for now) was to work out how to get the data from the array to the cells. I eventually caught on to how the `tableView:cellForRowAtIndexPath:` was meant to work, in addition to the concept of recycling table cells. I'm still not completely au fait with this concept, but on the face of it, it looks like once a cell is scrolled off screen, it is then reused for the cell coming up on to the screen (rather than generating cells for every row, onscreen or off). With that in mind, the function turned out to look like:

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [tableView 
                                 dequeueReusableCellWithIdentifier:@"ReuseCell"];
        TrackingFood *food = [self.tableViewArray objectAtIndex:indexPath.row];
        cell.textLabel.text = food.food;
        cell.detailTextLabel.text = food.reminder;
        return cell;
    }

Not to forget setting the number of rows required:

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return [self.tableViewArray count];
    }

And there was a table! This was a long time coming in itself, but a problem quickly became apparent - once the table was generated and displayed once, adding new items to the array didn't show up in the table. Turns out that the table needed to be reloaded. How? Well, it seemed to be linked to the `tableView reloadData` function, but how to call it? On viewDidLoad was the first thought, but again, this only works on the first time the page is created, so no go there. So if viewDidLoad happens on the first visit, what happens when you move to that view after the first time? viewWillAppear, apparently. This seemed to do the trick:

    - (void)viewWillAppear:(BOOL)animated
    {
        //    [tableView reloadData];
        [self loadArray];
        [self.tableView reloadData];
    }

So finally:
- I had a table
- It filled with the array data
- It reloaded that data and updated the display each time it was shown

The next challenge? Creating a new view to display item details for an item selected in the table. More on that soon, but the main problem was how to pass the correct item and its data from the table view to the new item view, particularly when I have no idea what the table is called or how to address it!
