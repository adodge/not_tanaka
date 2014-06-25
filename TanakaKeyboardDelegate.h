//
//  TanakaKeyboardDelegate.h
//  nottanaka
//
//  Created by Alex Dodge on 8/4/10.
//  Copyright 2010 Roke Foundries. All rights reserved.
//

@protocol TanakaKeyboardDelegate <NSObject>

-(void) key:(unichar) c value:(BOOL)v;

@end
