//
//  TanakaGameView.m
//  nottanaka
//
//  Created by Alex Dodge on 8/3/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import "TanakaGameView.h"


@implementation TanakaGameView

@synthesize keyboardDelegate,course;

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
	glBegin(GL_QUADS);
	for(float i=0;i<M_PI*2-M_PI/(n);i+=M_PI/(n/2)){
		float i2 = i+M_PI/(n/2);
		glVertex3f(cos(i)*r,sin(i)*r,z/2);
		glVertex3f(cos(i2)*r,sin(i2)*r,z/2);
		glVertex3f(cos(i2)*r,sin(i2)*r,-z/2);
		glVertex3f(cos(i)*r,sin(i)*r,-z/2);
	}
	glEnd();
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
	gluPerspective(60, b.size.width/b.size.height, .1, 400);
	glViewport(0, 0, b.size.width, b.size.height);
	
	glPushMatrix();
	
	int segmentid = [course getSegmentIdForDistance:distance];
	TanakaCourseSegment * s1 = [course segment:segmentid];
	TanakaCourseSegment * s2 = [course segment:segmentid+1];
	float d = (distance-s1->dfromstart)/s1->d;
	
	float *matrixinterpolated, matrix[16];
	matrixinterpolated = interpolateMatrices(s1->facingmatrix, s2->facingmatrix, d);
	invertMat(matrixinterpolated, matrix);
	free(matrixinterpolated);
	
	glTranslatef(0,s1->r-1,0);
	glRotatef(rotation, 0, 0, 1);
	
	glMultMatrixf(matrix);
	
	for(int i=0;i<[course nsegments];i++){
		TanakaCourseSegment * s = [course segment:i];
		
		glPushMatrix();
			glMultMatrixf(s->matrix);
			glColor3f(1,((int)i % 13)/13.0,((int)i % 11)/11.0);
			drawCircle(10, 1, s->r);
		glPopMatrix();
	}
	
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
