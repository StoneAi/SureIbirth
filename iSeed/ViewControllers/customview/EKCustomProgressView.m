//
// EKCustomProgressView.m
// EKCustomProgress
//
//
// Copyright (c) 2013 Marco Dinacci. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "EKCustomProgressView.h"
#import "EKCustomProgressLabel.h"
#import "EKCustomProgressTheme.h"
#define CircleColor [UIColor colorWithRed: 131.0/255 green: 204.0/255 blue: 210.0/255 alpha: 1] //圆环的颜色

@interface EKCustomProgressView ()
{
    NSArray *arrColor;
    UIColor *colortmp;
    BOOL ringColorInitialFlag;
    
    //add 0626
    NSArray *threeColor;
    
    
    //UIImageView* sencloudrarankView;
   // UIImageView* sencloudbigringbgView;
    
    //add 0620
   // CALayer *rootNeedleLayer;
    
   // BOOL jia;
}

// Padding from the view bounds to the outer circumference of the view.
// Useful because at times the circle may appear "cut" by one or two pixels
// since it's drawing over the view bounds.
@property (assign, nonatomic) NSUInteger internalPadding;

@end

//static float deltaAngle;

@implementation EKCustomProgressView
//@synthesize container, numberOfSections, startTransform, currentValue;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:[EKCustomProgressTheme standardTheme]];

    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andTheme:(EKCustomProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:theme];
    }
  
    return self;
}

- (void)awakeFromNib
{
    [self internalInitWithTheme:[EKCustomProgressTheme standardTheme]];
}

- (void)dealloc
{
    [self removeObserver:self.label forKeyPath:keyThickness];
}


