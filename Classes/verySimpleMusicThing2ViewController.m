//
//  verySimpleMusicThing2ViewController.m
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright Twirex 2010. All rights reserved.
//

#import "verySimpleMusicThing2ViewController.h"
#import "Player.h"

@implementation verySimpleMusicThing2ViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	player = [[Player alloc]init];
	[player initialize];
    [super viewDidLoad];
}

- (IBAction) play{
	NSLog(@"In the play");
	[player start];
}

- (IBAction) stop{
	[player stop];
}

- (IBAction) onValueChange:(id)sender{
	
	[player setFreq:slider.value];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
