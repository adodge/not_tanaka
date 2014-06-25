//
//  TanakaGameController.m
//  nottanaka
//
//  Created by Alex Dodge on 8/3/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import "TanakaGameController.h"


@implementation TanakaGameController
@synthesize gameView;

-(void) awakeFromNib {
	keys_left = keys_right = keys_up = NO;
	player_rotation = player_distance = 0;
	
	[gameView setKeyboardDelegate:self];
	frameTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/FPS) target:self selector:@selector(frame:) userInfo:nil repeats:YES];
}

-(void) frame: (NSTimer*)timer {
	if(keys_left){
		player_rotation += 90/(FPS);
	}
	if(keys_right){
		player_rotation -= 90/(FPS);
	}
	player_distance += 30/(FPS);
	[gameView setPlayerAngle:player_rotation Distance:player_distance];
}

-(void) key:(unichar) c value:(BOOL)v {
	NSLog(@"%c is %s", c, v ? "down" : "up");
	switch (c) {
		case 'a':
			keys_left = v;
			break;
		case 'd':
			keys_right = v;
			break;
		case 'w':
			keys_up = v;
			break;
		default:
			break;
	}
}

@end
