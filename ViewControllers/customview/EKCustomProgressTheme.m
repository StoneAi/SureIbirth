//
//  EKCustomProgressTheme.m
//  EKCustomProgress
//
//  Created by elias kang on 07/10/2013.
//  Copyright (c) 2013 elias kang. All rights reserved.
//

#import "EKCustomProgressTheme.h"


// The font size is automatically adapted but this is the maximum it will get
// unless overridden by the user.
static const int kMaxFontSize = 64;


@implementation EKCustomProgressTheme

+ (id)themeWithName:(const NSString *)themeName
{
	return [[EKCustomProgressTheme alloc] init];
}

+ (id)standardTheme
{
	return [EKCustomProgressTheme themeWithName:STANDARD_THEME];
}

- (id)init
{
	self = [super init];
	if (self) {
		// View
		self.completedColor = [UIColor greenColor];
		self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		self.sliceDividerColor = [UIColor whiteColor];
		self.centerColor = [UIColor clearColor];
		self.thickness = 15;
		self.sliceDividerHidden = NO;  //add 0623
		self.sliceDividerThickness = 2;
		
		// Label
		self.labelColor = [UIColor blackColor];
		self.dropLabelShadow = YES;
		self.labelShadowColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
		self.labelShadowOffset = CGSizeMake(1, 1);
		self.font = [UIFont systemFontOfSize:kMaxFontSize];
	}
	
	return self;
}

@end
