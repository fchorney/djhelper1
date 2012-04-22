//
//  TitleViewController.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-16.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "TitleViewController.h"
#import "Track.h"
#import "TrackViewController.h"


@implementation TitleViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tracks = _tracks;
@synthesize data = _data;
@synthesize keys = _keys;

- (id)initWithTracks:(NSArray *)__tracks context:(NSManagedObjectContext *)__context {
    if ((self = [super initWithNibName:@"TitleViewController" bundle:nil])) {
        self.tracks = __tracks;
        self.managedObjectContext = __context;
    }
    return self;
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_tracks release];
    [_keys release];
    [_data release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Title";
    
    self.data = [[[NSMutableDictionary alloc] init] autorelease];
    self.keys = [[[NSMutableArray alloc] init] autorelease];
    
    for (Track *track in self.tracks) {
        NSString *firstLetter = [[[track Title] substringToIndex:1] uppercaseString];            
        if (![[firstLetter stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"]] isEqualToString:@""])
            firstLetter = @"Other";
        
        if (![self.data objectForKey:firstLetter]) {
            [self.data setObject:[[[NSMutableArray alloc] init] autorelease] forKey:firstLetter];
            [self.keys addObject:firstLetter];
        }
        [[self.data objectForKey:firstLetter] addObject:track];
    }
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setKeys:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data objectForKey:[self.keys objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.keys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
        [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    }
    
    Track *track = [[self.data objectForKey:[self.keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = track.Title;
    cell.detailTextLabel.text = track.Album;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackViewController *tvc = [[[TrackViewController alloc] initWithTrack:[[self.data objectForKey:[self.keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] context:self.managedObjectContext] autorelease];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
