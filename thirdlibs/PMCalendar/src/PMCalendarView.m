//
//  PMCalendarView.m
//  PMCalendarDemo
//
//  Created by Pavel Mazurin on 7/13/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMCalendarView.h"
#import "PMPeriod.h"
#import "PMCalendarConstants.h"
#import "NSDate+Helpers.h"
#import "PMSelectionView.h"

@interface PMDaysView : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) BOOL mondayFirstDayOfWeek;

@end

@interface PMCalendarView ()

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSTimer *longPressTimer;
@property (nonatomic, strong) NSTimer *panTimer;
@property (nonatomic, assign) CGPoint panPoint;
@property (nonatomic, strong) PMDaysView *daysView;
@property (nonatomic, strong) PMSelectionView *selectionView;
@property (nonatomic, strong) NSDate *currentDate; // month to show

- (NSInteger) indexForDate: (NSDate *)date;
- (NSDate *) dateForPoint: (CGPoint)point;

@end

@implementation PMCalendarView
{
    NSInteger currentMonth;
    NSInteger currentYear;
    CGRect leftArrowRect;
    CGRect rightArrowRect;
    NSInteger fontSize;
    NSUserDefaults *userDefaults;
}

@synthesize period = _period;
@synthesize allowedPeriod = _allowedPeriod;
@synthesize mondayFirstDayOfWeek = _mondayFirstDayOfWeek;
@synthesize currentDate = _currentDate;
@synthesize delegate = _delegate;
@synthesize font = _font;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize longPressTimer = _longPressTimer;
@synthesize panTimer = _panTimer;
@synthesize panPoint = _panPoint;
@synthesize daysView = _daysView;
@synthesize selectionView = _selectionView;
@synthesize allowsPeriodSelection = _allowsPeriodSelection;
@synthesize allowsLongPressYearChange = _allowsLongPressYearChange;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.backgroundColor = [UIColor clearColor];  //不能动
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mondayFirstDayOfWeek = NO;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandling:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];

    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandling:)];
    self.panGestureRecognizer.delegate = self;
   // [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.allowsLongPressYearChange = YES;

    self.selectionView = [[PMSelectionView alloc] initWithFrame:CGRectInset(self.bounds, -innerPadding.width, -innerPadding.height)];
    [self addSubview:self.selectionView];

    self.daysView = [[PMDaysView alloc] initWithFrame:self.bounds];
    [self addSubview:self.daysView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *dayTitles = [dateFormatter shortStandaloneWeekdaySymbols];
    NSArray *monthTitles = [dateFormatter standaloneMonthSymbols];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef shadow2 = [UIColor clearColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(1, 1);
    CGFloat shadow2BlurRadius = 1;

    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hDiff  = width / 7;
    CGFloat vDiff  = (height - headerHeight) / 7;
    UIFont *calendarFont = self.font;
    UIFont *monthFont = [UIFont fontWithName:@"Helvetica-Bold" size:calendarFont.pointSize];

    for (int i = 0; i < dayTitles.count; i++) 
    {
        NSInteger index = i + (_mondayFirstDayOfWeek?1:0);
        index = index % 7;
        //// dayHeader Drawing
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
        CGRect dayHeaderFrame = CGRectMake(floor(i * hDiff) - 1
                                           , headerHeight + (vDiff - self.font.pointSize) / 2 - shadow2Offset.height
                                           , hDiff
                                           , 30);
                    //修改后的    周几颜色
        [[UIColor blackColor] setFill];
        [((NSString *)[dayTitles objectAtIndex:index]) drawInRect: dayHeaderFrame 
                                                         withFont: calendarFont
                                                    lineBreakMode: UILineBreakModeWordWrap
                                                        alignment: NSTextAlignmentCenter];
        CGContextRestoreGState(context);
    }
    
    long month = currentMonth;
    long year = currentYear;
    
	NSString *monthTitle = [NSString stringWithFormat:@"%@ %ld", [monthTitles objectAtIndex:(month - 1)], year];
    //// Month Header Drawing
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    CGRect textFrame = CGRectMake(0
                                  , (headerHeight - [monthTitle sizeWithFont:monthFont].height) / 2
                                  , width
                                  , headerHeight);
            //修改后的   日期颜色
    [[UIColor blackColor] setFill];
    [monthTitle drawInRect: textFrame
                  withFont: monthFont
             lineBreakMode: UILineBreakModeWordWrap
                 alignment: NSTextAlignmentCenter];
    CGContextRestoreGState(context);
    
    //// backArrow Drawing
    UIBezierPath* backArrowPath = [UIBezierPath bezierPath];
    [backArrowPath moveToPoint: CGPointMake(hDiff / 2 - 6
                                            , headerHeight / 2)];
    [backArrowPath addLineToPoint: CGPointMake(6 + hDiff / 2 - 6
                                               , headerHeight / 2 + 4)];
    [backArrowPath addLineToPoint: CGPointMake( 6 + hDiff / 2 - 6
                                               ,  headerHeight / 2 - 4)];
    [backArrowPath addLineToPoint: CGPointMake( hDiff / 2 - 6
                                               ,  headerHeight / 2)];
    [backArrowPath closePath];
    [[UIColor blackColor] setFill];  //后退键的颜色
    [backArrowPath fill];
    leftArrowRect = CGRectInset(backArrowPath.bounds, -20, -20);

    //// forwardArrow Drawing
    UIBezierPath* forwardArrowPath = [UIBezierPath bezierPath];
    [forwardArrowPath moveToPoint: CGPointMake( width - hDiff / 2 + 6
                                               ,  headerHeight / 2)];
    [forwardArrowPath addLineToPoint: CGPointMake( -6 + width - hDiff / 2 + 6
                                                  , headerHeight / 2 + 4)];
    [forwardArrowPath addLineToPoint: CGPointMake(-6 + width - hDiff / 2 + 6
                                                   , headerHeight / 2 - 4)];
    [forwardArrowPath addLineToPoint: CGPointMake( width - hDiff / 2 + 6
                                                  , headerHeight / 2)];
    [forwardArrowPath closePath];
    [[UIColor blackColor] setFill]; //前进键的颜色
    [forwardArrowPath fill];
    rightArrowRect = CGRectInset(forwardArrowPath.bounds, -20, -20);
}

- (void) setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *eComponents = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit 
                                                 fromDate:_currentDate];
    
    BOOL needsRedraw = NO;
    
    if([eComponents month] != currentMonth) 
    {
        currentMonth = [eComponents month];
        needsRedraw = YES;
    }
    if([eComponents year] != currentYear) 
    {
        currentYear = [eComponents year];
        needsRedraw = YES;
    }
    
    if (needsRedraw)
    {
        self.daysView.currentDate = currentDate;
        [self setNeedsDisplay];
        [self periodUpdated];
        if ([_delegate respondsToSelector:@selector(currentDateChanged:)])
        {
            [_delegate currentDateChanged:currentDate];
        }
    }
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    if (_mondayFirstDayOfWeek != mondayFirstDayOfWeek)
    {
        _mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        self.daysView.mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        [self setNeedsDisplay];
        [self periodUpdated];
        
        // Ugh... TODO: make other components redraw in more acceptable way
        if ([_delegate respondsToSelector:@selector(currentDateChanged:)])
        {
            [_delegate currentDateChanged:_currentDate];
        }
    }
}

