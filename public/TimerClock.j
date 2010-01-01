@import <AppKit/CPTextField.j>
@import <Foundation/CPTimer.j>

@implementation TimerClock : CPTextField
{
    CPTimer timer;
    CPDate startTime;
    CPButton timerButton @accessors;
    SessionsController sessionsController;
}

- (id)initWithFrame:(CGRect)aFrame sessionListView:(SessionListView)aSessionListView
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
	sessionsController = [[SessionsController alloc] init];
	[sessionsController setSessionListView:aSessionListView];
    }

    return self;
}

- (void)toggleTimer
{
    if(!timer || ![timer isValid]) {
	[timerButton setTitle:@"Stop Timer"];
	timer = [CPTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTime:) userInfo:@"" repeats:YES]; 
	startTime = [[CPDate alloc] init];
    	[self updateTime:timer];
    }
    else {
	[timerButton setTitle:@"Start Timer"];
	[timer invalidate];
	var endTime = [[CPDate alloc] init];
	[sessionsController addItem:startTime endTime:endTime];
    }
}

- (void)updateTime:(CPTimer)aTimer
{
    var currentTime = [[CPDate alloc] init];
    var totalSeconds = parseInt( (currentTime - startTime) / 1000 );
    var seconds = totalSeconds % 60;
    var minutes = parseInt(totalSeconds/60) % 60;
    var hours = parseInt(totalSeconds/3600);
    var elapsedTime = [self pad:hours count:2] + ":" + [self pad:minutes count:2] + ":" + [self pad:seconds count:2];

    [self setObjectValue:elapsedTime];
}

- (CPString)pad:(Integer)num count:(Integer)count
{
    var lenDiff = count - String(num).length;
    var padding = "";

    if (lenDiff > 0)
    while (lenDiff--)
    padding += "0";

    return padding + num;
}

@end
