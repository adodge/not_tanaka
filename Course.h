//
//  Course.h
//  nottanaka
//
//  Created by Alex Dodge on 8/4/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <math.h>
#include "vector.h"

typedef struct {
	char type;
	float x,y,z;
	float dx,dy,dz;
	float r,a;
	float matrix[16];
	float facingmatrix[16];
	float d,dfromstart;
} TanakaCourseSegment;

@interface Course : NSObject {
	TanakaCourseSegment * segments;
	int nsegments;
	float totalDistance;
}

-(int) getSegmentIdForDistance:(float)distance;
-(void) circularTrackWithRadius:(float)radius andSegments:(int)n;
-(TanakaCourseSegment*) segment:(int)i;
-(void) calculateMatrices;
-(void) calculateDistances;

@property (readonly) TanakaCourseSegment * segments;
@property (readonly) int nsegments;
@property (readonly) float totalDistance;

@end
