@import <AppKit/CPView.j>

@implementation ProjectItemView : CPView
{
    CPTextField name;
    CPString _currentProject;
}

- (void)setRepresentedObject:(id)anObject
{    
    [self setValue:anObject forKey:@"_currentProject"];
    

    if (!name)
    {
        name = [[CPTextField alloc] initWithFrame:CGRectMake (0.0, 0.0, 200.0, 20.0)];
        
        [name setFont:[CPFont boldSystemFontOfSize:12.0]];
        [self addSubview:name];
    }
        
    [name setStringValue:[anObject name]];
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor colorWithHexString:"3d80df"] : nil];
    [name setTextColor:isSelected ? [CPColor whiteColor] : [CPColor blackColor]];
    [[CPNotificationCenter defaultCenter] postNotificationName:@"didSelectProject" object:self]; 
}

@end
