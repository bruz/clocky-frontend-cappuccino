@import <AppKit/CPView.j>

@implementation SessionItemView : CPView
{
    CPTextField dateRange;
}

- (void)setRepresentedObject:(id)anObject
{    
    if (!dateRange)
    {
        dateRange = [[CPTextField alloc] initWithFrame:CGRectMake (0.0, 0.0, 300.0, 20.0)];
        
        [dateRange setFont:[CPFont boldSystemFontOfSize:12.0]];
        [self addSubview:dateRange];
    }
        
    [dateRange setStringValue:[anObject dateRange]];
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor colorWithHexString:"3d80df"] : nil];
    [dateRange setTextColor:isSelected ? [CPColor whiteColor] : [CPColor blackColor]];
}

@end
