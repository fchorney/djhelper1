//
//  KeyMath.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-17.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "KeyMath.h"

static KeyMath *sharedInstance = nil;

@implementation KeyMath

@synthesize keys = _keys;
@synthesize orderedKeys = _orderedKeys;

- (id)init {
    if ((self = [super init])) {
        NSMutableDictionary *keys = [[NSMutableDictionary alloc] initWithCapacity:24];
        [keys setObject:@"Abm" forKey:@"1A"];
        [keys setObject:@"BM" forKey:@"1B"];
        [keys setObject:@"Ebm" forKey:@"2A"];
        [keys setObject:@"F#M" forKey:@"2B"];
        [keys setObject:@"Bbm" forKey:@"3A"];
        [keys setObject:@"DbM" forKey:@"3B"];
        [keys setObject:@"Fm" forKey:@"4A"];
        [keys setObject:@"AbM" forKey:@"4B"];
        [keys setObject:@"Cm" forKey:@"5A"];
        [keys setObject:@"EbM" forKey:@"5B"];
        [keys setObject:@"Gm" forKey:@"6A"];
        [keys setObject:@"BbM" forKey:@"6B"];
        [keys setObject:@"Dm" forKey:@"7A"];
        [keys setObject:@"FM" forKey:@"7B"];
        [keys setObject:@"Am" forKey:@"8A"];
        [keys setObject:@"CM" forKey:@"8B"];
        [keys setObject:@"Em" forKey:@"9A"];
        [keys setObject:@"GM" forKey:@"9B"];
        [keys setObject:@"Bm" forKey:@"10A"];
        [keys setObject:@"DM" forKey:@"10B"];
        [keys setObject:@"F#m" forKey:@"11A"];
        [keys setObject:@"AM" forKey:@"11B"];
        [keys setObject:@"Dbm" forKey:@"12A"];
        [keys setObject:@"EM" forKey:@"12B"];
        
        self.keys = [keys mutableCopy];
        [keys release];
        
        NSMutableDictionary *orderedKeys = [[NSMutableDictionary alloc] initWithCapacity:12];
        [orderedKeys setObject:@"0" forKey:@"C"];
        [orderedKeys setObject:@"1" forKey:@"Db"];
        [orderedKeys setObject:@"2" forKey:@"D"];
        [orderedKeys setObject:@"3" forKey:@"Eb"];
        [orderedKeys setObject:@"4" forKey:@"E"];
        [orderedKeys setObject:@"5" forKey:@"F"];
        [orderedKeys setObject:@"6" forKey:@"F#"];
        [orderedKeys setObject:@"7" forKey:@"G"];
        [orderedKeys setObject:@"8" forKey:@"Ab"];
        [orderedKeys setObject:@"9" forKey:@"A"];
        [orderedKeys setObject:@"10" forKey:@"Bb"];
        [orderedKeys setObject:@"11" forKey:@"B"];
        
        self.orderedKeys = [keys mutableCopy];
        [orderedKeys release];
        
    }
    return self;
}

- (NSString *)stringForKey:(NSString *)key {
    return [self.keys objectForKey:key];
}

- (NSString *)keyForKey:(NSString *)__key withCents:(NSNumber *)__cents {
    double cents = [__cents doubleValue];
    //int key = [[__key substringToIndex:2] intValue];
    NSString *scale = nil;
    
    int range = 1;
    if ([__key length] == 3)
        range = 2;
    
    if ([[__key substringFromIndex:range] isEqualToString:@"A"])
        scale = @"m";
    else
        scale = @"M";
    
    NSString *stringKey = [self.keys objectForKey:__key];
    NSString *root = [stringKey substringToIndex:[stringKey length] - 1];
    
    //NSLog(@"Cents: %f, Key: %i, StringKey: %@, Root: %@%@",cents,key,stringKey,root,scale);
    
    int semiTones = cents / 100;
    int remainder = [[NSString stringWithFormat:@"%.0f",cents] intValue] - (semiTones * 100);
    
    //NSLog(@"Semi: %i, Remainder: %i",semiTones, remainder);
    
    int newRoot = ([[self.orderedKeys objectForKey:root] intValue] + semiTones) % 12;
    
    if (remainder > 50)
        newRoot = (newRoot + 1) % 12;
    
    if (remainder < -50)
        newRoot = newRoot - 1;
    
    while (newRoot < 0)
        newRoot += 12;
    
    newRoot = newRoot % 12;
    
    NSString *newRootString = nil;
    
    for (NSString *key in self.orderedKeys) {
        if ([[self.orderedKeys objectForKey:key] intValue] == newRoot) {
            newRootString = [NSString stringWithFormat:@"%@%@",key,scale];
            break;
        }
    }
    
    NSString *newRootCode = nil;
    
    for (NSString *key in self.keys) {
        if ([[self.keys objectForKey:key] isEqualToString:newRootString]) {
            newRootCode = key;
            break;
        }
    }
    
    //NSLog(@"New Root#: %i, New Root: %@, New Root Code: %@",newRoot,newRootString,newRootCode);
    
    //NSLog(@"\nOld Key Code: %@\nCents: %f\nKey: %i\nString Key: %@\nRoot: %@\nScale: %@\nSemi Tones: %i\nRemainder: %i\nNew Root: %i\nNew Key String: %@\nNew Key Code: %@",__key,cents,key,stringKey,root,scale,semiTones,remainder,newRoot,newRootString,newRootCode);
    
    return newRootCode;
}

+ (KeyMath *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned int)retainCount { 
    return NSUIntegerMax; // Denotes an object that cannot be released
}

- (oneway void) release {}

- (id)autorelease {
    return self;
}

@end