- (void)internalInitWithTheme:(EKCustomProgressTheme *)theme
{
    // Default values for public properties
	self.progressTotal = 1;
	self.progressCounter = 0;
	self.startingSlice = 1;
    self.clockwise = YES;
    
    //add 0626
    self.egslpShow = NO;
    self.rtShow = NO;
    //add 0619
    self.realtimeShow = NO;
    //add 0623
    ringColorInitialFlag = YES;
    self.fixedringColornums = 0;
    
    self.raarray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],nil];
    NSArray *arrarythree = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:1603],[NSNumber numberWithInt:1722], nil];
    self.raarraygroup = [[NSArray alloc]initWithObjects:self.raarray, arrarythree,nil];
    self.raarraynum = 1;
    
    //add 0626
    self.engstrengtharray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:80],[NSNumber numberWithInt:300],[NSNumber numberWithInt:360],nil];
	
	// Use standard theme by default
	self.theme = theme;
	
	// Init the progress label, even if not visible.
	self.label = [[EKCustomProgressLabel alloc] initWithFrame:self.bounds andTheme:self.theme];
	[self addSubview:self.label];
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	
	// Important to avoid showing artifacts
	self.backgroundColor = [UIColor clearColor];
	
	// Register the progress label for changes in the thickness so that it can be repositioned.
	[self addObserver:self.label forKeyPath:keyThickness options:NSKeyValueObservingOptionNew context:nil];
    
    
    //add 0626
    threeColor = [[NSArray alloc]initWithObjects:
                  [UIColor colorWithRed:255./255 green:220./255 blue:15./255 alpha:1.0f],
                  [UIColor colorWithRed:252./255 green:135./255 blue:72./255 alpha:1.0f],
                  [UIColor colorWithRed:253./255 green:23./255 blue:46./255 alpha:1.0f],
                  nil];
    
    //add 0619
    arrColor = [[NSArray alloc]initWithObjects:
                [UIColor colorWithRed:86./255 green:189./255 blue:240./255 alpha:1.0f],
                [UIColor colorWithRed:86./255 green:192./255 blue:237./255 alpha:1.0f],
                [UIColor colorWithRed:85./255 green:195./255 blue:237./255 alpha:1.0f],
                [UIColor colorWithRed:84./255 green:198./255 blue:234./255 alpha:1.0f],
                [UIColor colorWithRed:83./255 green:201./255 blue:231./255 alpha:1.0f],
                [UIColor colorWithRed:82./255 green:204./255 blue:228./255 alpha:1.0f],
                [UIColor colorWithRed:81./255 green:207./255 blue:225./255 alpha:1.0f],
                [UIColor colorWithRed:80./255 green:210./255 blue:222./255 alpha:1.0f],
                [UIColor colorWithRed:79./255 green:213./255 blue:219./255 alpha:1.0f],
                [UIColor colorWithRed:79./255 green:216./255 blue:216./255 alpha:1.0f],
                [UIColor colorWithRed:78./255 green:219./255 blue:213./255 alpha:1.0f],
                [UIColor colorWithRed:77./255 green:222./255 blue:210./255 alpha:1.0f],
                [UIColor colorWithRed:77./255 green:229./255 blue:207./255 alpha:1.0f],
                [UIColor colorWithRed:92./255 green:230./255 blue:190./255 alpha:1.0f],
                [UIColor colorWithRed:107./255 green:231./255 blue:173./255 alpha:1.0f],
                [UIColor colorWithRed:122./255 green:232./255 blue:156./255 alpha:1.0f],
                [UIColor colorWithRed:137./255 green:233./255 blue:139./255 alpha:1.0f],
                [UIColor colorWithRed:152./255 green:234./255 blue:122./255 alpha:1.0f],
                [UIColor colorWithRed:167./255 green:235./255 blue:105./255 alpha:1.0f],
                [UIColor colorWithRed:182./255 green:236./255 blue:88./255 alpha:1.0f],
                [UIColor colorWithRed:197./255 green:237./255 blue:71./255 alpha:1.0f],
                [UIColor colorWithRed:212./255 green:238./255 blue:54./255 alpha:1.0f],
                [UIColor colorWithRed:227./255 green:239./255 blue:37./255 alpha:1.0f],
                [UIColor colorWithRed:242./255 green:240./255 blue:18./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:241./255 blue:0./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:234./255 blue:5./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:227./255 blue:10./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:220./255 blue:15./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:213./255 blue:20./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:206./255 blue:25./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:199./255 blue:30./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:192./255 blue:35./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:185./255 blue:40./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:178./255 blue:45./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:171./255 blue:50./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:164./255 blue:55./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:153./255 blue:63./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:147./255 blue:66./255 alpha:1.0f],
                [UIColor colorWithRed:253./255 green:141./255 blue:69./255 alpha:1.0f],
                [UIColor colorWithRed:252./255 green:135./255 blue:72./255 alpha:1.0f],
                [UIColor colorWithRed:251./255 green:129./255 blue:75./255 alpha:1.0f],
                [UIColor colorWithRed:250./255 green:123./255 blue:78./255 alpha:1.0f],
                [UIColor colorWithRed:249./255 green:117./255 blue:81./255 alpha:1.0f],
                [UIColor colorWithRed:248./255 green:111./255 blue:84./255 alpha:1.0f],
                [UIColor colorWithRed:247./255 green:105./255 blue:87./255 alpha:1.0f],
                [UIColor colorWithRed:247./255 green:99./255 blue:90./255 alpha:1.0f],
                [UIColor colorWithRed:246./255 green:93./255 blue:91./255 alpha:1.0f],
                [UIColor colorWithRed:245./255 green:87./255 blue:94./255 alpha:1.0f],
                [UIColor colorWithRed:245./255 green:79./255 blue:94./255 alpha:1.0f],
                [UIColor colorWithRed:246./255 green:72./255 blue:88./255 alpha:1.0f],
                [UIColor colorWithRed:247./255 green:65./255 blue:82./255 alpha:1.0f],
                [UIColor colorWithRed:248./255 green:58./255 blue:76./255 alpha:1.0f],
                [UIColor colorWithRed:249./255 green:51./255 blue:70./255 alpha:1.0f],
                [UIColor colorWithRed:250./255 green:44./255 blue:64./255 alpha:1.0f],
                [UIColor colorWithRed:251./255 green:37./255 blue:58./255 alpha:1.0f],
                [UIColor colorWithRed:252./255 green:30./255 blue:52./255 alpha:1.0f],
                [UIColor colorWithRed:253./255 green:23./255 blue:46./255 alpha:1.0f],
                [UIColor colorWithRed:254./255 green:16./255 blue:40./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:9./255 blue:34./255 alpha:1.0f],
                [UIColor colorWithRed:255./255 green:2./255 blue:28./255 alpha:1.0f],
                nil];
}

