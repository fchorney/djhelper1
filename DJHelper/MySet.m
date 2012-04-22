//
//  MySet.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-12.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import "MySet.h"


@implementation MySet

@synthesize first = _first;
@synthesize second = _second;

- (id)initWithFirst:(id)__first Second:(id)__second {
    if ((self = [super init])) {
        self.first = __first;
        self.second = __second;
    }
    return self;
}

- (void)dealloc {
    [_first release];
    [_second release];
    [super dealloc];
}

@end
