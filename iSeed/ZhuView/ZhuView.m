//
//  ZhuView.m
//  PointView
//
//  Created by Chan Bill on 15/4/28.
//  Copyright (c) 2015年 Viposes. All rights reserved.
//

#import "ZhuView.h"
#import "PNplot.h"
@implementation ZhuView
{
    CGFloat startwidth;
    CGFloat startheight;

}

- (void)addPlot:(PNplot *)newPlot;
{
    if(nil == newPlot ) {
        return;
    }
    
    if (newPlot.plottingValues.count ==0) {
        return;
    }
    
    
    if(self.plots == nil){
        _plots = [NSMutableArray array];
    }
    
    [self.plots addObject:newPlot];
    
    [self setNeedsDisplay];
}

-(void)clearPlot{
    if (self.plots) {
        [self.plots removeAllObjects];
    }
}



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
   // self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    startheight = 30;
    startwidth = 30;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    // self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    startheight = 30;
    startwidth = 30;
    self.backgroundColor = [UIColor whiteColor];
    return self;


}
-(void)drawRect:(CGRect)rect
{
    startheight = 30;
    startwidth = 30;
    self.backgroundColor = [UIColor whiteColor];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f , self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    PNplot* plot = [self.plots objectAtIndex:0];
   // CGContextSetStrokeColor(context, [self.plots objectAtIndex:0]);
   // CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);
    [plot.AxisColor set];
    CGContextSetLineWidth(context, 1);
    
    int time = 24/self.xCount;
    //画X轴
//    CGContextMoveToPoint(context, startwidth, startheight);
//    CGContextAddLineToPoint(context, self.bounds.size.width-2*startwidth, startheight);
    
    for (int i = 0; i<time; i++) {
        CGFloat pointw = startwidth/2+5+(self.bounds.size.width-2*startwidth)/time*(i+1);
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont boldSystemFontOfSize:self.labelfont];
        lable.text = [NSString stringWithFormat:@"%d",self.xCount*(i+1)];
        lable.frame = CGRectMake(0, 0, 40, 20);
        lable.center = CGPointMake(pointw,self.bounds.size.height-startheight/2);
        [self addSubview:lable];
    }
    
   // CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //画横线
    for (int i =0; i<=self.yCount; i++) {
        
        CGFloat pointh = startheight+(self.bounds.size.height-startheight)/self.yCount*i;
        CGContextMoveToPoint(context, startwidth/2, pointh-2);
        CGContextAddLineToPoint(context,self.bounds.size.width-startwidth, pointh-2);
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont boldSystemFontOfSize:self.labelfont];
        lable.text = [NSString stringWithFormat:@"%d",(self.ymax-self.ymin)/self.yCount*i];
        lable.frame = CGRectMake(0, 0, 40, 20);
        lable.textColor = [UIColor grayColor];
        lable.center = CGPointMake(self.bounds.size.width-startwidth/2,self.bounds.size.height- pointh);
        [self addSubview:lable];
        CGContextStrokePath(context);
    }

    //CGContextSetRGBStrokeColor(context, 61.0/255, 181.0/255, 189.0/255, 1);
    CGContextSetLineWidth(context, plot.lineWidth);
    
   
    [plot.linesColor set];
    

    for (int i =0; i<plot.plottingValues.count; i++) {
        NSNumber* value = [plot.plottingValues objectAtIndex:i];
        float floatValue = value.floatValue;
       // NSLog(@"float = %f",floatValue);
        if (floatValue>=67) {
            [[UIColor colorWithRed:244.0/255 green:154.0/255 blue:120.0/255 alpha:1] set];
        }
        else
            [plot.linesColor set];
        CGFloat pointwidth = startwidth/2+5+(self.bounds.size.width-2*startwidth)/time*(i+1);
        CGFloat pointheight = startheight+(self.bounds.size.height-startwidth)/self.yCount*(floatValue/(self.ymax/self.yCount));
        CGContextMoveToPoint(context, pointwidth,startheight);
        CGContextAddLineToPoint(context, pointwidth, pointheight);
        CGContextStrokePath(context);

    }
    
    
    
    
    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
