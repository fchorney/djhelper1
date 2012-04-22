//
//  SubViewController.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SubViewController : UITableViewController {
    NSArray *_itemArray;
    NSString *_barTitle;
    NSString *_searchType;
    NSManagedObjectContext *_managedObjectContext;
    NSMutableDictionary *_data;
    NSMutableArray *_keys;
    BOOL useDictionary;
}

@property (nonatomic, retain) NSArray *itemArray;
@property (nonatomic, retain) NSString *barTitle;
@property (nonatomic, retain) NSString *searchType;
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id) initWithContext:(NSManagedObjectContext *)__context
                 Array:(NSArray *)__array
                 title:(NSString *)__title
            searchType:(NSString *)__searchType;

@end
