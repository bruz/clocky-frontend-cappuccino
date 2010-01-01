@import <Foundation/CPObject.j>

@implementation SessionsController : CPObject
{
    CPString                baseURL;
    SessionListView         sessionListView @accessors;
    Project		    currentProject;
    CPURLConnection         listConnection;
    CPURLConnection         addConnection;
    CPURLConnection         deleteConnection;
}

- (id)init
{
    self = [super init] ;
    
    if (self)
    {
        baseURL = "http://localhost:4567" ;
	[[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didSelectProject:)
            name:@"didSelectProject"
            object:nil]; 
	
    }
    
    return self ;
}

- (void)didSelectProject:(CPNotification)aNotification
{
    currentProject = [[aNotification object] valueForKey:@"_currentProject"];
} 

- (void)addItem:(CPDate)startTime endTime:(CPDate)endTime
{
    
    if (startTime!=="" && endTime!=="")
    {
        var JSONString = '{"project_session":{"start_time":"'+startTime+'","end_time":"'+endTime+
			 '","project_id":"'+[currentProject id]+'"}}'

        var request     = [CPURLRequest requestWithURL:baseURL + "/project_sessions.json"];
        [request setHTTPMethod: "POST"];
        [request setHTTPBody: JSONString];
        [request setValue:"application/json" forHTTPHeaderField:"Accept"] ;
        [request setValue:"application/json" forHTTPHeaderField:"Content-Type"] ;
        addConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
    }
    else
    {
        alert("Please provide a value for the name");
    }
}

- (void)removeSelectedItem:(id)sender
{
    if (confirm('Are you sure?'))
    {
        var request     = [CPURLRequest requestWithURL:baseURL + "/project_sessions/" + currentObject.id + ".json"];
        [request setHTTPMethod: "DELETE"];
        [request setValue:"application/json" forHTTPHeaderField:"Accept"] ;
        [request setValue:"application/json" forHTTPHeaderField:"Content-Type"] ;
        deleteConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)loadProjectSessions
{
    var request     = [CPURLRequest requestWithURL:baseURL + "/projects/" + [currentProject id] +
		      "/project_sessions.json"];
    [request setHTTPMethod: "GET"];
    listConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{

    if (connection===listConnection)
    {

        var results = CPJSObjectCreateWithJSON(data);

        var sessions = [ProjectSession initFromJSONObjects:results] ;

        
        [sessionListView setContent:sessions] ;

	[currentProject setProjectSessions:sessions];

	//if(currentSelections) {
        //    [sessionListView setSelectionIndexes:currentSelections ] ;
	//}
	//else 
	//{
        //    [sessionListView setSelectionIndexes:[[CPIndexSet alloc] initWithIndex:0] ] ;
	//}
    }
    else if (connection===addConnection)
    {
	currentSelections = [sessionListView selectionIndexes] ;
        [self loadProjectSessions] ;
    }
    else if (connection===updateConnection)
    {
	currentSelections = [sessionListView selectionIndexes] ;
        [self loadProjectSessions] ;
    }
    else if (connection===deleteConnection)
    {
	currentSelections = [sessionListView selectionIndexes] ;
        [self loadProjectSessions] ;
    }
}

- (void)connection:(CPURLConnection)connection didFailWithError:(CPString)error
{
    alert("Connection did fail with error : " + error) ;
}

- (void)connectionDidFinishLoading:(CPURLConnection)aConnection
{
    
}
@end