- (UIFont *) font
{
    NSInteger newFontSize = self.frame.size.width / 20;
    if (!_font || fontSize == 0 || fontSize != newFontSize)
    {
        _font = [UIFont fontWithName: @"Helvetica" size: newFontSize];
        self.daysView.font = _font;
        fontSize = newFontSize;
    }
    return _font;
}

- (void) periodUpdated
{
    NSInteger index = [self indexForDate:_period.startDate];
    NSInteger length = [_period lengthInDays];
    
    long numDaysInMonth      = [_currentDate numberOfDaysInMonth];
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;
    numDaysInMonth         += monthStartDay;
    int maxNumberOfCells    = ceil((CGFloat)numDaysInMonth / 7.0f) * 7 - 1;

    NSInteger endIndex = -1;
    NSInteger startIndex = -1;
    if (index <= maxNumberOfCells || index + length <= maxNumberOfCells)
    {
        endIndex = MIN( maxNumberOfCells, index + length );
        startIndex = MIN( maxNumberOfCells, index );
    }

    [self.selectionView setStartIndex:startIndex];
    [self.selectionView setEndIndex:endIndex];
    
}
- (void)setPeriod:(PMPeriod *)period
{
    if (![_period isEqual:period])
    {
        _period = period;
        
        if (!_currentDate)
        {
            self.currentDate = period.startDate;
        }
        
        if ([self.delegate respondsToSelector:@selector(periodChanged:)])
        {
            [self.delegate periodChanged:_period];
        }

        [self periodUpdated];
    }
}

