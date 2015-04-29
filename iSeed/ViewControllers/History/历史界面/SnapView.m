//
//  SnapView.m
//  snowEmitter
//
//  Created by Chan Bill on 14/12/1.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#import "SnapView.h"

@implementation SnapView
{
    FLDemoView *firstView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 移除之前的仿真行为
    
    [self.animator removeAllBehaviors];
    
 //   CGPoint location = [touches.anyObject locationInView:self];
    [self SnapMove];
    
    //添加边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.thirdview,/*self.fifthview,self.fourthview,*/self.sedview,self.sixthview]];
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
        collision.collisionMode = UICollisionBehaviorModeEverything;
    [self.animator addBehavior:collision];
  
}

-(void)SnapMove
{
    //  添加行为

    //绿色
    UISnapBehavior *snap1 = [[UISnapBehavior alloc] initWithItem:self.firstview snapToPoint:CGPointMake(170, 340) ];
    [snap1 setDamping:15];
    [self.animator addBehavior:snap1];
    
    //蓝色
    
    UISnapBehavior *snap2 = [[UISnapBehavior alloc] initWithItem:self.sedview snapToPoint:CGPointMake(90, 300)];
    
    [snap2 setDamping:15];
    [self.animator addBehavior:snap2];
    
    // 红紫
    UISnapBehavior *snap3 = [[UISnapBehavior alloc] initWithItem:self.thirdview snapToPoint:CGPointMake(255, 300)];
    [snap3 setDamping:15];
    [self.animator addBehavior:snap3];
    
    //  红色
    UISnapBehavior *snap4 = [[UISnapBehavior alloc] initWithItem:self.fourthview snapToPoint:CGPointMake(123, 418)];
    [snap4 setDamping:15];
    [self.animator addBehavior:snap4];
    
    
    // 浅蓝
    UISnapBehavior *snap5 = [[UISnapBehavior alloc] initWithItem:self.fifthview snapToPoint:CGPointMake(215, 418)];
    [snap5 setDamping:15];
    // 添加仿真行为
    [self.animator addBehavior:snap5];
    
    UISnapBehavior *snap6 = [[UISnapBehavior alloc] initWithItem:self.sixthview snapToPoint:CGPointMake(170, 210)];
    [snap6 setDamping:5];
    // 添加仿真行为
    [self.animator addBehavior:snap6];
}
@end


