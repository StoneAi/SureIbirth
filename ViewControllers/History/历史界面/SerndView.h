//
//  SerndView.h
//  iSeed
//
//  Created by Chan Bill on 14/12/22.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Sedview.h"

@interface SerndView : UIView

@property (weak, nonatomic) UIView *thirdview;
@property (weak, nonatomic) UIView *firstview;
@property (weak, nonatomic) UIView *sedview;
@property (weak, nonatomic) UIView *fourthview;
@property (weak, nonatomic) UIView *fifthview;

-(void)setSize:(NSInteger)firstsize Sedsize:(NSInteger)sedsize  Thirdsize:(float)thirdsize;
@property  (assign,nonatomic) NSInteger firstsize;
@property  (assign,nonatomic) NSInteger sedsize;
@property  (assign,nonatomic) float  thirdsize;
@property (assign,nonatomic) NSInteger fourthsize;
@property (assign,nonatomic) NSInteger fifthsize;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIDynamicAnimator *animator;


@end
