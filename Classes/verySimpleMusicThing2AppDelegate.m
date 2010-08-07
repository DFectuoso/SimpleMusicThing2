//
//  verySimpleMusicThing2AppDelegate.m
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright Twirex 2010. All rights reserved.
//

#import "verySimpleMusicThing2AppDelegate.h"
#import "verySimpleMusicThing2ViewController.h"

@implementation verySimpleMusicThing2AppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
