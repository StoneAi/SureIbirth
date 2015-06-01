//
//  SerndView.m
//  iSeed
//
//  Created by Chan Bill on 14/12/22.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "SerndView.h"

@implementation SerndView

-(void)layoutIfNeeded
{
    //TODO elias
//    UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 330, 568)];
//    myimage.image = [UIImage imageNamed:HisBackImage];
//    [self addSubview:myimage];
 
    if (_firstsize>20&&_firstsize<60) {
        
        
        Sedview * firstview = [[Sedview alloc]initWithFrame:CGRectMake(100, 270, 2*_firstsize, 2*_firstsize) color:1 size:_firstsize num:_thirdsize state:1];
        firstview.backgroundColor = [UIColor clearColor];
        [self addSubview:firstview];
        NSLog(@"画图1啊");
//        NSLog(@"firstsize = %ld",_firstsize);
        _firstview = firstview;
        
    }
    else if (_firstsize>=60)
    {
        Sedview * firstview = [[Sedview alloc]initWithFrame:CGRectMake(100,270,100,100) color:1 size:_firstsize num:_thirdsize state:2];
        firstview.backgroundColor = [UIColor clearColor];
        [self addSubview:firstview];
        NSLog(@"画图2啊");
//        NSLog(@"firstsize = %ld",_firstsize);
        _firstview = firstview;
        
    }
    else if(_firstsize<=20&_firstsize>0)
    {
        Sedview * firstview = [[Sedview alloc]initWithFrame:CGRectMake(210,320, 40, 40) color:1 size:_firstsize num:_thirdsize state:1];
        firstview.backgroundColor = [UIColor clearColor];
        [self addSubview:firstview];
        _firstview = firstview;
//        NSLog(@"画图2啊");
    }
    
    else if(_firstsize ==0)
    {
        if (_sedsize==0) {
        Sedview * firstview = [[Sedview alloc]initWithFrame:CGRectMake(100, 270, 2*100, 2*100) color:1 size:100 num:_thirdsize state:0];
        firstview.backgroundColor = [UIColor clearColor];
        [self addSubview:firstview];
//        NSLog(@"画图3");
        _firstview = firstview;

        }
        else {
            Sedview * firstview = [[Sedview alloc]initWithFrame:CGRectMake(210,320, 40, 40) color:1 size:_firstsize num:_thirdsize state:1];
            firstview.backgroundColor = [UIColor clearColor];
            [self addSubview:firstview];
            _firstview = firstview;
//            NSLog(@"画图4");
        }
        
    }
    
    if (_sedsize!=0) {

            Sedview * sedview = [[Sedview alloc]initWithFrame:CGRectMake(20, 130, 100, 100) color:2 size:_sedsize num:_thirdsize state:2];
            sedview.backgroundColor = [UIColor clearColor];
            [self addSubview:sedview];
            
            _sedview = sedview;
           // NSLog(@"画图");
//        }
        
    }
    else if(_sedsize==0)
    {
        if (_firstsize==0) {
            Sedview * sedview = [[Sedview alloc]initWithFrame:CGRectMake(20, 130, 2*1, 2*1) color:2 size:50 num:_thirdsize state:1];
            sedview.backgroundColor = [UIColor clearColor];
            [self addSubview:sedview];
            _sedview = sedview;
             _sedview.hidden=YES;
            //NSLog(@"画图6");
        }else{

            Sedview * sedview = [[Sedview alloc]initWithFrame:CGRectMake(20, 130, 100, 100) color:2 size:_sedsize num:_thirdsize state:2];
            sedview.backgroundColor = [UIColor clearColor];
            [self addSubview:sedview];
            _sedview = sedview;
//            NSLog(@"画图");

        }
    }

    if (_firstsize==0&&_sedsize==0) {
        Sedview * thirdview = [[Sedview alloc]initWithFrame:CGRectMake(20, 450, 2*50, 2*50) color:3 size:50 num:_thirdsize state:1];
        thirdview.backgroundColor = [UIColor clearColor];
        [self addSubview:thirdview];
        
        _thirdview = thirdview;
        thirdview.hidden=YES;
//        NSLog(@"画图7");
    }
    else{
        Sedview * thirdview = [[Sedview alloc]initWithFrame:CGRectMake(20, 450, 2*50, 2*50) color:3 size:50 num:_thirdsize state:1];
            thirdview.backgroundColor = [UIColor clearColor];
            [self addSubview:thirdview];
            
            _thirdview = thirdview;
//        NSLog(@"画图7啊");
        }

    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //    NSLog(@"number = %d,%d,%d,%d,%d",number[1],number[2],number[3],number[4],number[5]);
   
    return self;
}

-(void)setSize:(NSInteger)firstsize Sedsize:(NSInteger)sedsize  Thirdsize:(float)thirdsize
{
    _firstsize = firstsize;
    _sedsize = sedsize;
    _thirdsize = thirdsize;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self setNeedsLayout];
        [self layoutIfNeeded];
    });

    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end