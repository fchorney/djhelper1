//
//  TrackViewController.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-13.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "TrackViewController.h"


@implementation TrackViewController
@synthesize txtTitle;
@synthesize txtArtist;
@synthesize txtAlbum;
@synthesize txtGenre;
@synthesize txtKey;
@synthesize txtDisc;
@synthesize txtTrack;
@synthesize txtBPM;
@synthesize plusSixValue;
@synthesize plusSixBPM;
@synthesize plusTenValue;
@synthesize plusTenBPM;
@synthesize btnEdit;
@synthesize segBPM;
@synthesize managedTrack = _managedTrack;
@synthesize scrollView;
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithTrack:(NSManagedObject *)__track context:(NSManagedObjectContext *)__context {
    if ((self = [super initWithNibName:@"TrackViewController" bundle:nil])) {
        self.managedTrack = __track;
        self.managedObjectContext = __context;
    }
    return self;
}

- (void)dealloc
{
    [txtTitle release];
    [txtArtist release];
    [txtAlbum release];
    [txtGenre release];
    [txtKey release];
    [txtDisc release];
    [txtTrack release];
    [txtBPM release];
    [plusSixValue release];
    [plusSixBPM release];
    [plusTenValue release];
    [plusTenBPM release];
    [segBPM release];
    [btnEdit release];
    [_managedTrack release];
    [scrollView release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (NSString *) findBPMPercentage:(NSNumber *)_bpm to:(double)target withIncrement:(double)incValue {
    double bpm = [_bpm doubleValue];  
    double closest = 0.00f;
    double result = (closest * bpm) + bpm;
    double distance = INT32_MAX;
    double percentage = 0.0f;
    
    while (distance > fabs(target - result)) {
        distance = fabs(target - result);
        percentage = closest;
        if (result < target)
            closest += incValue;
        else
            closest -= incValue;
        
        result = (closest * bpm) + bpm;
    }
    
    return [NSString stringWithFormat:@"%0.2f",percentage * 100];
}

- (void) setBPMData {
    Track *track = (Track *)self.managedTrack;
    //NSLog(@"Track Key: %@",track.Key);
    //NSLog(@"Key: %@",[[KeyMath sharedInstance] stringForKey:track.Key]);
    if ([self.segBPM selectedSegmentIndex] == 0) {
        self.plusSixValue.text = [self findBPMPercentage:track.BPM to:130.0 withIncrement:0.0002];
        self.plusSixBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusSixValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        self.plusTenValue.text = [self findBPMPercentage:track.BPM to:130.0 withIncrement:0.0005];
        self.plusTenBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusTenValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        
        double new = [self.plusSixBPM.text doubleValue];
        double old = [track.BPM doubleValue];
        double cents = (((new / old) - 1) * 1200);
        
        //NSLog(@"New: %f, Old: %f, Centsd: %f",new,old,cents);
        
        NSString *newKey = [[KeyMath sharedInstance]keyForKey:track.Key withCents:[NSNumber numberWithDouble:cents]];
        self.txtKey.text = [NSString stringWithFormat:@"%@ (%@)",track.Key,newKey];
        
    }
    else if ([self.segBPM selectedSegmentIndex] == 1) {
        self.plusSixValue.text = [self findBPMPercentage:track.BPM to:135.0 withIncrement:0.0002];
        self.plusSixBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusSixValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        self.plusTenValue.text = [self findBPMPercentage:track.BPM to:135.0 withIncrement:0.0005];
        self.plusTenBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusTenValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        
        double new = [self.plusSixBPM.text doubleValue];
        double old = [track.BPM doubleValue];
        double cents = (((new / old) - 1) * 1200);
        
        //NSLog(@"New: %f, Old: %f, Centsd: %f",new,old,cents);
        
        NSString *newKey = [[KeyMath sharedInstance]keyForKey:track.Key withCents:[NSNumber numberWithDouble:cents]];
        self.txtKey.text = [NSString stringWithFormat:@"%@ (%@)",track.Key,newKey];
    }
    else if ([self.segBPM selectedSegmentIndex] == 2) {
        self.plusSixValue.text = [self findBPMPercentage:track.BPM to:175.0 withIncrement:0.0002];
        self.plusSixBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusSixValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        self.plusTenValue.text = [self findBPMPercentage:track.BPM to:175.0 withIncrement:0.0005];
        self.plusTenBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusTenValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        
        double new = [self.plusSixBPM.text doubleValue];
        double old = [track.BPM doubleValue];
        double cents = (((new / old) - 1) * 1200);
        
        //NSLog(@"New: %f, Old: %f, Centsd: %f",new,old,cents);
        
        NSString *newKey = [[KeyMath sharedInstance]keyForKey:track.Key withCents:[NSNumber numberWithDouble:cents]];
        self.txtKey.text = [NSString stringWithFormat:@"%@ (%@)",track.Key,newKey];
        
    }
    else if ([self.segBPM selectedSegmentIndex] == 3) {
        self.plusSixValue.text = [self findBPMPercentage:track.BPM to:180.0 withIncrement:0.0002];
        self.plusSixBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusSixValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        self.plusTenValue.text = [self findBPMPercentage:track.BPM to:180.0 withIncrement:0.0005];
        self.plusTenBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusTenValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        
        double new = [self.plusSixBPM.text doubleValue];
        double old = [track.BPM doubleValue];
        double cents = (((new / old) - 1) * 1200);
        
        //NSLog(@"New: %f, Old: %f, Centsd: %f",new,old,cents);
        
        NSString *newKey = [[KeyMath sharedInstance]keyForKey:track.Key withCents:[NSNumber numberWithDouble:cents]];
        self.txtKey.text = [NSString stringWithFormat:@"%@ (%@)",track.Key,newKey];
    }
    else if ([self.segBPM selectedSegmentIndex] == 4) {
        self.plusSixValue.text = [self findBPMPercentage:track.BPM to:185.0 withIncrement:0.0002];
        self.plusSixBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusSixValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        self.plusTenValue.text = [self findBPMPercentage:track.BPM to:185.0 withIncrement:0.0005];
        self.plusTenBPM.text = [NSString stringWithFormat:@"%.03f",(1.0 + ([self.plusTenValue.text doubleValue] / 100)) * [track.BPM doubleValue]];
        
        double new = [self.plusSixBPM.text doubleValue];
        double old = [track.BPM doubleValue];
        double cents = (((new / old) - 1) * 1200);
        
        //NSLog(@"New: %f, Old: %f, Centsd: %f",new,old,cents);
        
        NSString *newKey = [[KeyMath sharedInstance]keyForKey:track.Key withCents:[NSNumber numberWithDouble:cents]];
        self.txtKey.text = [NSString stringWithFormat:@"%@ (%@)",track.Key,newKey];
    }
}

- (void) enableAll {
    self.txtTitle.enabled = YES;
    self.txtAlbum.enabled = YES;
    self.txtArtist.enabled = YES;
    self.txtGenre.enabled = YES;
    self.txtKey.enabled = YES;
    self.txtDisc.enabled = YES;
    self.txtTrack.enabled = YES;
    self.txtBPM.enabled = YES;
}

- (void) disableAll {
    self.txtTitle.enabled = NO;
    self.txtAlbum.enabled = NO;
    self.txtArtist.enabled = NO;
    self.txtGenre.enabled = NO;
    self.txtKey.enabled = NO;
    self.txtDisc.enabled = NO;
    self.txtTrack.enabled = NO;
    self.txtBPM.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Track *track = (Track *)self.managedTrack;
    self.txtTitle.text = track.Title;
    self.txtArtist.text = track.Artist;
    self.txtAlbum.text = track.Album;
    self.txtGenre.text = track.Genre;
    self.txtKey.text = track.Key;
    self.txtDisc.text = [track.Disc stringValue];
    self.txtTrack.text = [track.Track stringValue];
    self.txtBPM.text = [track.BPM stringValue];
    
    txtTitle.delegate = self;
    txtArtist.delegate = self;
    txtAlbum.delegate = self;
    txtGenre.delegate = self;
    txtKey.delegate = self;
    txtDisc.delegate = self;
    txtTrack.delegate = self;
    txtBPM.delegate = self;
    
    svos = self.scrollView.contentOffset;
    
    
    /**************** BPM TAP ALGO ******************/
    /* Approx BPM = (1 / Time Between 2 beats) * 60 */
    /**************** BPM TAP ALGO ******************/
    
    [self enableAll];
    [self setBPMData];
}

- (void)viewDidUnload
{
    [self setTxtTitle:nil];
    [self setTxtArtist:nil];
    [self setTxtAlbum:nil];
    [self setTxtGenre:nil];
    [self setTxtKey:nil];
    [self setTxtDisc:nil];
    [self setTxtTrack:nil];
    [self setTxtBPM:nil];
    [self setPlusSixValue:nil];
    [self setPlusSixBPM:nil];
    [self setPlusTenValue:nil];
    [self setPlusTenBPM:nil];
    [self setSegBPM:nil];
    [self setBtnEdit:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)updateTrackData {
    [self.managedTrack setValue:self.txtTitle.text forKey:@"Title"];
    [self.managedTrack setValue:self.txtArtist.text forKey:@"Artist"];
    [self.managedTrack setValue:self.txtAlbum.text forKey:@"Album"];
    [self.managedTrack setValue:self.txtGenre.text forKey:@"Genre"];
    [self.managedTrack setValue:self.txtKey.text forKey:@"Key"];
    [self.managedTrack setValue:[NSNumber numberWithInt:[self.txtDisc.text intValue]] forKey:@"Disc"];
    [self.managedTrack setValue:[NSNumber numberWithInt:[self.txtTrack.text intValue]] forKey:@"Track"];
    [self.managedTrack setValue:[NSNumber numberWithDouble:[self.txtBPM.text doubleValue]] forKey:@"BPM"];
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"HOLY FUCK ERROR TOWN BABY!");
    }
    
    [self setBPMData];
}

- (IBAction) editPressed:(id)sender {
    if ([btnEdit style] == UIBarButtonItemStyleBordered) {
        [btnEdit setStyle:UIBarButtonItemStyleDone];
        [btnEdit setTitle:@"Update"];
        [self enableAll];
    }
    else {
        [btnEdit setStyle:UIBarButtonItemStyleBordered];
        [btnEdit setTitle:@"Edit"];
        [self disableAll];
        [self updateTrackData];
    }
}

- (IBAction) BPMChanged:(id)sender {
    [self setBPMData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pt;
    CGRect rc = [textField bounds];
    
    rc = [textField convertRect:rc toView:self.scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 165;
    
    [self.scrollView setContentOffset:pt animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:svos animated:YES];
    
    [self updateTrackData];
    
    if (textField == self.txtBPM) 
        [self setBPMData];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
