/*
 *  vector.c
 *  nottanaka
 *
 *  Created by Alex Dodge on 8/4/10.
 *  Copyright 2010 Roke Foundries. All rights reserved.
 *
 */

#include "vector.h"

vector cross (vector a, vector b) {
	vector c;
	c.x = a.y*b.z - a.z*b.y;
	c.y = a.z*b.x - a.x*b.z;
	c.z = a.x*b.y - a.y*b.x;
	return c;
}

float dot (vector a, vector b){
	return a.x*b.x + a.y*b.y + a.z*b.z;
}

vector cvector(float x, float y, float z) {
	vector c;
	c.x = x;
	c.y = y;
	c.z = z;
	return c;
}

vector normalize(vector c){
	float d = sqrt(c.x*c.x + c.y*c.y + c.z*c.z);
	c.x /= d;
	c.y /= d;
	c.z /= d;
	return c;
}

vector sub(vector a, vector b) {
	vector c;
	c.x = a.x-b.x;
	c.y = a.y-b.y;
	c.z = a.z-b.z;
	return c;
}

float * interpolateMatrices(float matrixs1[16], float matrixs2[16], float d) {
	float * out = malloc(sizeof(float)*16);
	for(int i=0;i<16;i++){
		out[i] = matrixs1[i] * (1-d) + matrixs2[i] * d;
	}
	return out;
}

float * transpose4x4 (float * m){
	float t[16];
	for(int i=0;i<4;i++){
		for(int o=0;o<4;o++){
			t[i+o*4] = m[o+i*4];
		}
	}
	memcpy(m, t, sizeof(float)*16);
	return m;
}

//http://www.opengl.org/discussion_boards/ubbthreads.php?ubb=showflat&Number=50088
void invertMat(float *m, float *i) {
	vector t = cvector(m[12],m[13],m[14]);
	vector o = cvector(dot(cvector(m[0],m[1],m[2]),t), 
					dot(cvector(m[4],m[5],m[6]),t), 
					dot(cvector(m[8],m[9],m[10]),t)); 
	
	i[0] =m[0]; i[1] =m[4]; i[2] =m[8]; i[3] =0;
	i[4] =m[1]; i[5] =m[5]; i[6] =m[9]; i[7] =0;
	i[8] =m[2]; i[9] =m[6]; i[10]=m[10];i[11]=0;
	i[12]=-o.x; i[13]=-o.y; i[14]=-o.z; i[15]=1;
}