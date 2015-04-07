//
//  EKCustomProgressLabel.h
//  EKCustomProgress
//
//  Created by elias kang on 07/10/2013.
//  Copyright (c) 2013 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EKCustomProgressLabel;
@protocol EKCustomProgressLabelDelegate
@end

@class EKCustomProgressTheme;

@interface EKCustomProgressLabel : UILabel

- (id)initWithFrame:(CGRect)frame andTheme:(EKCustomProgressTheme *)theme;

// If adjustFontSizeToFitBounds is enabled, limit the size of the font to the bounds'width * pointSizeToWidthFactor.
@property (assign, nonatomic) CGFloat pointSizeToWidthFactor;

// Whether the algorithm to autoscale the font size is enabled or not.
@property (assign, nonatomic) BOOL adjustFontSizeToFitBounds;

@end
