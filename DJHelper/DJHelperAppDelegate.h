//
//  DJHelperAppDelegate.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJHelperAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
