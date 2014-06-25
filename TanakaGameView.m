//
//  TanakaGameView.m
//  nottanaka
//
//  Created by Alex Dodge on 8/3/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import "TanakaGameView.h"


@implementation TanakaGameView

@synthesize keyboardDelegate;

- (BOOL)acceptsFirstResponder {
    return YES;
}

-(id) init {
	self = [super init];
	
	[self setNeedsDisplay:YES];
	rotation = 0;
	distance = 0;
	
	return self;
}

-(void) setPlayerAngle:(float)rot Distance:(float)dist {
	rotation = rot;
	distance = dist;
	[self setNeedsDisplay: YES];
}

void drawCircle(int n, float z, float r){
	glPushMatrix();
	
	glTranslatef(0, 0, -z);
	glBegin(GL_QUADS);
	for(float i=0;i<M_PI*2-.1;){
		glColor3f(1,((int)z % 11)/11.0,((int)z % 10)/10.0);
		float i2 = i+M_PI/(n/2);
		glVertex3f(cos(i)*r,sin(i)*r,0);
		glVertex3f(cos(i2)*r,sin(i2)*r,0);
		glVertex3f(cos(i2)*r,sin(i2)*r,4);
		glVertex3f(cos(i)*r,sin(i)*r,4);
		i=i2;
	}
	glEnd();
	
	glPopMatrix();
}

void drawRays(int n, float z0, float z1, float r){
	glPushMatrix();
		
	glBegin(GL_LINES);
	glColor3f(1,1,1);
	for(float i=0;i<M_PI*2;i+=M_PI/(n/2)){
		glVertex3f(cos(i)*r,sin(i)*r,-z0);
		glVertex3f(cos(i)*r,sin(i)*r,-z1);
	}
	glEnd();
	
	glPopMatrix();
}

-(void) drawRect: (NSRect) bounds {
	[super drawRect:bounds];
	
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glEnable (GL_DEPTH_TEST);
	glEnable (GL_NICEST);
	glDepthFunc(GL_LEQUAL);
	
	NSRect b = [self bounds];
	glLoadIdentity();
	gluPerspective(30, b.size.width/b.size.height, .1, 400);
	glViewport(0, 0, b.size.width, b.size.height);
	
	glPushMatrix();
	
	glTranslatef(0,2,distance);
	glRotatef(rotation, 0, 0, 1);
	
	for(int i=floor(distance)-((int)floor(distance)%4);i<distance+100;i+=4){
		drawCircle(10, i, 3);
	}
	drawRays(10,distance, distance+100,3);
	
	glPopMatrix();
	
	[[self openGLContext] flushBuffer];
}

- (void)keyDown:(NSEvent *)event {
	if(keyboardDelegate == nil) return;
	NSString * s = [event characters];
	for(int i=0;i<[s length];i++){
		unichar c = [s characterAtIndex:i];
		[keyboardDelegate key:c value:YES];
	}
}

- (void)keyUp:(NSEvent *)event {
	if(keyboardDelegate == nil) return;
	NSString * s = [event characters];
	for(int i=0;i<[s length];i++){
		unichar c = [s characterAtIndex:i];
		[keyboardDelegate key:c value:NO];
	}
}

@end
