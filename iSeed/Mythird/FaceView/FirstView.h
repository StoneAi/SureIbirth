//
//  FirstView.h
//  snowEmitter
//
//  Created by Chan Bill on 14/12/1.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface FirstView : UIView

#define PI 3.1415926
@property (strong, nonatomic) UIDynamicAnimator *animator;


- (id)initWithFrame:(CGRect)frame color:(long)color size:(long)size state:(int)sta;

@property  (assign,nonatomic) float firstred;
@property  (assign,nonatomic) float firstgreen;
@property  (assign,nonatomic) float firstblue;
@property  (assign,nonatomic) NSInteger firlong;

@end
