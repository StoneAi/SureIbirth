//
//  TableViewCell.h
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZHPickView.h"
@interface TableViewCell : UITableViewCell <ZHPickViewDelegate>
@property (strong,nonatomic) ZHPickView *pickview;
@property (strong,nonatomic) UILabel *titillabel;
@property (strong,nonatomic) UITextView *detailtextview;
@property (strong,nonatomic) UILabel *once;

@property (strong,nonatomic) NSString *IFname;

@end
