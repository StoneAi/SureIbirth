//
//  FLDemoView.h
//  snowEmitter
//
//  Created by Chan Bill on 14/12/1.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FirstView.h"

@interface FLDemoView : UIView
typedef enum
{
    showtypedefault,
    showtypeface
}SHOWTYPE;
//- (id)initWithFrame:(CGRect)frame num:(int *)number;
@property (weak, nonatomic) UIView *thirdview;
@property (weak, nonatomic) UIView *firstview;
@property (weak, nonatomic) UIView *sedview;
@property (weak, nonatomic) UIView *fourthview;
@property (weak, nonatomic) UIView *fifthview;
@property (weak, nonatomic) UIView *sixthview;
@property (strong,nonatomic) UIImageView *Head;



@property  (assign,nonatomic) NSInteger firstsize;
@property  (assign,nonatomic) NSInteger sedsize;
@property  (assign,nonatomic) NSInteger  thirdsize;
@property  (assign,nonatomic) NSInteger  fourthsize;
@property  (assign,nonatomic) NSInteger  fifthsize;

@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIDynamicAnimator *animator;

-(void)setFirstsize:(NSInteger)firstsize sedsize:(NSInteger)sedsize thirdsize:(NSInteger)thirsize foursize:(NSInteger)foursize fifthsize:(NSInteger)fifthsize type:(SHOWTYPE)showtype;
@end
