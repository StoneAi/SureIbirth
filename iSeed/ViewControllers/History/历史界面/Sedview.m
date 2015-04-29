//
//  Sedview.m
//  iSeed
//
//  Created by Chan Bill on 14/12/22.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "Sedview.h"

@implementation Sedview
{
    UILabel *name ;
    UILabel *per;
    int state ;
    int mycolor;
}


//state = 0 无数据/state = 1 正常情况/state = 2 /state = 3 
- (id)initWithFrame:(CGRect)frame color:(int)color size:(long)size num:(float)num state:(int)sta
{
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    state = sta;
    mycolor = color;
//    NSLog(@"state@ = %d",state);
//    NSLog(@"color@ = %d",mycolor);
    if (sta==0) {
        
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 187,187)];
        [imageView setImage:[UIImage imageNamed:HisNodataImage]];
        
        [self addSubview:imageView];
        
    }
    else
    {
        name = [[UILabel alloc]initWithFrame:CGRectMake(size, size, 40, 20)];
        name.textColor = [UIColor grayColor];
        name.font = [UIFont systemFontOfSize:12.0];
        name.center = CGPointMake(size+5, size-5);
        [self addSubview:name];
        
        
        
        per = [[UILabel alloc]initWithFrame:CGRectMake(size, size, 60, 20)];
        per.text = [NSString stringWithFormat:@"%dCal",(int)(((float)size/100)*num)];
        if (mycolor==3) {
            name.frame = CGRectMake(size, size, 50, 30);
            name.center = CGPointMake(size+5, size-5);
          per.text = [NSString stringWithFormat:@"%dCal",(int)num];
        }
        //    if (state==2) {
        //        per.text = [NSString stringWithFormat:@"%d%%",(int)(size/1.5)];
        //    }
        per.textColor = [UIColor grayColor];
        per.font = [UIFont systemFontOfSize:12.0];
        per.center = CGPointMake(size+3, size+10);
        per.textAlignment = NSTextAlignmentCenter;
        name.textAlignment = NSTextAlignmentCenter;
        if (size<20&size>=0) {
            per.center = CGPointMake(20, 30);
            name.center = CGPointMake(22, 15);
        }
        [self addSubview:per];
        _firlong = size;
        if (state==2) {
            per.center = CGPointMake(55, 55);
            name.center = CGPointMake(55, 40);
        }
        switch (color) {
                
            case 1:
                _firstred = 0.3334;
                _firstgreen = 0.7647;
                _firstblue = 0.9294;
                name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SpLv_HaveDone", @"MyLoaclization" , @"")];
                break;
            case 2:
//                _firstred =0.5960;
//                _firstgreen = 0.9176;
//                _firstblue =0.4784;
                _firstred = 1;
                _firstgreen = 0.8352;
                _firstblue = 0.0784;
                name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SpLv_NeedDone", @"MyLoaclization" , @"")];
                break;
            case 3:
//                _firstred = 1;
//                _firstgreen = 0.8352;
//                _firstblue = 0.0784;
                _firstred =0.5960;
                _firstgreen = 0.9176;
                _firstblue =0.4784;
                name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SpLv_HaveToDone", @"MyLoaclization" , @"")];
                break;
            case 4:
                _firstred = 0.9882;
                _firstgreen = 0.5294;
                _firstblue = 0.2823;
                name.text = [NSString stringWithFormat:@"较危险"];
                break;
            case 5:
                _firstred = 254./255;
                _firstgreen = 16./255;
                _firstblue = 40./255;
                name.text = [NSString stringWithFormat:@"危险"];
                break;
                
            default:
                break;
                
                
        }
    }
    return self;
}





-(void)paintcircle
{
    if (mycolor==3) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor (context, _firstred, _firstgreen, _firstblue, 0.8);
        CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
        CGContextSetLineWidth(context, 1.0);
         CGContextAddArc(context, _firlong, _firlong,_firlong, 0, 2*PI, 0);
        CGContextDrawPath(context, kCGPathFill);
//        NSLog(@"正常画1");
    }
    else{
        if (state==1) {
            if (_firlong<=20&_firlong>=0) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBFillColor (context, _firstred, _firstgreen, _firstblue, 0.8);
                CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
                CGContextSetLineWidth(context, 1.0);
                CGContextAddArc(context, 20, 20,20, 0, 2*PI, 0);
                //        NSLog(@"state = %d",state);
                //        NSLog(@"mycolor = %d",mycolor);
                CGContextDrawPath(context, kCGPathFill);
            }
            else{
                //        NSLog(@"正常画2");
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBFillColor (context, _firstred, _firstgreen, _firstblue, 0.8);
                CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
                CGContextSetLineWidth(context, 1.0);
                CGContextAddArc(context, _firlong, _firlong,_firlong, 0, 2*PI, 0); //添加一个圆
                CGContextDrawPath(context, kCGPathFill);
            }

        }
        
        

    
        if (state==2) {
//            NSLog(@"正常画2");
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBFillColor (context, _firstred, _firstgreen, _firstblue, 0.8);
            CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
            CGContextSetLineWidth(context, 1.0);
            CGContextAddArc(context, 50, 50,50, 0, 2*PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);
  
            }
    }
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    if (state!=0) {
        
        [self paintcircle];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_animator removeAllBehaviors];
    CGPoint location = [touches.anyObject locationInView:self.superview];
    self.center = location;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
