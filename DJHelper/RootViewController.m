//
//  RootViewController.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "RootViewController.h"
#import "SubViewController.h"
#import "Track.h"
#import "DJHelperAppDelegate.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "TitleViewController.h"
#import "ASIHTTPRequest.h"

@implementation RootViewController

@synthesize managedObjectContext=__managedObjectContext;
@synthesize overlayView = _overlayView;
@synthesize statusLabel = _statusLabel;
@synthesize progressBar = _progressBar;
@synthesize XMLData = _XMLData;

- (void)updateProgressBar:(NSNumber *)progress {
    [self.progressBar setProgress:[progress floatValue]];
}

- (void)removeOverlayView {
    [self.overlayView removeFromSuperview];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    for(id item in self.toolbarItems) {
        [item setEnabled:YES];
    }
}

- (void)showOverlayView {
    [self.view addSubview:self.overlayView];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    for(id item in self.toolbarItems) {
        [item setEnabled:NO];
    }
}

- (void)deleteAllTracks {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Delete all Track objects first ***Should be done after successfully getting all the new data from the server***
    NSFetchRequest *allTracks = [[NSFetchRequest alloc] init];
    [allTracks setEntity:[NSEntityDescription entityForName:@"Track" inManagedObjectContext:self.managedObjectContext]];
    [allTracks setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *tracks = [self.managedObjectContext executeFetchRequest:allTracks error:&error];
    [allTracks release];
    
    if (error) {
        NSLog(@"ERROR ERROR GETTING ALL TRACKS FAILED FOR SOME REASON");
    }
    
    int count = [tracks count];
    NSError *error2 = nil;
  
    // Delete Objects
    for (NSManagedObject *track in tracks) {
        [self.managedObjectContext deleteObject:track];
        [self.managedObjectContext save:&error2];
        [self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:[NSNumber numberWithFloat:((float)count-- / (float)[tracks count])]waitUntilDone:NO];
        if (error) {
            NSLog(@"ERROR BOSHANDER");
        }
        error2 = nil;
    } 
    
    //[self performSelectorOnMainThread:@selector(removeOverlayView) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:[NSNumber numberWithFloat:0] waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(callPopulateDatabase) withObject:nil waitUntilDone:NO];
    
    [pool release];
}

- (void)insertNewObject:(DDXMLElement *)element {
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:self.managedObjectContext];
    
    // Get objects from element data
    NSString *title = [[element elementForName:@"Title"] stringValue];
    NSString *artist = [[element elementForName:@"Artist"] stringValue];
    NSString *album = [[element elementForName:@"Album"] stringValue];
    double BPM = [[[element elementForName:@"BPM"] stringValue] doubleValue];
      
    if ([element elementForName:@"Genre"] != NULL) {
        NSString *genre = [[element elementForName:@"Genre"] stringValue];
       [newManagedObject setValue:genre forKey:@"Genre"];
    }

    if ([element elementForName:@"Key"] != NULL) {
        NSString *key = [[element elementForName:@"Key"] stringValue];
        [newManagedObject setValue:key forKey:@"Key"];
    }

    if ([element elementForName:@"Disc"] != NULL) {
        int disc = [[[element elementForName:@"Disc"] stringValue] intValue];
        [newManagedObject setValue:[NSNumber numberWithInt:disc] forKey:@"Disc"];
    }
    
    if ([element elementForName:@"Track"] != NULL) {
        int track = [[[element elementForName:@"Track"] stringValue] intValue];
        [newManagedObject setValue:[NSNumber numberWithInt:track] forKey:@"Track"];
    }
    
    // Insert data into entity
    [newManagedObject setValue:title forKey:@"Title"];
    [newManagedObject setValue:artist forKey:@"Artist"];
    [newManagedObject setValue:album forKey:@"Album"];
    [newManagedObject setValue:[NSNumber numberWithDouble:BPM] forKey:@"BPM"];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
//    NSLog(@"ID: %@,Title: %@",[newManagedObject objectID],[newManagedObject valueForKey:@"Title"]);
}

