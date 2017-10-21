//
//  DQNaviDropdownCell.h
//  NaviDropdownMenu
//
//  Created by Alex on 15/7/14.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DQNaviDropdownMaxLines      5
#define DQNaviDropdownCellHeight    40

@interface DQNaviDropdownCell : UITableViewCell

/*
 *  设置textLabel的文字
 */
- (void)setTitleText:(NSString *)title;

/*
 *  设置textLabel的宽度
 */
- (void)setTitleWidth:(CGFloat)width;


/*
 *  设置cell为选中状态
 */
- (void)setCellBeenSelected:(BOOL)selected;

@end
