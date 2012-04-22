//
//  TitleViewController.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-16.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TitleViewController : UITableViewController {
    NSManagedObjectContext *_managedObjectContext;
    NSArray *_tracks;
    NSMutableDictionary *_data;
    NSMutableArray *_keys;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *tracks;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSMutableArray *keys;

- (id)initWithTracks:(NSArray *)__tracks context:(NSManagedObjectContext *)__context;

@end
