//
//  Course.m
//  nottanaka
//
//  Created by Alex Dodge on 8/4/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

#import "Course.h"

/*
 typedef struct {
 char type;
 float x,y,z;
 float dx,dy,dz;
 float r,a;
 } TanakaCourseSegment;
*/


@implementation Course

@synthesize segments,nsegments,totalDistance;

-(id) init {
	self = [super init];
	nsegments = 0;
	segments = malloc(0);
	return self;
}

-(int) getSegmentIdForDistance:(float)distance{
	for(int i=0;i<nsegments;i++){
		if(segments[i].dfromstart > distance) return i;
	}
	return nsegments-1;
}

-(void) circularTrackWithRadius:(float)radius andSegments:(int)n {
	free(segments);
	nsegments = n;
	segments = malloc(sizeof(TanakaCourseSegment)*n);
	
	for(int i=0;i<n;i++){
		TanakaCourseSegment seg;
		seg.type = 0;
		seg.y = seg.dy = 0;
		seg.x = cos(((float)i/n)*2*M_PI)*radius;
		seg.z = sin(((float)i/n)*2*M_PI)*radius;
		seg.dx = -sin(((float)i/n)*2*M_PI);
		seg.dz = cos(((float)i/n)*2*M_PI);
		seg.r = 3;
		seg.a = 0;
		segments[i] = seg;
	}
	
	[self calculateMatrices];
	[self calculateDistances];
}

float * matrixFromHeadingPosition(vector heading, vector position){
	float * matrix = malloc(sizeof(float)*16);
	memset(matrix, 0, sizeof(float)*15);
	matrix[15] = 1;
	
	vector right = normalize(cross(cvector(0,1,0), heading));
	vector backwards = normalize(cross(right, cvector(0,1,0)));
	vector up = cross(backwards, right);
	
	memcpy(&matrix[0], &right, sizeof(vector));
	memcpy(&matrix[4], &up, sizeof(vector));
	memcpy(&matrix[8], &backwards, sizeof(vector));
	memcpy(&matrix[12], &position, sizeof(vector));
	
	return matrix;
}

-(void) calculateMatrices {
	for(int i=0;i<nsegments;i++){
		TanakaCourseSegment * s = &segments[i];
		float * matrix = matrixFromHeadingPosition(cvector(s->dx, s->dy, s->dz), cvector(s->x, s->y, s->z));
		memcpy(s->matrix, matrix, sizeof(float)*16);
		
		if(i != nsegments-1){
			TanakaCourseSegment * s2 = &segments[i+1];
			float * facingmatrix = matrixFromHeadingPosition(
															 normalize(sub(
																		   cvector(s->x, s->y, s->z),
																		   cvector(s2->x, s2->y, s2->z)
																 )),
															 cvector(s->x, s->y, s->z));
			memcpy(s->facingmatrix, facingmatrix, sizeof(float)*16);
			free(facingmatrix);
		}else{
			memcpy(s->facingmatrix, matrix, sizeof(float)*16); 
		}
		
		free(matrix);
	}
}

-(void) calculateDistances {
	float d = 0;
	for(int i=0;i<nsegments-1;i++){
		TanakaCourseSegment * s1 = &segments[i];
		TanakaCourseSegment * s2 = &segments[i+1];
		float dx = s2->x - s1->x;
		float dy = s2->y - s1->y;
		float dz = s2->z - s1->z;
		s1->d = sqrt(dx*dx+dy*dy+dz*dz);
		s1->dfromstart = d;
		d += s1->d;
	}
	segments[nsegments-1].d = 0;
	segments[nsegments-1].dfromstart = totalDistance = d;
}

-(TanakaCourseSegment*) segment:(int)i {
	return &segments[i];
}

@end
