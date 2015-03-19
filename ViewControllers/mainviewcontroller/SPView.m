//
//  SPView.m
//  StockPlotting
//
//  Created by EZ on 13-11-5.
//  Copyright (c) 2013年 cactus. All rights reserved.
//
#define NLSystemVersionGreaterOrEqualThan(version)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER   NLSystemVersionGreaterOrEqualThan(7.0)
#define GraphColor      [[UIColor greenColor] colorWithAlphaComponent:0.5]
#define str(index)                                  [NSString stringWithFormat : @"%.f", [[self.values objectAtIndex:(index)] floatValue]]
#define point(x, y)                                 CGPointMake(x*kXScale, -y*kYScale+yOffset)
#import "SPView.h"
@interface SPView ()
@property (nonatomic, strong)   dispatch_source_t timer;

@end
@implementation SPView

const CGFloat   kXScale = 15;
const CGFloat   kYScale = 2.0;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
    CGFloat dx, CGFloat dy)
{
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

-(void)movesuper
{
    [self removeFromSuperview];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
    }
    self.backgroundColor = [UIColor whiteColor];
    [self setContentMode:UIViewContentModeRight];
    _values = [NSMutableArray array];
    
    UIButton *canclebutton = [[UIButton alloc] initWithFrame:CGRectMake(240, 520, 80, 40)];
    [canclebutton addTarget:self action:@selector(movesuper) forControlEvents:UIControlEventTouchUpInside];
    
    [canclebutton setTitle:@"退出" forState:UIControlStateNormal];
    [canclebutton setTitleColor:[UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1] forState:UIControlStateNormal];
    [canclebutton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self addSubview:canclebutton];
    
//    __weak id   weakSelf = self;
//    double      delayInSeconds = 0.25;
//    self.timer =
//    dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
//                           dispatch_get_main_queue());
//    dispatch_source_set_timer(
//                              _timer, dispatch_walltime(NULL, 0),
//                              (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
//    dispatch_source_set_event_handler(_timer, ^{
//        [weakSelf updateValues];
//    });
//    dispatch_resume(_timer);

    
    return self;
}

- (void)awakeFromNib
{
//    [self setContentMode:UIViewContentModeRight];
//    _values = [NSMutableArray array];
//
//    __weak id   weakSelf = self;
//    double      delayInSeconds = 0.25;
//    self.timer =
//        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
//            dispatch_get_main_queue());
//    dispatch_source_set_timer(
//        _timer, dispatch_walltime(NULL, 0),
//        (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
//    dispatch_source_set_event_handler(_timer, ^{
//            [weakSelf updateValues];
//        });
//    dispatch_resume(_timer);
}

- (void)updateValues:(double)nextValue
{
//    double nextValue = sin(CFAbsoluteTimeGetCurrent())
//        + ((double)rand() / (double)RAND_MAX);
    
    [self.values addObject:
    [NSNumber numberWithDouble:nextValue]];
   // [self.values initWithArray:array];
    CGSize size = self.bounds.size;

    /*
     *   UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
     *   if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
     *
     *
     *   }
     */
    CGFloat     maxDimension = size.width; // MAX(size.height, size.width);
    NSUInteger  maxValues =
        (NSUInteger)floorl(maxDimension / kXScale);

    if ([self.values count] > maxValues) {
        [self.values removeObjectsInRange:
        NSMakeRange(0, [self.values count] - maxValues)];
    }

    [self setNeedsDisplay];
}

- (void)dealloc
{
    dispatch_source_cancel(_timer);
}

- (void)drawRect:(CGRect)rect
{
    if ([self.values count] == 0) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx,
        [GraphColor CGColor]);

    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 2);

    CGMutablePathRef path = CGPathCreateMutable();

    CGFloat             yOffset = self.bounds.size.height*5 / 8;
    CGAffineTransform   transform =
        CGAffineTransformMakeScaleTranslate(kXScale, kYScale,
            0, yOffset);
    
    CGPathMoveToPoint(path, &transform, 0, 0);
    CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0); // self.bounds.size.width其实大了kXScale倍

    CGFloat y = [[self.values objectAtIndex:0] floatValue];
    CGPathMoveToPoint(path, &transform, 0, -y);
    [self drawAtPoint:point(0, y) withStr:str(0)];

    for (NSUInteger x = 1; x < [self.values count]; ++x) {
        y = [[self.values objectAtIndex:x] floatValue];
        CGPathAddLineToPoint(path, &transform, x, -y);
        [self drawAtPoint:point(x, y) withStr:str(x)];
    }

    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    CGContextStrokePath(ctx);

}

- (void)drawAtPoint:(CGPoint)point withStr:(NSString *)str
{
    
    if (IOS7_OR_LATER) {
       #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        [str drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8], NSStrokeColorAttributeName:GraphColor}];
       #endif
    } else {
        [str drawAtPoint:point withFont:[UIFont systemFontOfSize:8]];
    }
     
}

@end