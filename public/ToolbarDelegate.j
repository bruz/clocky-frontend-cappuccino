@import <Foundation/CPObject.j>

var AddToolbarItemIdentifier    = "AddToolbarItemIdentifier",
    RemoveToolbarItemIdentifier = "RemoveToolbarItemIdentifier";

@implementation ToolbarDelegate : CPObject
{
    ProjectsController projectsController @accessors;
}

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
    return [AddToolbarItemIdentifier, RemoveToolbarItemIdentifier];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   return [AddToolbarItemIdentifier, RemoveToolbarItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag
{
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
	var mainBundle = [CPBundle mainBundle];

    if (anItemIdentifier === AddToolbarItemIdentifier)
    {
    	var image = [[CPImage alloc] initWithContentsOfFile:[mainBundle pathForResource:@"add.png"] size:CPSizeMake(30, 25)];
    	var highlighted = [[CPImage alloc] initWithContentsOfFile:[mainBundle pathForResource:@"addHighlighted.png"] size:CPSizeMake(30, 25)];

    	[toolbarItem setImage:image];
    	[toolbarItem setAlternateImage:highlighted];

        [toolbarItem setTarget:projectsController];
        [toolbarItem setAction:@selector(addItem:)];
    	[toolbarItem setLabel:"Add a project"];

    	[toolbarItem setMinSize:CGSizeMake(32, 32)];
    	[toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier === RemoveToolbarItemIdentifier)
    {
    	var image = [[CPImage alloc] initWithContentsOfFile:[mainBundle pathForResource:@"remove.png"] size:CPSizeMake(30, 25)];
    	var highlighted = [[CPImage alloc] initWithContentsOfFile:[mainBundle pathForResource:@"removeHighlighted.png"] size:CPSizeMake(30, 25)];

    	[toolbarItem setImage:image];
    	[toolbarItem setAlternateImage:highlighted];

        [toolbarItem setTarget:projectsController];
        [toolbarItem setAction:@selector(removeSelectedItem:)];
    	[toolbarItem setLabel:"Remove project"];

    	[toolbarItem setMinSize:CGSizeMake(32, 32)];
    	[toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    
    return toolbarItem;
}

@end
