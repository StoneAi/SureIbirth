//
//  FLDemoView.m
//  snowEmitter
//
//  Created by Chan Bill on 14/12/1.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#import "FLDemoView.h"

@implementation FLDemoView
{
    SHOWTYPE showtype;
}
-(void)layoutIfNeeded
{
    UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 330, 568)];
    myimage.image = [UIImage imageNamed:HisBackImage];
    [self addSubview:myimage];
    if(_firstsize ==0&&_sedsize == 0&&_thirdsize==0)
    {
        FirstView * firstview = [[FirstView alloc]initWithFrame:CGRectMake(110, 320, 2*100, 2*100) color:1 size:100 state:0];
        firstview.backgroundColor = [UIColor clearColor];
        [self addSubview:firstview];
        //  NSLog(@"画图3");
        _firstview = firstview;
        FirstView * sedview = [[FirstView alloc]initWithFrame:CGRectMake(20, 130, 100, 100) color:2 size:1 state:2];
        sedview.backgroundColor = [UIColor clearColor];
        [self addSubview:sedview];
        _sedview = sedview;
        
        FirstView *thirdview = [[FirstView alloc]initWithFrame:CGRectMake(20, 470, 4*10,4*10) color:3 size:1 state:3];
        thirdview.backgroundColor = [UIColor clearColor];
        [self addSubview:thirdview];
        _thirdview = thirdview;
        
        FirstView *fourthview = [[FirstView alloc]initWithFrame:CGRectMake(180, 120, 4*10, 4*10) color:4 size:1 state:4];
        fourthview.backgroundColor = [UIColor clearColor];
        [self addSubview:fourthview];
        _fourthview = fourthview;
        
        FirstView *fifthview = [[FirstView alloc]initWithFrame:CGRectMake(240, 400, 4*10, 4*10) color:5 size:1 state:5];
        fifthview.backgroundColor = [UIColor clearColor];
        [self addSubview:fifthview];
        _fifthview = fifthview;
        
        FirstView *sixview = [[FirstView alloc]initWithFrame:CGRectMake(240, 400, 4*10, 4*10) color:5 size:1 state:5];
        sixview.backgroundColor = [UIColor clearColor];
        [self addSubview:sixview];
        _sixthview = sixview;
        
        _sedview.hidden=YES;
        _thirdview.hidden = YES;
        _fourthview.hidden = YES;
        _fifthview.hidden = YES;
        _sixthview.hidden = YES;
    }
    else{
        if (showtype == showtypeface) {
            long array[] = {_firstsize,_sedsize,_thirdsize,_fourthsize,_fifthsize};
            long *sort = [self sort_array:array];
          //  long *colorarray = [self color:sort];
            
            
            
            
                FirstView * firstview = [[FirstView alloc]initWithFrame:CGRectMake(110, 320, 120, 120) color:[self color:sort][0] size:sort[0] state:1];
                firstview.backgroundColor = [UIColor clearColor];
                [self addSubview:firstview];
                _firstview = firstview;
           
            
                FirstView * sedview = [[FirstView alloc]initWithFrame:CGRectMake(55, 320, 60, 60) color:[self color:sort][1] size:sort[1] state:2];
                sedview.backgroundColor = [UIColor clearColor];
                [self addSubview:sedview];
                _sedview = sedview;
                
                FirstView *thirdview = [[FirstView alloc]initWithFrame:CGRectMake(225, 320, 60,60) color:[self color:sort][2] size:sort[2] state:3];
                thirdview.backgroundColor = [UIColor clearColor];
                [self addSubview:thirdview];
                _thirdview = thirdview;
                
                FirstView *fourthview = [[FirstView alloc]initWithFrame:CGRectMake(93, 428, 60, 60) color:[self color:sort][3] size:sort[3] state:4];
                fourthview.backgroundColor = [UIColor clearColor];
                [self addSubview:fourthview];
                _fourthview = fourthview;

                FirstView *fifthview = [[FirstView alloc]initWithFrame:CGRectMake(185, 428, 60, 60) color:[self color:sort][4] size:sort[4] state:5];
                fifthview.backgroundColor = [UIColor clearColor];
                [self addSubview:fifthview];
                _fifthview = fifthview;
            
            FirstView *sixview = [[FirstView alloc]initWithFrame:CGRectMake(100, 180, 140, 140) color:[self color:sort][0] size:0 state:6];
            sixview.backgroundColor = [UIColor clearColor];
            [self addSubview:sixview];
            
            _sixthview = sixview;
        }
        
        
    }
    

     _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //    NSLog(@"number = %d,%d,%d,%d,%d",number[1],number[2],number[3],number[4],number[5]);
        return self;
}
-(void)setFirstsize:(NSInteger)firstsize sedsize:(NSInteger)sedsize thirdsize:(NSInteger)thirsize foursize:(NSInteger)foursize fifthsize:(NSInteger)fifthsize type:(SHOWTYPE)showtyp
{
    _firstsize = firstsize;
    _sedsize = sedsize;
    _thirdsize = thirsize;
    _fourthsize = foursize;
    _fifthsize = fifthsize;
    showtype = showtyp;
   // NSLog(@"1");
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self setNeedsLayout];
        [self layoutIfNeeded];
    });
}
//冒泡算法
-(long *)sort_array:(long*)arr
{
    long temp;
    for(int i = 0 ; i < 5;i++){
        
        for(int k = 1; k < (5-i); k++){
            
            if(arr[k-1] < arr[k]){
                
                temp = arr[k];
                arr[k] = arr[k-1];
                arr[k-1] = temp;
            }
        }
//        NSLog(@"arr = %ld",arr[i]);
    }
    
    return arr;
}
//颜色排列
-(long *)color:(long *)arr
{
    long colorarry[5] = {};
    for (int i =0; i<5; i++) {
        
        /****************目的：为了防止不同类型数据数值相等时颜色相同***********************/
        if (i==0) {
        if (arr[i]==_fifthsize) {
            colorarry[i]=5;
        }
        if (arr[i]==_fourthsize) {
            colorarry[i]=4;
        }
        if (arr[i]==_thirdsize) {
            colorarry[i]=3;
        }
        if (arr[i]==_sedsize) {
            colorarry[i]=2;
        }
        if (arr[i]==_firstsize) {
            colorarry[i]=1;
        }
    }
        if (i==1) {
            if (arr[i]==_fifthsize) {
                colorarry[i]=5;
            }
            if (arr[i]==_fourthsize) {
                colorarry[i]=4;
            }
            if (arr[i]==_thirdsize) {
                colorarry[i]=3;
            }
            if (arr[i]==_firstsize) {
                colorarry[i]=1;
            }
            if (arr[i]==_sedsize) {
                colorarry[i]=2;
            }
         

        }
        if (i==2) {
            if (arr[i]==_firstsize) {
                colorarry[i]=1;
            }
            if (arr[i]==_sedsize) {
                colorarry[i]=2;
            }
            if (arr[i]==_fourthsize) {
                colorarry[i]=4;
            }
            if (arr[i]==_fifthsize) {
                colorarry[i]=5;
            }
            if (arr[i]==_thirdsize) {
                colorarry[i]=3;
            }
            
        }
        if (i==3) {
            if (arr[i]==_sedsize) {
                colorarry[i]=2;
            }
            if (arr[i]==_firstsize) {
                colorarry[i]=1;
            }

            if (arr[i]==_thirdsize) {
                colorarry[i]=3;
            }
            if (arr[i]==_fifthsize) {
                colorarry[i]=5;
            }
            if (arr[i]==_fourthsize) {
                colorarry[i]=4;
            }
        }
        if (i==4) {
            if (arr[i]==_firstsize) {
                colorarry[i]=1;
            }
            if (arr[i]==_sedsize) {
                colorarry[i]=2;
            }

            if (arr[i]==_fourthsize) {
                colorarry[i]=4;
            }
            if (arr[i]==_thirdsize) {
                colorarry[i]=3;
            }
          
            if (arr[i]==_fifthsize) {
                colorarry[i]=5;
            }
    
        }
    
    }
   
    long  *colorarray = colorarry;
    
    return colorarray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
