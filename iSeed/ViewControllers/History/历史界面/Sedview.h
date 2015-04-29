//
//  Sedview.h
//  iSeed
//
//  Created by Chan Bill on 14/12/22.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface Sedview : UIView

#define PI 3.1415926
@property (strong, nonatomic) UIDynamicAnimator *animator;


- (id)initWithFrame:(CGRect)frame color:(int)color size:(long)size num:(float)num state:(int)sta;

@property  (assign,nonatomic) float firstred;
@property  (assign,nonatomic) float firstgreen;
@property  (assign,nonatomic) float firstblue;
@property  (assign,nonatomic) NSInteger firlong;

@end