//
//  TrackViewController.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-13.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import <CoreData/CoreData.h>
#import "KeyMath.h"

@interface TrackViewController : UIViewController <UITextFieldDelegate>{
    
    UITextField *txtTitle;
    UITextField *txtArtist;
    UITextField *txtAlbum;
    UITextField *txtGenre;
    UITextField *txtKey;
    UITextField *txtDisc;
    UITextField *txtTrack;
    UITextField *txtBPM;
    UILabel *plusSixValue;
    UILabel *plusSixBPM;
    UILabel *plusTenValue;
    UILabel *plusTenBPM;
    UIBarButtonItem *btnEdit;
    UISegmentedControl *segBPM;
    NSManagedObject *_managedTrack;
    UIScrollView *scrollView;
    NSManagedObjectContext *_managedObjectContext;
    CGPoint svos;
}
@property (nonatomic, retain) IBOutlet UITextField *txtTitle;
@property (nonatomic, retain) IBOutlet UITextField *txtArtist;
@property (nonatomic, retain) IBOutlet UITextField *txtAlbum;
@property (nonatomic, retain) IBOutlet UITextField *txtGenre;
@property (nonatomic, retain) IBOutlet UITextField *txtKey;
@property (nonatomic, retain) IBOutlet UITextField *txtDisc;
@property (nonatomic, retain) IBOutlet UITextField *txtTrack;
@property (nonatomic, retain) IBOutlet UITextField *txtBPM;
@property (nonatomic, retain) IBOutlet UILabel *plusSixValue;
@property (nonatomic, retain) IBOutlet UILabel *plusSixBPM;
@property (nonatomic, retain) IBOutlet UILabel *plusTenValue;
@property (nonatomic, retain) IBOutlet UILabel *plusTenBPM;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnEdit;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segBPM;
@property (nonatomic, retain) NSManagedObject *managedTrack;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction) editPressed:(id)sender;
- (IBAction) BPMChanged:(id)sender;

- (id)initWithTrack:(NSManagedObject *)__track context:(NSManagedObjectContext *)__context;

@end
