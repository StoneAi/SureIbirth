//
//  ZhuView.h
//  PointView
//
//  Created by Chan Bill on 15/4/28.
//  Copyright (c) 2015年 Viposes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PNplot;
@interface ZhuView : UIView
@property (nonatomic, readonly, strong) NSMutableArray *plots;
@property (assign, nonatomic) int ymin; //Y轴的最小值
@property (assign, nonatomic) int ymax; //Y轴的最大值
@property (assign, nonatomic) int xCount; //X轴的24小时以多少个为间隔
@property (assign, nonatomic) int yCount; //Y轴显示多少个数据
@property (assign, nonatomic) float labelfont;
- (void)addPlot:(PNplot *)newPlot;
-(void)clearPlot;
@end
