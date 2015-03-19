//
//  FirstView.m
//  snowEmitter
//
//  Created by Chan Bill on 14/12/1.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView
{
    long mysize;
    UILabel *name ;
    UILabel *per;
    int state;
    long scolor;
}



- (id)initWithFrame:(CGRect)frame color:(long)color size:(long)size state:(int)sta
{
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    state = sta;
//    NSLog(@"size = %ld",size);
    if (sta==0) {
  
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 187,187)];
    [imageView setImage:[UIImage imageNamed:HisNodataImage]];
    
    [self addSubview:imageView];
   
    }
    else if(sta == 6)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140,140)];
        //[imageView setImage:[UIImage imageNamed:HisNodataImage]];
        
       
        
        
        switch (color) {
            case 1:
                [imageView setImage:[UIImage imageNamed:HisSafe]];
                break;
            case 2:
                [imageView setImage:[UIImage imageNamed:HisSafer]];
                break;
            case 3:
                [imageView setImage:[UIImage imageNamed:HisCenter]];
                break;
            case 4:
                [imageView setImage:[UIImage imageNamed:HisDanger]];
                break;
            case 5:
                [imageView setImage:[UIImage imageNamed:HisDangerest]];
                break;
                
            default:
                break;
        }

     [self addSubview:imageView];
    
    
    
    }
    else
    {
    name = [[UILabel alloc]initWithFrame:CGRectMake(size, size, 80, 20)];
        name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:12.0];
    name.center = CGPointMake(30, 30);
    [self addSubview:name];
 
    per = [[UILabel alloc]initWithFrame:CGRectMake(size, size, 40, 20)];
    per.text = [NSString stringWithFormat:@"%ld%%",size];
    per.textColor = [UIColor whiteColor];
    per.font = [UIFont systemFontOfSize:12.0];
    per.center = CGPointMake(30, 45);
        per.textAlignment = NSTextAlignmentCenter;
    [self addSubview:per];
    if (state == 1) {
        per.center = CGPointMake(60, 68);
        name.center = CGPointMake(60, 53);
    }else
    {
        per.hidden = YES;
        name.hidden =YES;
    }
    scolor = color;
//    NSLog(@"color = %ld",scolor);
    switch (scolor) {
            
        case 1:
//            _firstred = 0.3334;
//            _firstgreen = 0.7647;
//            _firstblue = 0.9294;
            _firstred = 3.0/255;
            _firstgreen = 184.0/255;
            _firstblue = 223.0/255;

            name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RtLv_Safest", @"MyLoaclization" , @"")];
            break;
        case 2:
//            _firstred =0.5960;
//            _firstgreen = 0.9176;
//            _firstblue =0.4784;
            _firstred = 69.0/255;
            _firstgreen = 176.0/255;
            _firstblue = 53.0/255;
            name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RtLv_Safer", @"MyLoaclization" , @"")];
            break;
        case 3:
//            _firstred = 1;
//            _firstgreen = 0.8352;
//            _firstblue = 0.0784;
            _firstred = 255.0/255;
            _firstgreen = 244.0/255;
            _firstblue = 98.0/255;
            name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RtLv_nomerl", @"MyLoaclization" , @"")];
            break;
        case 4:
//            _firstred = 0.9882;
//            _firstgreen = 0.5294;
//            _firstblue = 0.2823;
            _firstred = 250.0/255;
            _firstgreen = 190.0/255;
            _firstblue = 0.0/255;
            name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RtLv_danger", @"MyLoaclization" , @"")];
            break;
        case 5:
            _firstred = 234.0/255;
            _firstgreen = 85.0/255;
            _firstblue = 4.0/255;
            name.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RtLv_dangerer", @"MyLoaclization" , @"")];
            break;
            
        default:
            break;

    
        }
    }
        return self;
}





-(void)paintcircle
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context, _firstred, _firstgreen, _firstblue, 1);
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);
    if (state==1) {
        CGContextAddArc(context, 60, 60,60, 0, 2*PI, 0); //添加一个圆
    }
       else
        CGContextAddArc(context, 30, 30,30, 0, 2*PI, 0); //添加一个圆
        
    CGContextDrawPath(context, kCGPathFill);
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    if (state==0|state==6) {
        
    
    }
    else
        [self paintcircle];
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
