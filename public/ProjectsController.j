@import <Foundation/CPObject.j>

@implementation ProjectsController : CPObject
{
    CPString                baseURL;
    CPCollectionViewItem    currentObject;
    ProjectListView         projectListView @accessors;
    CPTextField		    projectStatusField @accessors;
    CPTextField		    projectStartDateField @accessors;
    CPIndexSet		    currentSelections;
    CPURLConnection         listConnection;
    CPURLConnection         addConnection;
    CPURLConnection         updateConnection;
    CPURLConnection         deleteConnection;
}

- (id)init
{
    self = [super init] ;
    
    if (self)
    {
        baseURL = "http://localhost:4567" ;
    }
    
    return self ;
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)collectionView
{
    var currentObject = [collectionView getCurrentObject] ;
}
- (void)loadExampleProjects
{
    var projects = [Project getExampleProjects] ;
    [projectListView setContent:projects] ;
}

- (void)addItem:(id)sender
{
    var name = prompt("Enter the project name") ;
    
    if (name!=="")
    {
        var JSONString = '{"project":{"name":"'+name+'"}}'

        var request     = [CPURLRequest requestWithURL:baseURL + "/projects.json"];
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

- (void)updateSelectedItem
{
    var projectStatus = [projectStatusField stringValue];
    var projectStartDate = [projectStartDateField stringValue];

    var JSONString = '{"project":{"project_status":"'+projectStatus+'","start_date":"'+projectStartDate+'"}}'
    var request     = [CPURLRequest requestWithURL:baseURL + "/projects/" + [currentObject id] + ".json"];
    [request setHTTPMethod: "PUT"];
    [request setHTTPBody: JSONString];
    [request setValue:"application/json" forHTTPHeaderField:"Accept"] ;
    [request setValue:"application/json" forHTTPHeaderField:"Content-Type"] ;
    updateConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
}
 
- (void)removeSelectedItem:(id)sender
{
    if (confirm('Are you sure?'))
    {
        var request     = [CPURLRequest requestWithURL:baseURL + "/projects/" + currentObject.id + ".json"];
        [request setHTTPMethod: "DELETE"];
        [request setValue:"application/json" forHTTPHeaderField:"Accept"] ;
        [request setValue:"application/json" forHTTPHeaderField:"Content-Type"] ;
        deleteConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)loadProjects
{
    var request     = [CPURLRequest requestWithURL:baseURL + "/projects.json"];
    [request setHTTPMethod: "GET"];
    listConnection  = [CPURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    if (connection===listConnection)
    {
        var results = CPJSObjectCreateWithJSON(data);
        var projects = [Project initFromJSONObjects:results] ;
        
        [projectListView setContent:projects] ;
	if(currentSelections) {
            [projectListView setSelectionIndexes:currentSelections ] ;
	}
	else 
	{
            [projectListView setSelectionIndexes:[[CPIndexSet alloc] initWithIndex:0] ] ;
	}
    }
    else if (connection===addConnection)
    {
	currentSelections = [projectListView selectionIndexes] ;
        [self loadProjects] ;
    }
    else if (connection===updateConnection)
    {
	currentSelections = [projectListView selectionIndexes] ;
        [self loadProjects] ;
    }
    else if (connection===deleteConnection)
    {
	currentSelections = [projectListView selectionIndexes] ;
        [self loadProjects] ;
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
