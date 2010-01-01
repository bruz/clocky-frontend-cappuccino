@import <Foundation/CPObject.j>

@implementation Project : CPObject
{
    CPString name @accessors;
    CPString projectStatus @accessors;
    CPString startDate @accessors;
    CPArray projectSessions @accessors;
    int      id @accessors;
}

- (id)init
{
    self = [super init] ;
    
    if (self)
    {
	id		= 0 ;
        name   		= @"" ;
        projectStatus   = @"" ;
	startDate	= [[CPDate alloc] init] ;
	projectSessions = [[CPArray alloc] init] ;
    }
    
    return self ;
}

- (id)initFromJSONObject:(CPString)aJSONObject
{
    self = [self init] ;
    
    if (self)
    {
	//
	id		= aJSONObject.id ;
        name     	= aJSONObject.name ;
        projectStatus   = aJSONObject.project_status ;
        startDate    	= aJSONObject.start_date ;
	//
	projectSessions = [ProjectSession initFromJSONObjects:aJSONObject.project_sessions] ;

    }
    
    return self ;
}

+ (CPArray)initFromJSONObjects:(CPString)someJSONObjects
{
    var projects   = [[CPArray alloc] init] ;
    
    for (var i=0; i < someJSONObjects.length; i++) {
        var project    = [[Project alloc] initFromJSONObject:someJSONObjects[i].project] ;
        [projects addObject:project] ;
    };
    
    return projects ;
}


+ (CPArray)getExampleProjects
{
    var array   = [[CPArray alloc] init] ;

    var project    = [[Project alloc] init] ;
    [project setId:1] ;
    [project setName:@"Clocky with RestfulX"] ;
    [project setProjectStatus:@"complete"] ;
    [project setStartDate:@"2009-10-01"] ;
    var projectSessions = [[CPArray alloc] init] ;
    var session = [[ProjectSession alloc] init] ;
    [session setStartTime:[[CPDate alloc] initWithString:@"2009/10/01 06:12:00"]] ;
    [session setEndTime:[[CPDate alloc] initWithString:@"2009/10/01 07:32:00"]] ;
    [projectSessions addObject:session] ;
    [project setProjectSessions:projectSessions] ;
    [array addObject:project] ;
     
    var project    = [[Project alloc] init] ;
    [project setId:2] ;
    [project setName:@"Clocky with SproutCore"] ;
    [project setProjectStatus:@"complete"] ;
    [project setStartDate:@"2009-11-01"] ;
    [array addObject:project] ;

    var project    = [[Project alloc] init] ;
    [project setId:3] ;
    [project setName:@"Clocky with Cappuccino"] ;
    [project setProjectStatus:@"started"] ;
    [project setStartDate:@"2009-12-01"] ;
    [array addObject:project] ;

    return array ;
}

@end