- (void)populateDatabase {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    DDXMLDocument *XMLDoc = [[[DDXMLDocument alloc] initWithXMLString:self.XMLData options:0 error:&error] autorelease];
    DDXMLElement *root = [XMLDoc rootElement];
    
    int count = 0;
    if (error) {
        NSLog(@"XML ERROR: %@",error);
    }
    else {
        for (DDXMLElement *element in [root children]) {
            if ([element childCount] > 1) {
                [self insertNewObject:element];
            }
            [self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:[NSNumber numberWithFloat:((float)count++ / (float)[[root children] count])] waitUntilDone:YES];
        }            
    }   
    
    [self performSelectorOnMainThread:@selector(removeOverlayView) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:[NSNumber numberWithFloat:0] waitUntilDone:NO];
    
    [pool release];
}

- (void)callDeleteAll {
    [self.statusLabel setText:@"Deleting All Tracks From Database"];
    [self performSelectorInBackground:@selector(deleteAllTracks) withObject:nil];
}

- (void)callPopulateDatabase {
    [self.statusLabel setText:@"Inserting Tracks from XML"];
    [self performSelectorInBackground:@selector(populateDatabase) withObject:nil];
}

- (void)getXMLFromWeb {
    __block ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:/*@"http://downloads.djsbx.com/XML/Song-Collection.xml"*/@"http://www.djsbx.com/xml/Song-Collection.xml"]] autorelease];
    
    [request setNumberOfTimesToRetryOnTimeout:6];
    [request setRequestMethod:@"GET"];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:10];
    [request setShowAccurateProgress:YES];
    [request setDownloadProgressDelegate:self.progressBar];
    
    [self.statusLabel setText:@"Downloading XML From Server"];
    [self showOverlayView];

    [request setFailedBlock:^{
        [[[[UIAlertView alloc] initWithTitle:@"ASIHTTPRequest Error" 
                                     message:[NSString stringWithFormat:@"%@",[request error]]
                                    delegate:nil 
                           cancelButtonTitle:nil 
                           otherButtonTitles:@"OK", nil] autorelease] show];
        [self removeOverlayView];
    }];
    
    [request setCompletionBlock:^{
        //NSLog(@"Response:\n%@",[request responseString]);
        self.XMLData = [request responseString];
        [self callDeleteAll];
    }];
    
    [request startAsynchronous];
}

