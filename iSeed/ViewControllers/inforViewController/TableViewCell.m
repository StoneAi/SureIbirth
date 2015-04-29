//
//  TableViewCell.m
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "TableViewCell.h"
#import "ZHPickView.h"
@implementation TableViewCell
{
    
  
    
    
}

@synthesize titillabel;
@synthesize detailtextview;
@synthesize once;

@synthesize IFname;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        }
    [self initCell];
   
    //pickerview数据源
   
   
    //[self initdatepicker];
    
    detailtextview.delegate = self;
    return self;
    
}



//初始化cell
-(void)initCell
{
    titillabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.center.y-5, 34, 21)];
    titillabel.textColor = [UIColor grayColor];
    
    once = [[UILabel alloc]initWithFrame:CGRectMake(290, 13, 20, 30)];
   // once = [[UILabel alloc]initWithFrame:CGRectMake(280, 13, 20, 30)];
    once.text = @"cm";
    once.textAlignment = NSTextAlignmentRight;
    once.textColor = [UIColor grayColor];
    once.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:once];
    
    
    detailtextview = [[UITextView alloc] initWithFrame:CGRectMake(150, 10, 135, 28)];
    detailtextview.textColor = [UIColor grayColor];
    detailtextview.textAlignment = NSTextAlignmentRight;
    detailtextview.font = [UIFont systemFontOfSize:15.0];
    //detailtextview.backgroundColor = [UIColor grayColor];
    [self addSubview:titillabel];
    [self addSubview:detailtextview];
    
    detailtextview.returnKeyType = UIReturnKeyDone;
    detailtextview.scrollEnabled = NO;
    detailtextview.editable = NO;
    
    
    


}




-(void)viewanimation:(UIView *)view willhidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, 600, 320, 260);
        }
        else
        {
            view.frame =CGRectMake(0, 340, 320, 260);
        }
    } completion:^(BOOL finished)
     {
         [view setHidden:hidden];
     }];

}


- (void)resignKeyboard {
    [self.detailtextview resignFirstResponder];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
