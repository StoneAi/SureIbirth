//
// EKCustomProgressView.h
// EKCustomProgress
//
//
// Copyright (c) 2013 elias kang. All rights reserved.

#import <UIKit/UIKit.h>
#import "Config.h"
@class EKCustomProgressView;
@protocol EKCustomProgressViewDelegate<NSObject>
@end


static NSString *keyThickness = @"theme.thickness";


@class EKCustomProgressTheme;
@class EKCustomProgressLabel;


@interface EKCustomProgressView : UIView //UIControl //UIView
//add 0723
//@property (nonatomic, strong) UIView *container;
//@property int numberOfSections;
//@property CGAffineTransform startTransform;
//@property int currentValue;
//- (id) initWithFrame:(CGRect)frame withSections:(int)sectionsNumber;

- (id)initWithFrame:(CGRect)frame andTheme:(EKCustomProgressTheme *)theme;

@property(strong, nonatomic)NSArray *raarray;
@property(strong, nonatomic)NSArray *raarraygroup;
@property(assign, nonatomic)int raarraynum;

//add 0626
@property (assign, nonatomic) BOOL egslpShow;
@property (assign, nonatomic) BOOL rtShow;
@property(strong, nonatomic)NSArray *engstrengtharray;

//add 0623
@property (assign, nonatomic) int fixedringColornums;

//add 0619
@property (assign, nonatomic) BOOL realtimeShow;
@property (assign, nonatomic) NSUInteger colorringCounternums;


// The total number of steps in the progress view.
@property (assign, nonatomic) NSUInteger progressTotal;

// The number of steps currently completed.
@property (assign, nonatomic) NSUInteger progressCounter;

// Whether the progress is drawn clockwise (YES) or anticlockwise (NO)
@property (assign, nonatomic) BOOL clockwise;

// The index of the slice where the first completed step is.
@property (assign, nonatomic) NSUInteger startingSlice;

// The theme currently used
@property (strong, nonatomic) EKCustomProgressTheme *theme;

// The label shown in the view's center.
@property (strong, nonatomic) EKCustomProgressLabel *label;

// The block that is used to update the label text when the progress changes.
@property (nonatomic, copy) NSString *(^labelTextBlock)(EKCustomProgressView *progressView);


//add 0731
-(void)setfixedRingone:(int)fixedringColornums;

//add 0623
- (void)setfixedringColornums:(int)fixedringColornums secondringnums:(int)fixedringtwo threeringnums:(int)fixedringthree;
//add 0626
-(void)setProgressSlice:(NSArray *)array;

@end
