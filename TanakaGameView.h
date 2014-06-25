//
//  TanakaGameView.h
//  nottanaka
//
//  Created by Alex Dodge on 8/3/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <math.h>
#import "Course.h"
#include "vector.h"

#import "TanakaKeyboardDelegate.h"

@interface TanakaGameView : NSOpenGLView {
	float rotation;
	float distance;
	id <TanakaKeyboardDelegate> keyboardDelegate;
	Course * course;
}

-(void) setPlayerAngle:(float)rot Distance:(float)dist;

@property (retain) id keyboardDelegate;
@property (retain) Course * course;

@end