#pragma mark - Setters

//add 0626
-(void)setProgressSlice:(NSArray *)array
{
    _engstrengtharray = array;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    
}

-(void)setfixedRingone:(int)fixedringColornums
{
        _fixedringColornums = fixedringColornums;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
}

//add 0623
- (void)setfixedringColornums:(int)fixedringColornums secondringnums:(int)fixedringtwo threeringnums:(int)fixedringthree
{
    NSLog(@"11111111");
    
    dispatch_time_t popTimetmp = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(popTimetmp, dispatch_get_main_queue(), ^(void){
        
        _fixedringColornums = fixedringColornums;
        [self setNeedsDisplay];
    });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        _fixedringColornums = fixedringtwo;
            [self setNeedsDisplay];
    });
    
    dispatch_time_t popTimethree = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((5) * NSEC_PER_SEC));
    dispatch_after(popTimethree, dispatch_get_main_queue(), ^(void){
        
        _fixedringColornums = fixedringthree;
        [self setNeedsDisplay];
    });
    NSLog(@"222222222");
}

//add 0619
- (void)setcolorringCounternums:(NSUInteger)colorringCounternums
{
    _colorringCounternums = colorringCounternums;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setProgressCounter:(NSUInteger)progressCounter
{
	_progressCounter = progressCounter;
	[self notifyProgressChange];
    
    // setNeedsDisplay needs to be in the main queue to update
	// the drawRect if the caller of this method is in a different queue.
	dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setProgressTotal:(NSUInteger)progressTotal
{
	_progressTotal = progressTotal;
	[self notifyProgressChange];
	
	dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    
//    if (self.progressTotal <= 0) {
//        return;
//    }
    
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGSize viewSize = self.bounds.size;
	//CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    //add 0624
    CGPoint center = CGPointMake((viewSize.width-2) / 2, (viewSize.height-2) / 2);
    
	
	// Draw the slices if there's at least some progress or if, even without progress, the slice dividers are visible.
	//if (self.progressCounter > 0 || (self.progressCounter == 0 && ! self.theme.sliceDividerHidden)) {
		double radius = viewSize.width / 2 - self.internalPadding;
//		[self drawSlices:self.progressTotal
//			   completed:self.progressCounter
//				  radius:radius
//				  center:center
//			   inContext:contextRef];
    
        [self drawSlices:radius
              center:center
           inContext:contextRef];
	//}
    
	
	// Draw the slice separators, unless the sliceDividerHidden property is true.
	//if ((!self.realtimeShow)&&(! self.theme.sliceDividerHidden)) {
    if(self.rtShow){
        NSNumber *temp = [[self.raarraygroup objectAtIndex:0] objectAtIndex:1];
                //NSNumber *temp = [self.raarray objectAtIndex:1];
                int tempint = [temp intValue];
		[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center slicesnumarray:tempint slicescolor:[UIColor colorWithRed:255./255 green:241./255 blue:0./255 alpha:1.0f]];
        NSNumber *tempone = [self.raarray objectAtIndex:2];
        int temponeint = [tempone intValue];
        [self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center slicesnumarray:temponeint slicescolor:[UIColor colorWithRed:86./255 green:189./255 blue:240./255 alpha:1.0f]];
        NSNumber *temptwo = [self.raarray objectAtIndex:0];
        int temptwoint = [temptwo intValue];
        [self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center slicesnumarray:temptwoint slicescolor:[UIColor colorWithRed:254./255 green:153./255 blue:63./255 alpha:1.0f]];
        NSNumber *tempthree = [self.raarray objectAtIndex:3];
        int tempthreeint = [tempthree intValue];
        [self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center slicesnumarray:tempthreeint slicescolor:[UIColor colorWithRed:245./255 green:79./255 blue:94./255 alpha:1.0f]];
        
	}
    
    if (self.realtimeShow && !ringColorInitialFlag) {
        [self drawSlicesRealtime:contextRef withViewSize:viewSize andCenter:center sequencecount:_fixedringColornums];
        //[self drawSlicesRealtime:contextRef withViewSize:viewSize andCenter:center sequencecount:60];
    }
    
    if (self.realtimeShow && ringColorInitialFlag) {
        [self drawSlicesRealtime:contextRef withViewSize:viewSize andCenter:center sequencecount:60];
        ringColorInitialFlag = NO;
    }
    
    if (self.egslpShow) {
        int i = 0;
        for (i = 0; i< ([self.engstrengtharray count]-1); i++) {
            [self drawSlicesEgSlpFromto:contextRef withViewSize:viewSize andCenter:center fromsequencecount: [[self.engstrengtharray objectAtIndex:i] intValue] tosequencecount:[[self.engstrengtharray objectAtIndex:(i+1)] intValue] egslpColor:[threeColor objectAtIndex:i]];
        }
        

    }
   
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
    
}

//- (void)drawSlices:(NSUInteger)slicesCount
//         completed:(NSUInteger)slicesCompleted
//            radius:(double)circleRadius
//            center:(CGPoint)center
//         inContext:(CGContextRef)context

- (void)drawSlices:(double)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
   // NSUInteger startingSlice = self.startingSlice -1;
    
    //0620
   // UIImage *imagebg = [UIImage imageNamed:@"bigringbg0620"];
   // [imagebg drawAtPoint:CGPointMake(240, 240)];
    
    //add 0620
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, circleRadius,
                    0, numbledegree(360), cgClockwise);
    
    //CGColorRef color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;// self.theme.incompletedColor.CGColor;
    
    //0620
 //   CGColorRef shadowColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.5].CGColor;
    
 //   CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 3, shadowColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    
    //UIGraphicsBeginImageContextWithOptions(sencloudrarankView.bounds.size,NO,0.0);
    //[sencloudrarankView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *imagemiddle = [UIImage imageNamed:@"colorringbg0619.png"];
    //[imagemiddle drawAtPoint:CGPointMake(220, 220)];
    

}