#pragma mark - Touches handling -

- (NSInteger) indexForDate: (NSDate *)date
{
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;

    NSInteger daysSinceMonthStart = [date timeIntervalSinceDate:monthStartDate] / (60 * 60 *24);
    return daysSinceMonthStart + monthStartDay;
}

- (NSDate *) dateForPoint: (CGPoint)point
{
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hDiff  = width / 7;
    CGFloat vDiff  = (height - headerHeight) / 7;
    
    CGFloat yInCalendar = point.y - (headerHeight + vDiff);
    NSInteger row = yInCalendar / vDiff;
    
    long numDaysInMonth      = [_currentDate numberOfDaysInMonth];
    NSDate *monthStartDate  = [_currentDate monthStartDate];
    NSInteger monthStartDay = [monthStartDate weekday];
    monthStartDay           = (monthStartDay + (self.mondayFirstDayOfWeek?5:6)) % 7;
    numDaysInMonth         += monthStartDay;
    int maxNumberOfRows     = ceil((CGFloat)numDaysInMonth / 7.0f) - 1;
    
    row = MAX(0, MIN(row, maxNumberOfRows));
    
    CGFloat xInCalendar = point.x - 2;
    NSInteger col       = xInCalendar / hDiff;
    
    col = MAX(0, MIN(col, 6));
    
    NSInteger days = row * 7 + col - monthStartDay;
    NSDate *selectedDate = [monthStartDate dateByAddingDays:days];

    return selectedDate;
}

- (void) periodSelectionStarted: (CGPoint) point
{
    self.period = [PMPeriod oneDayPeriodWithDate:[self dateForPoint:point]];
}

- (void) periodSelectionChanged: (CGPoint) point
{
    NSDate *newDate = [self dateForPoint:point];
    
    if (_allowsPeriodSelection)
    {
        self.period = [PMPeriod periodWithStartDate:self.period.startDate 
                                            endDate:newDate];
    }
    else
    {
        self.period = [PMPeriod oneDayPeriodWithDate:newDate];
    }
}

- (void) panTimerCallback: (NSTimer *)timer
{
    NSNumber *increment = timer.userInfo;
    
    [self setCurrentDate:[self.currentDate dateByAddingMonths:[increment intValue]]];
    [self periodSelectionChanged:_panPoint];
}

