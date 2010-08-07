//
//  verySimpleMusicThing2ViewController.h
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright Twirex 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface verySimpleMusicThing2ViewController : UIViewController {
	Player *player;
	IBOutlet UISlider *slider;
}

- (IBAction) play;
- (IBAction) stop;
- (IBAction) onValueChange:(id)sender;

@end

