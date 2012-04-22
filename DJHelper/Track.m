//
//  Track.m
//  DJHelper
//
//  Created by Fernando Chorney on 11-05-11.
//  Copyright (c) 2011 Rollout Studios. All rights reserved.
//

#import "Track.h"


@implementation Track
@dynamic Title;
@dynamic Artist;
@dynamic Album;
@dynamic Key;
@dynamic Genre;
@dynamic BPM;
@dynamic Disc;
@dynamic Track;

- (NSString *)toString {
    return [NSString stringWithFormat:@"Track: {\n\tTitle: %@\n\tArtist: %@\n\tAlbum: %@\n\tKey: %@\n\tGenre: %@\n\tBPM: %@\n\tDisc: %@\n\tTrack: %@",self.Title,self.Artist,self.Album,self.Key,self.Genre,self.BPM,self.Disc,self.Track];
}

@end