- (void) panHandling: (UIGestureRecognizer *)recognizer
{
    CGPoint point  = [recognizer locationInView:self];
    
    CGFloat height = self.frame.size.height;
    CGFloat vDiff  = (height - headerHeight) / 7;
    
    if (point.y > headerHeight + vDiff) // select date in calendar
    {
        if (([recognizer state] == UIGestureRecognizerStateBegan) && (recognizer.numberOfTouches == 1)) 
        {
            [self periodSelectionStarted:point];
        }
        else if (([recognizer state] == UIGestureRecognizerStateChanged) && (recognizer.numberOfTouches == 1))
        {
            if ((point.x < 20) || (point.x > self.frame.size.width - 20))
            {
                self.panPoint = point;
                if (self.panTimer)
                {
                    return;
                }
                
                NSNumber *increment = [NSNumber numberWithInt:1];
                if (point.x < 20)
                {
                    increment = [NSNumber numberWithInt:-1];
                }
                
                self.panTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                 target:self 
                                                               selector:@selector(panTimerCallback:)
                                                               userInfo:increment
                                                                repeats:YES];
            }
            else
            {
                [self.panTimer invalidate];
                self.panTimer = nil;
            }
            
            [self periodSelectionChanged:point];
        }
    }
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) 
        || ([recognizer state] == UIGestureRecognizerStateCancelled)
        || ([recognizer state] == UIGestureRecognizerStateFailed))
    {
        [self.panTimer invalidate];
        self.panTimer = nil;
    }
}

- (void) tapHandling: (UIGestureRecognizer *)recognizer
{
    CGPoint point  = [recognizer locationInView:self];
    
    CGFloat height = self.frame.size.height;
    CGFloat vDiff  = (height - headerHeight) / 7;

    if (point.y > headerHeight + vDiff) // select date in calendar   不可选取的算法在这里添加
    {
        [self periodSelectionStarted:point];
        return;
    }
    
    if(CGRectContainsPoint(leftArrowRect, point)) 
    {
        //User tapped the prevMonth button
        [self setCurrentDate:[self.currentDate dateByAddingMonths:-1]];
    } 
    else if(CGRectContainsPoint(rightArrowRect, point)) 
    {
        //User tapped the nextMonth button
        [self setCurrentDate:[self.currentDate dateByAddingMonths:1]];
    }
}

- (void) longPressTimerCallback: (NSTimer *)timer
{
    NSNumber *increment = timer.userInfo;
    
    [self setCurrentDate:[self.currentDate dateByAddingYears:[increment intValue]]];
}

- (void) longPressHandling: (UIGestureRecognizer *)recognizer
{
    if (([recognizer state] == UIGestureRecognizerStateBegan) && (recognizer.numberOfTouches == 1)) 
    {
        if (self.longPressTimer)
        {
            return;
        }

        CGPoint point = [recognizer locationInView:self];
        CGFloat height = self.frame.size.height;
        CGFloat vDiff  = (height - headerHeight) / 7;
        
        if (point.y > headerHeight + vDiff) // select date in calendar
        {
            [self periodSelectionChanged:point];
            return;
        }

        NSNumber *increment = nil;
        if(CGRectContainsPoint(leftArrowRect, point)) 
        {
            //User tapped the prevMonth button
            increment = [NSNumber numberWithInt:-1];
        } 
        else if(CGRectContainsPoint(rightArrowRect, point)) 
        {
            //User tapped the nextMonth button
            increment = [NSNumber numberWithInt:1];
        }

        if (increment)
        {
            self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                   target:self
                                                                 selector:@selector(longPressTimerCallback:)
                                                                 userInfo:increment 
                                                                  repeats:YES];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.longPressTimer)
        {
            return;
        }

        CGPoint point = [recognizer locationInView:self];
        [self periodSelectionChanged:point];
    }
    else if (([recognizer state] == UIGestureRecognizerStateCancelled) 
             || ([recognizer state] == UIGestureRecognizerStateEnded) )
    {
        if (self.longPressTimer)
        {
            [self.longPressTimer invalidate];
            self.longPressTimer = nil;
        }
    }
}

