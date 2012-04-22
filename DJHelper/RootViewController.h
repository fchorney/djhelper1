//
//  RootViewController.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate> {
    UIView *_overlayView;
    UILabel *_statusLabel;
    UIProgressView *_progressBar;
    NSString *_XMLData;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UILabel *statusLabel;
@property (retain) UIProgressView *progressBar;
@property (nonatomic, retain) NSString *XMLData;

@end
