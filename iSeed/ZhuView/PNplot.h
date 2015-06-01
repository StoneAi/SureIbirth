//
//  PNplot.h
//  PointView
//
//  Created by Chan Bill on 15/4/28.
//  Copyright (c) 2015年 Viposes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PNplot : NSObject
@property (nonatomic, strong) NSArray *plottingValues;  //数据
@property (nonatomic, strong) UIColor *linesColor;         //圆柱颜色
@property (nonatomic, strong) UIColor *AxisColor;          //坐标轴颜色
@property (nonatomic, assign) float lineWidth;              //圆柱宽度
@end
