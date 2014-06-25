//
//  TanakaGameController.h
//  nottanaka
//
//  Created by Alex Dodge on 8/3/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TanakaGameView.h"
#import "TanakaKeyboardDelegate.h"

#define FPS 60.0

@interface TanakaGameController : NSObject <TanakaKeyboardDelegate> {
	TanakaGameView *gameView;
	NSTimer * frameTimer;
	
	bool keys_left, keys_right, keys_up;
	
	float player_rotation;
	float player_distance;
}

@property (retain) IBOutlet TanakaGameView *gameView;

@end