- (void)convertToXML {    
    NSFetchRequest *allTracks = [[NSFetchRequest alloc] init];
    [allTracks setEntity:[NSEntityDescription entityForName:@"Track" inManagedObjectContext:self.managedObjectContext]];
    [allTracks setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *tracks = [self.managedObjectContext executeFetchRequest:allTracks error:&error];
    [allTracks release];
    
    if (error) {
        NSLog(@"ERROR ERROR GETTING ALL TRACKS FAILED FOR SOME REASON");
    }
     
    DDXMLDocument *xmlDoc = [[[DDXMLDocument alloc] initWithXMLString:@"<Songs/>" options:0 error:nil] autorelease];
    DDXMLElement *root = [xmlDoc rootElement];

    for (Track *track in tracks) {
        DDXMLElement *song = [DDXMLElement elementWithName:@"Song"];
        [song insertChild:[DDXMLNode elementWithName:@"Title" stringValue:track.Title] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Artist" stringValue:track.Artist] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Album" stringValue:track.Album] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Key" stringValue:track.Key] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Genre" stringValue:track.Genre] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Disc" stringValue:[track.Disc stringValue]] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"Track" stringValue:[track.Track stringValue]] atIndex:0];
        [song insertChild:[DDXMLNode elementWithName:@"BPM" stringValue:[track.BPM stringValue]] atIndex:0];
        [root insertChild:song atIndex:0];
    }
    
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>%@",[root XMLString]];
    
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:@"DJHelper XML Song Collection"];
    
    // Fill out the email body text
    NSString *emailBody = @"Here is your entire DJHelper Song Collection in XML Format.";
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];

    // Attach XML File
    [picker addAttachmentData:data mimeType:@"text/xml" fileName:@"DJHelper-Song-Collection.xml"];
    
    // Show email view	
    [self presentModalViewController:picker animated:YES];
    
    // Release picker
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    // Called once the email is sent
    // Remove the email view controller	
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addNewTrack {
    NSLog(@"Add New Track");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Plus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(getXMLFromWeb)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
//    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Minus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(callDeleteAll)];
//    self.navigationItem.leftBarButtonItem = removeButton;
//    [removeButton release];
    
    UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *toXML = [[[UIBarButtonItem alloc] initWithTitle:@"To XML" style:UIBarButtonItemStyleBordered target:self action:@selector(convertToXML)] autorelease];
    
//    UIBarButtonItem *addNew = [[[UIBarButtonItem alloc] initWithTitle:@"New Track" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewTrack)] autorelease];
    
    [self setToolbarItems:[NSArray arrayWithObjects:toXML,flexSpace,nil]];
    
    self.navigationItem.title = @"DJ Helper";
    
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.8f;
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 182, 280, 21)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment = UITextAlignmentCenter;
    self.statusLabel.textColor = [UIColor whiteColor];
    
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.progressBar setFrame:CGRectMake(20, 256, 280, 11)];
    self.progressBar.progress = 0.0f;
    
    [self.overlayView addSubview:self.statusLabel];
    [self.overlayView addSubview:self.progressBar];
    UIActivityIndicatorView *iv = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [iv setFrame:CGRectMake(142, 211, 37,37)];
    [iv setAlpha:1.0f];
    [iv startAnimating];
    [self.overlayView addSubview:iv];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSString *title = nil;
    switch (indexPath.row) {
        case 0:
            title = @"Title";
            break;
        case 1:
            title = @"Artist";
            break;
        case 2:
            title = @"Album";
            break;
        case 3:
            title = @"Key";
            break;
        case 4:
            title = @"BPM";
            break;
        case 5:
            title = @"Genre";
            break;
        case 6:
            title = @"Disc";
            break;
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;

    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:self.managedObjectContext];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:selectedItem ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    if ([selectedItem isEqualToString:@"Title"]) {
        [request setResultType:NSManagedObjectResultType];
        
        NSError *error = nil;
        NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (error) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        TitleViewController *tvc = [[[TitleViewController alloc] initWithTracks:fetchResults context:self.managedObjectContext] autorelease];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    else {
        
        [request setReturnsDistinctResults:YES];
        
        [request setPropertiesToFetch:[NSArray arrayWithObject:selectedItem]];

        //[request setResultType:NSDictionaryResultType];
        [request setResultType:NSDictionaryResultType];
        
         NSString *predicateStr = [NSString stringWithFormat:@"(%@ != NULL)",selectedItem];
        [request setPredicate:[NSPredicate predicateWithFormat:predicateStr]];
        
        // Fetch the records as handle an error
        NSError *error = nil;
        NSMutableArray *fetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        if (error) {
            NSLog(@"ERROR ERROR WILL ROBINSON: %@",[error localizedDescription]);
        }
        
        NSMutableArray *items = [NSMutableArray arrayWithArray:[fetchResults valueForKey:selectedItem]];

        
        SubViewController *svc = [[[SubViewController alloc] initWithContext:self.managedObjectContext Array:items title:selectedItem searchType:selectedItem] autorelease];
        [self.navigationController pushViewController:svc animated:YES];
        
        [fetchResults release];
    }
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setOverlayView:nil];
    [self setStatusLabel:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [__managedObjectContext release];
    [_overlayView release];
    [_statusLabel release];
    [_progressBar release];
    [super dealloc];
}

@end
