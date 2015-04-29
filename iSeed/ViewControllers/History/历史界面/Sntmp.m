//
//  Sntmp.m
//  iSeed
//
//  Created by Chan Bill on 14/12/22.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "Sntmp.h"

@implementation Sntmp

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
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.sedview,self.firstview,self.thirdview]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionMode = UICollisionBehaviorModeEverything;
    [self.animator addBehavior:collision];
    
}

-(void)SnapMove
{
    //  添加行为
    
    UISnapBehavior *snap1 = [[UISnapBehavior alloc] initWithItem:self.firstview snapToPoint:CGPointMake(160, 300) ];
    [snap1 setDamping:30];
    [self.animator addBehavior:snap1];
    
    //蓝色
    
    UISnapBehavior *snap2 = [[UISnapBehavior alloc] initWithItem:self.sedview snapToPoint:CGPointMake(160, 300)];
    
    [snap2 setDamping:30];
    [self.animator addBehavior:snap2];
    
    // 红紫
    UISnapBehavior *snap3 = [[UISnapBehavior alloc] initWithItem:self.thirdview snapToPoint:CGPointMake(160, 300)];
    [snap3 setDamping:30];
    [self.animator addBehavior:snap3];
    
    //  红色
//    UISnapBehavior *snap4 = [[UISnapBehavior alloc] initWithItem:self.fourthview snapToPoint:CGPointMake(160, 280)];
//    [snap4 setDamping:30];
//    [self.animator addBehavior:snap4];
//    
//    
//    // 浅蓝
//    UISnapBehavior *snap5 = [[UISnapBehavior alloc] initWithItem:self.fifthview snapToPoint:CGPointMake(160, 280)];
//    [snap5 setDamping:45];
    // 添加仿真行为
//    [self.animator addBehavior:snap5];
}

@end
