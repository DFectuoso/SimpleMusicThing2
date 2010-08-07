//
//  verySimpleMusicThing2AppDelegate.h
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright Twirex 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class verySimpleMusicThing2ViewController;

@interface verySimpleMusicThing2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    verySimpleMusicThing2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet verySimpleMusicThing2ViewController *viewController;

@end

