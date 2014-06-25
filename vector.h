/*
 *  vector.h
 *  nottanaka
 *
 *  Created by Alex Dodge on 8/4/10.
 *  Copyright 2010 Roke Foundries. All rights reserved.
 *
 */

#ifndef VECTOR_H
#define VECTOR_H

#include <math.h>
#include <string.h>
#include <stdlib.h>

typedef struct {
	float x,y,z;
} vector;

vector cross (vector a, vector b);
float dot(vector a, vector b);
vector cvector(float x, float y, float z);
vector normalize(vector c);
vector sub(vector a, vector b);

float * interpolateMatrices(float matrixs1[16], float matrixs2[16], float d);
float * transpose4x4 (float * m);
void invertMat(float * m, float * i);

#endif