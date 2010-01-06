/*
 * AppController.j
 *
 * Created by __Me__ on __Date__.
 * Copyright 2008 __MyCompanyName__. All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "ToolbarDelegate.j"
@import "ProjectListView.j"
@import "ProjectItemView.j"
@import "Project.j"
@import "ProjectSession.j"
@import "ProjectsController.j"
@import "SessionListView.j"
@import "SessionItemView.j"
@import "FormatDate.js"
@import "ProjectTextField.j"
@import "SessionsController.j"
@import "TimerClock.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    // -- the projects controller
    var projectsController  = [[ProjectsController alloc] init] ;

    // --- the toolbar
    var toolbar = [[CPToolbar alloc] initWithIdentifier:"Projects"] ;
    var toolbarDelegate = [[ToolbarDelegate alloc] init] ;
    [toolbarDelegate setProjectsController:projectsController] ;
    [toolbar setDelegate:toolbarDelegate] ;
    [toolbar setVisible:YES] ;
    [theWindow setToolbar:toolbar] ;

    // -- the split view
    var splitView = [[CPSplitView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([contentView bounds]), CGRectGetHeight([contentView bounds]))];
    [splitView setDelegate:self];
    [splitView setVertical:YES] ;
    [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ]; 
    [contentView addSubview:splitView] ;

    // --- the projects scroll view
    var projectListScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200, CGRectGetHeight([splitView bounds]))] ;
    [projectListScrollView setHasHorizontalScroller:NO] ;
    [projectListScrollView setAutohidesScrollers:YES] ;

    // --- the project details view
    var projectDetailsView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([splitView bounds])-200, CGRectGetHeight([splitView bounds]))]; //,
    [projectDetailsView setBackgroundColor:[CPColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1.0]];

    [splitView addSubview:projectListScrollView] ;
    [splitView addSubview:projectDetailsView] ;

    // --- the projects collection view
    var projectListView = [[ProjectListView alloc] initWithFrame:[splitView bounds]] ;
    [projectListView setDelegate:projectsController] ;
    [projectsController setProjectListView:projectListView] ;
    [projectsController loadProjects] ;
    [projectListScrollView setDocumentView:projectListView] ;

    // --- the project details label
    projectDetailsLabel = [[CPTextField alloc] initWithFrame:CGRectMake(20, 20, 200, 28.0)] ;
    [projectDetailsLabel setPlaceholderString:@"Project Details"];
    [projectDetailsLabel setFont:[CPFont systemFontOfSize:20.0]];
    [projectDetailsLabel setTextColor:[CPColor blackColor]];
    [projectDetailsView addSubview:projectDetailsLabel];

    // --- the project status label
    projectStatusLabel = [[CPTextField alloc] initWithFrame:CGRectMake(20, 56, 110, 30)] ;
    [projectStatusLabel setPlaceholderString:@"Status"];
    [projectStatusLabel setFont:[CPFont systemFontOfSize:14.0]];
    [projectStatusLabel setTextColor:[CPColor blackColor]];
    [projectStatusLabel setAlignment:CPRightTextAlignment];
    [projectDetailsView addSubview:projectStatusLabel];
    
    // --- the project status field
    projectStatusField = [[ProjectTextField alloc] initWithFrame:CGRectMake(135, 50, 150, 30) name:@"projectStatus"] ;
    [projectStatusField setEditable:YES];
    [projectStatusField setBezeled:YES];
    [projectStatusField setBezelStyle:CPTextFieldSquareBezel];
    [projectStatusField setPlaceholderString:@""];
    [projectStatusField setFont:[CPFont systemFontOfSize:14.0]];
    [projectStatusField setTextColor:[CPColor blackColor]];
    [projectDetailsView addSubview:projectStatusField];
    [projectsController setProjectStatusField:projectStatusField] ;
    [projectStatusField setProjectsController:projectsController] ;

    // --- the project start date label
    projectStartDateLabel = [[CPTextField alloc] initWithFrame:CGRectMake(20, 94, 110, 30)] ;
    [projectStartDateLabel setPlaceholderString:@"Start Date"];
    [projectStartDateLabel setFont:[CPFont systemFontOfSize:14.0]];
    [projectStartDateLabel setTextColor:[CPColor blackColor]];
    [projectStartDateLabel setAlignment:CPRightTextAlignment];
    [projectDetailsView addSubview:projectStartDateLabel];
    
    // --- the project start date field
    projectStartDateField = [[ProjectTextField alloc] initWithFrame:CGRectMake(135, 88, 150, 30) name:@"startDate"] ;
    [projectStartDateField setEditable:YES];
    [projectStartDateField setBezeled:YES];
    [projectStartDateField setBezelStyle:CPTextFieldSquareBezel];
    [projectStartDateField setPlaceholderString:@""];
    [projectStartDateField setFont:[CPFont systemFontOfSize:14.0]];
    [projectStartDateField setTextColor:[CPColor blackColor]];
    [projectDetailsView addSubview:projectStartDateField];
    [projectsController setProjectStartDateField:projectStartDateField] ;
    [projectStartDateField setProjectsController:projectsController] ;

    // --- the project save button
    var projectSaveButton = [[CPButton alloc] initWithFrame:CGRectMake(160, 128, 120, 24)] ;
    [projectSaveButton setTitle:@"Save Project"] ;
    [projectSaveButton setTarget:projectsController];
    [projectSaveButton setAction:@selector(updateSelectedItem)];
    [projectDetailsView addSubview:projectSaveButton] ;

    // --- the project sessions label
    projectSessionsLabel = [[CPTextField alloc] initWithFrame:CGRectMake(20, 160, 200, 28.0)] ;
    [projectSessionsLabel setPlaceholderString:@"Project Sessions"];
    [projectSessionsLabel setFont:[CPFont systemFontOfSize:20.0]];
    [projectSessionsLabel setTextColor:[CPColor blackColor]];
    [projectDetailsView addSubview:projectSessionsLabel];

    // --- the sessions scroll view
    var sessionListScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(20, 190, CGRectGetWidth([projectDetailsView bounds]) - 40, CGRectGetHeight([projectDetailsView bounds]) - 210)] ;
    [sessionListScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [sessionListScrollView setHasHorizontalScroller:NO] ;
    [sessionListScrollView setAutohidesScrollers:YES] ;
    [sessionListScrollView setBackgroundColor:[CPColor whiteColor]];
    [projectDetailsView addSubview:sessionListScrollView] ;

    // --- the sessions collection view
    var sessionListView = [[SessionListView alloc] initWithFrame:[sessionListScrollView bounds]] ;
    [sessionListScrollView setDocumentView:sessionListView] ;

    // --- the timer clock
    timerClock = [[TimerClock alloc] initWithFrame:CGRectMake(450, 69, 150, 30) sessionListView:sessionListView] ;
    [timerClock setPlaceholderString:@"00:00:00"];
    [timerClock setFont:[CPFont systemFontOfSize:14.0]];
    [timerClock setTextColor:[CPColor blackColor]];
    [projectDetailsView addSubview:timerClock];
    
    // --- the timer button
    var timerButton = [[CPButton alloc] initWithFrame:CGRectMake(320, 65, 120, 24)] ;
    [timerButton setTitle:@"Start Timer"] ;
    [timerButton setTarget:timerClock];
    [timerButton setAction:@selector(toggleTimer)] ;
    [timerClock setTimerButton:timerButton] ;
    [projectDetailsView addSubview:timerButton] ;

    [theWindow orderFront:self];
}

@end
