@import <AppKit/CPTextField.j>

@implementation ProjectTextField : CPTextField
{
    ProjectsController projectsController @accessors;
    CPString fieldName;
    Project currentProject;
}

- (id)initWithFrame:(CGRect)aFrame name:(CPString)aFieldName
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
	fieldName = aFieldName;
	[[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didSelectProject:)
            name:@"didSelectProject"
            object:nil]; 
	
    }

    return self;
}

- (void)didSelectProject:(CPNotification)aNotification
{
    currentProject = [[aNotification object]
valueForKey:@"_currentProject"];
    [self setObjectValue:[currentProject valueForKey:fieldName]];
} 

- (void)textDidEndEditing:(CPNotification)note
{
    
}

@end
