//
//  KeyMath.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-17.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyMath : NSObject {
    NSDictionary *_keys;
    NSDictionary *_orderedKeys;
}

@property (nonatomic, retain) NSDictionary *keys;
@property (nonatomic, retain) NSDictionary *orderedKeys;

+ (KeyMath *)sharedInstance; //Singleton Method
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)keyForKey:(NSString *)__key withCents:(NSNumber *)__cents;
@end
