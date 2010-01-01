@import <AppKit/CPCollectionView.j>

@implementation SessionListView : CPCollectionView
{
    CPCollectionViewItem itemPrototype;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        [self setMinItemSize:CGSizeMake(CGRectGetWidth([self bounds]), 20)];
        [self setMaxItemSize:CGSizeMake(CGRectGetWidth([self bounds]), 20)];
    
        itemPrototype = [[CPCollectionViewItem alloc] init];
        [itemPrototype setView:[[SessionItemView alloc] initWithFrame:CGRectMakeZero()]];
        [self setItemPrototype:itemPrototype];

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
    var currentProject = [[aNotification object]
valueForKey:@"_currentProject"];
    [self setContent:[currentProject projectSessions]] ;
} 

- (id)getCurrentObject
{
    return [[self content] objectAtIndex:[self getSelectedIndex]] ;
}

- (int)getSelectedIndex
{
    return [[self selectionIndexes] firstIndex] ;
}

@end
