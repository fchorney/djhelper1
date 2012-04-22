//
//  Track.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright (c) 2011 Rollout Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Track : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * Artist;
@property (nonatomic, retain) NSString * Album;
@property (nonatomic, retain) NSString * Key;
@property (nonatomic, retain) NSString * Genre;
@property (nonatomic, retain) NSNumber * BPM;
@property (nonatomic, retain) NSNumber * Disc;
@property (nonatomic, retain) NSNumber * Track;

- (NSString *)toString;

@end