double numbledegree(double degree)
{
    return ((degree * M_PI)/180.0f);
}

- (void)drawSlicesEgSlpFromto:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center fromsequencecount:(int)fromslicesnums tosequencecount:(int)toslicesnums egslpColor:(UIColor*)color
{
    //int i = 0;
    int outerDiameter = viewSize.width;
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
    
    double startAngle1 = numbledegree(fromslicesnums);
    double endAngle1 = numbledegree((toslicesnums));
    
    CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle1, endAngle1, 0);
    CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle1, startAngle1, 1);
    
    colortmp = color;
    CGContextSetFillColorWithColor(contextRef, colortmp.CGColor);
    CGContextFillPath(contextRef);  //屏蔽该项，可以只画线
    CGContextStrokePath(contextRef);
    

}
#pragma mark 画圆操作，透明
//在自动调用的函数中先画出边框，再重写该方法并调用就可以实现底框
- (void)drawSlicesRealtime:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center sequencecount:(int)slicesnums
{
    int outerDiameter = viewSize.width;
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
    
    
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    double startAngle1 = numbledegree(1*6);
    double endAngle1 = numbledegree(((60*6)+5));
    CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle1, endAngle1, 0);
    CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle1, startAngle1, 1);
    //CGContextSetFillColorWithColor(contextRef, [UIColor yellowColor].CGColor);
    colortmp = CircleColor;//环的颜色
  //  [UIColor colorWithRed: 131.0/255 green: 204.0/255 blue: 210.0/255 alpha: 1]
    //colortmp = [UIColor colorWithRed:131.0/255 green:204.0/255 blue:210.0/255 alpha:1];
    CGContextSetFillColorWithColor(contextRef, colortmp.CGColor);
    CGContextFillPath(contextRef);  //屏蔽该项，可以只画线
    CGContextStrokePath(contextRef);
    [self mydrawSlicesRealtime:contextRef withViewSize:viewSize andCenter:(CGPoint)center sequencecount:slicesnums];
}


