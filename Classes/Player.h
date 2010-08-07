//
//  Player.h
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright 2010 Twirex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Player : NSObject {
	int freq;
}

@property int freq;

- (void) initialize;
- (void) start;
- (void) stop;

@end
