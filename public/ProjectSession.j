@import <Foundation/CPObject.j>

@implementation ProjectSession : CPObject
{
    CPString description @accessors;
    CPDate startTime @accessors;
    CPDate endTime @accessors;
}

- (id)init
{
    self = [super init] ;
    
    if (self)
    {
        description	= @"" ;
	startTime	= [[CPDate alloc] init] ;
	endTime		= [[CPDate alloc] init] ;
    }
    
    return self ;
}

- (CPString)dateRange
{
    return [self formatDateAndTime:startTime] + " to " + [self formatDateAndTime:endTime] ;
}

- (CPString)formatDateAndTime:(Date)aDate
{
    return aDate.formatDate("m/d/y H:i:s")
}

- (id)initFromJSONObject:(CPString)aJSONObject
{
    self = [self init] ;
    
    if (self)
    {

	startTime = [self railsToJSDate:aJSONObject.start_time];
	endTime = [self railsToJSDate:aJSONObject.end_time];
        description    	= aJSONObject.description ;
        startTime     	= [[CPDate alloc] initWithString:startTime] ;
        endTime		= [[CPDate alloc] initWithString:endTime] ;
    }

    
    return self ;
}

- (CPString)railsToJSDate:(CPString)aDate
{
    newDate = aDate.replace(/\-/g,"/");
    newDate = newDate.replace("T", " ");
    newDate = newDate.replace(/.{6}$/, "");
	
    return newDate
}

+ (CPArray)initFromJSONObjects:(CPString)someJSONObjects
{

    var projectSessions   = [[CPArray alloc] init] ;
    
    for (var i=0; i < someJSONObjects.length; i++) {

        //var projectSession = [[ProjectSession alloc] initFromJSONObject:someJSONObjects[i]] ;
        //[projectSessions addObject:projectSession] ;
	// hack to handle different JSON for projects vs project_sessions
	//var JSONObject = someJSONObjects[i];
	var JSONObject = someJSONObjects[i].project_session;
	if( !JSONObject ) { JSONObject = someJSONObjects[i]; }


        var projectSession = [[ProjectSession alloc] initFromJSONObject:JSONObject] ;

        [projectSessions addObject:projectSession] ;
    };
    
    return projectSessions ;
}

@end
