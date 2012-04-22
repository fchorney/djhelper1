//
//  SubViewController.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "SubViewController.h"
#import "Track.h"
#import "TrackViewController.h"
#import "TitleViewController.h"

@implementation SubViewController

@synthesize itemArray = _itemArray;
@synthesize barTitle = _barTitle;
@synthesize searchType = _searchType;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize data = _data;
@synthesize keys = _keys;

- (id) initWithContext:(NSManagedObjectContext *)__context
                 Array:(NSArray *)__array
                 title:(NSString *)__title
            searchType:(NSString *)__searchType {
    if ((self = [super initWithNibName:@"SubViewController" bundle:nil])) {
        self.managedObjectContext = __context;
        self.itemArray = __array;
        self.barTitle = __title;
        self.searchType = __searchType;
    }
    return self;
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_itemArray release];
    [_barTitle release];
    [_searchType release];
    [_data release];
    [_keys release];
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

    self.navigationItem.title = self.barTitle;
    
    useDictionary = YES;
    
    if ([self.itemArray count] < 30 || [self.searchType isEqualToString:@"Disc"] || [self.searchType isEqualToString:@"Key"] || [self.searchType isEqualToString:@"BPM"] || [self.searchType isEqualToString:@"Genre"])
        useDictionary = NO;
    
    if (useDictionary) {
        self.data = [[[NSMutableDictionary alloc] init] autorelease];
        self.keys = [[[NSMutableArray alloc] init] autorelease];
        
        for (NSString *item in self.itemArray) {
            NSString *firstLetter = [[item substringToIndex:1] uppercaseString];
           
            if (![[firstLetter stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"]] isEqualToString:@""])
                firstLetter = @"Other";
            
            if(![self.data objectForKey:firstLetter]) {
                [self.data setObject:[[[NSMutableArray alloc] init] autorelease] forKey:firstLetter];
                
                [self.keys addObject:firstLetter];
            }
            [[self.data objectForKey:firstLetter] addObject:item];
        }
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
    if (useDictionary)
        return self.keys;
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (useDictionary)
        return index;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (useDictionary)
        return [self.keys count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (useDictionary)
        return [[self.data objectForKey:[self.keys objectAtIndex:section]] count];
    return [self.itemArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (useDictionary)
        return [self.keys objectAtIndex:section];
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    }
    NSString *value = nil;
    id item = nil;
    if (useDictionary)
        item = [[self.data objectForKey:[self.keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    else
        item = [self.itemArray objectAtIndex:indexPath.row];
    
    if ([item respondsToSelector:@selector(stringValue)])
        value = [item stringValue];
    else
        value = item;

    cell.textLabel.text = value;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:self.managedObjectContext];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    NSString *predicateStr = [NSString stringWithFormat:@"(%@ == \"%@\")",self.searchType,selectedItem];
    [request setPredicate:[NSPredicate predicateWithFormat:predicateStr]];
    
    [request setResultType:NSManagedObjectResultType];
    
    NSError *error = nil;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    TitleViewController *tvc = [[[TitleViewController alloc] initWithTracks:fetchResults context:self.managedObjectContext] autorelease];
    [self.navigationController pushViewController:tvc animated:YES];
    

    [request release];
}

@end