- (void)setAllowsLongPressYearChange:(BOOL)allowsLongPressYearChange
{
    if (!allowsLongPressYearChange)
    {
        if (self.longPressGestureRecognizer)
        {
            [self removeGestureRecognizer:self.longPressGestureRecognizer];
            self.longPressGestureRecognizer = nil;
        }
    }
    else if (!self.longPressGestureRecognizer)
    {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(longPressHandling:)];
        self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
        self.longPressGestureRecognizer.delegate = self;
        self.longPressGestureRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

@end

@implementation PMDaysView

@synthesize font;
@synthesize currentDate = _currentDate;
@synthesize mondayFirstDayOfWeek = _mondayFirstDayOfWeek;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hDiff  = width / 7;
    CGFloat vDiff  = (height - headerHeight) / 7;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef shadow2 = [UIColor clearColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(1, 1);
    CGFloat shadow2BlurRadius = 1;

    void (^drawString)(NSString *, CGRect, UIColor *) = ^(NSString *string, CGRect rect, UIColor *color) {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
//        [UIColorMakeRGBA(arc4random()%255, arc4random()%255, arc4random()%255, 0.3) setFill];// \  Digits position
//        CGContextFillRect(context, rect);                                                    // /      debug
        [color setFill];
        [string drawInRect: rect 
                  withFont: self.font
             lineBreakMode: UILineBreakModeWordWrap
                 alignment: NSTextAlignmentCenter];
        CGContextRestoreGState(context);
    };
    
    // digits drawing
	NSDate *dateOnFirst = [_currentDate monthStartDate];
	int weekdayOfFirst = ([dateOnFirst weekday] + (_mondayFirstDayOfWeek?5:6)) % 7 + 1;
	long numDaysInMonth = [dateOnFirst numberOfDaysInMonth];
    
        //Find number of days in previous month
    NSDate *prevDateOnFirst = [[_currentDate dateByAddingMonths:-1] monthStartDate];
    long numDaysInPrevMonth = [prevDateOnFirst numberOfDaysInMonth];
    NSLog(@"dateOnFirst=%@,weekdayOfFirst = %d,numDaysInMonth = %ld,numDaysInPrevMonth = %ld",dateOnFirst,weekdayOfFirst,numDaysInMonth,numDaysInPrevMonth);

    
    //Draw the text for each of those days.
    for(int i = 0; i <= weekdayOfFirst-2; i++) {
        long day = numDaysInPrevMonth - weekdayOfFirst + 2 + i;
        
        NSString *string = [NSString stringWithFormat:@"%ld", day];
        CGRect dayHeader2Frame = CGRectMake(i * hDiff
                                            , headerHeight + vDiff + (vDiff - self.font.pointSize) / 2 - shadow2Offset.height
                                            , hDiff, self.font.pointSize);
        //不在本月日期的颜色
        UIColor *color = [UIColor colorWithWhite:0.6f alpha:1.0f];
        
        drawString( string, dayHeader2Frame, color );
    }
    
    NSDate *today = [[NSDate date] dateWithoutTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                   fromDate:today];
    
    NSInteger todayDay = [components day];
   
    NSDate *currentDateWithoutTime = [_currentDate dateWithoutTime];
    
    NSLog(@"today=%@",components);
     NSLog(@"todayDay=%ld",todayDay);
    NSLog(@"currentDateWithoutTime=%@",currentDateWithoutTime);
	int finalRow    = 0;
	int day         = 1;
    //0122 add
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSArray* filelist = [self obtainAllFilesName:[NSString stringWithFormat:@"%@/Documents/%@/RTDIR",NSHomeDirectory(),[usr objectForKey:USERDEFAULTS_USERNAME]]];
   
   
    
    
    NSLog(@"辐射文件数组为%@",filelist);
    
    
    
	for (int i = 0; i < 6; i++)
    {
		for(int j = 0; j < 7; j++) 
        {
			int dayNumber = i * 7 + j;
			
			if(dayNumber >= (weekdayOfFirst-1) && day <= numDaysInMonth) {
                NSString *string = [NSString stringWithFormat:@"%d", day];
                CGRect dayHeader2Frame = CGRectMake(floor(j * hDiff) - 1
                                                    , headerHeight + (i + 1) * vDiff + (vDiff - self.font.pointSize) / 2 - shadow2Offset.height
                                                    , hDiff, self.font.pointSize); 
                UIColor *color = nil;
               
                
                
                if((todayDay == day) && [today isEqualToDate:currentDateWithoutTime]) 
                {
                    //今日的颜色
                    color = [UIColor colorWithRed: 0.98 green: 0.24 blue: 0.09 alpha: 1];
                }
                
                //TODO else if{}
//                else if (dayNumber ==22)
//                {
//                    color = [UIColor greenColor];
//                }
                else
                {   //日期的颜色
                    color = [UIColor blackColor];
                }
                //0123 add
                for (id object in filelist) {
                    //NSLog(@"langArray=%@", object);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"yyyyMMdd"];
                    NSDate *destDate= [dateFormatter dateFromString:object];
                    NSInteger d =[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:destDate] day];
                    NSInteger m =[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:destDate] month];
                    NSInteger y = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:destDate] year];
                    
                    NSInteger lastm = [[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:dateOnFirst] month];
                    NSInteger lasty = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:dateOnFirst] year];
                    
                    //  NSLog(@"d = %ld,lm = %ld",m,lastm);
                    
                  //  NSLog(@"t = %ld",t);
                    if (weekdayOfFirst>=2) {
                        if (d+(weekdayOfFirst-2) == dayNumber&&m==lastm&&y==lasty) {//+(6-weekdayOfFirst)
                            color = [UIColor greenColor];
                        }
                    }
                    else if(weekdayOfFirst==1){
                    if (d-1 == dayNumber&&m==lastm&&y==lasty) {//-1
                        color = [UIColor greenColor];
                    }
                    }
                }

                
                drawString( string, dayHeader2Frame, color );
                
                finalRow = i;
                
				++day;
			}
		}
	}
    
    //Find number of days in previous month
    int weekdayOfNextFirst = (weekdayOfFirst - 1 + numDaysInMonth) % 7;
    
    if( weekdayOfNextFirst > 0 )
    {
        //Draw the text for each of those days.
        for ( int i = weekdayOfNextFirst; i < 7; i++ ) 
        {
            int day = i - weekdayOfNextFirst + 1;
            NSString *string = [NSString stringWithFormat:@"%d", day];
            CGRect dayHeader2Frame = CGRectMake(floor(i * hDiff) - 1
                                                , headerHeight + (finalRow + 1) * vDiff + (vDiff - self.font.pointSize) / 2 - shadow2Offset.height
                                                , hDiff, self.font.pointSize);
            //mark
            UIColor *color = [UIColor colorWithWhite:0.6f alpha:1.0f];
            drawString( string, dayHeader2Frame, color );
        }
    }
}
//0122 add
-(NSArray *)obtainAllFilesName:(NSString *)directoryString
{
    
    NSFileManager *temFM = [NSFileManager defaultManager];//创建文件管理器
    
    if (directoryString)
        
    {
        
        NSArray *temFilesArray = [temFM subpathsAtPath:directoryString];//获取该目录下的所有文件名
        
        return temFilesArray;
        
    }
    else
        return nil;
}



- (void) setCurrentDate:(NSDate *)currentDate
{
    if (![_currentDate isEqualToDate:currentDate])
    {
        _currentDate = currentDate;
        [self setNeedsDisplay];
    }
}

- (void)setMondayFirstDayOfWeek:(BOOL)mondayFirstDayOfWeek
{
    if (_mondayFirstDayOfWeek != mondayFirstDayOfWeek)
    {
        _mondayFirstDayOfWeek = mondayFirstDayOfWeek;
        [self setNeedsDisplay];
    }
}

@end