//重写的方法，实现动态辐射圆环
- (void)mydrawSlicesRealtime:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center sequencecount:(int)slicesnums
{
    int i = 0;
    int outerDiameter = viewSize.width;
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
  
    for (i=0; i<slicesnums; i++) {
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);

        double startAngle1 = numbledegree(i*6);
        double endAngle1 = numbledegree(((i*6)+5));
        CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle1, endAngle1, 0);
        CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle1, startAngle1, 1);
        //CGContextSetFillColorWithColor(contextRef, [UIColor yellowColor].CGColor);
       colortmp = [arrColor objectAtIndex:i];
        CGContextSetFillColorWithColor(contextRef, colortmp.CGColor);
        CGContextFillPath(contextRef);  //屏蔽该项，可以只画线
        CGContextStrokePath(contextRef);

            }

}


- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center slicesnumarray:(int)slicesnumarray slicescolor:(UIColor*)color
{
	int outerDiameter = viewSize.width;
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
//	int sliceCount = self.progressTotal;
//	double sliceAngle = (2 * M_PI) / sliceCount;
	
//	CGContextSetLineWidth(contextRef, self.theme.sliceDividerThickness);
//	CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
//	CGContextMoveToPoint(contextRef, center.x, center.y);
    
    
        CGContextSetLineWidth(contextRef, self.theme.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, color.CGColor);
    	//CGContextSetStrokeColorWithColor(contextRef, [UIColor yellowColor].CGColor);
    	CGContextMoveToPoint(contextRef, center.x, center.y);
    
        // for (int i=0; i < slicesnum; i++) {
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        double startAngle1 = numbledegree(slicesnumarray);
        double endAngle1 = numbledegree((slicesnumarray+10));
        CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle1, endAngle1, 0);
        CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle1, startAngle1, 1);
        //CGContextSetFillColorWithColor(contextRef, [UIColor yellowColor].CGColor);
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        CGContextFillPath(contextRef);  //屏蔽该项，可以只画线
        CGContextStrokePath(contextRef);
    
        // }

	
//	for (int i = 0; i < sliceCount; i++) {
//		CGContextBeginPath(contextRef);
//		
//		double startAngle = sliceAngle * i - M_PI_2;
//		double endAngle = sliceAngle * (i + 1) - M_PI_2;
//
//		// Draw the outer slice arc clockwise.
//		CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
//		// Draw the inner slice arc in the opposite direction. The separator line is drawn automatically when moving
//		// from the point where the outer arc ended to the point where the inner arc starts.
//		CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
//		CGContextStrokePath(contextRef);
//	}
}

- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int innerDiameter = viewSize.width - self.theme.thickness;
    double innerRadius = innerDiameter / 2.0;
	
	CGContextSetLineWidth(contextRef, self.theme.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.theme.centerColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}

# pragma mark - Accessibility

- (UIAccessibilityTraits)accessibilityTraits
{
	return [super accessibilityTraits] | UIAccessibilityTraitUpdatesFrequently;
}

# pragma mark - Notifications

- (void)notifyProgressChange
{
	// Update the accessibilityValue and the progressSummaryView text.

    NSString *text;

    if (self.labelTextBlock) {
        text = self.labelTextBlock(self);
    } else {
        float percentageCompleted = (100.0f / self.progressTotal) * self.progressCounter;
        text = [NSString stringWithFormat:@"%.0f", percentageCompleted];
    }

	self.accessibilityValue = text;
	self.label.text = text;
	
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}

@end
