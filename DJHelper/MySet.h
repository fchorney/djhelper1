//
//  MySet.h
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-12.
//  Copyright 2011 Rollout Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MySet : NSObject {
    id _first;
    id _second;
}

@property (nonatomic, retain) id first;
@property (nonatomic, retain) id second;

- (id)initWithFirst:(id)__first Second:(id)__second;

@end
