//
//  DQNaviDropdownView.h
//  NaviDropdownMenu
//
//  Created by Alex on 15/7/14.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DQNaviDropdownViewDelegate <NSObject>

@required
- (void)didClickedDropdownViewAtIndex:(NSInteger)index;

@end

@interface DQNaviDropdownView : UIView

@property (nonatomic, weak) id<DQNaviDropdownViewDelegate> delegate;

/*
 *  @param: frame
 *  @param: array   下拉菜单的标题
 */
- (id)initWithFrame:(CGRect)frame withDropdownArray:(NSArray *)array;

/*
 *  @param: array   下拉菜单的标题
 */
- (void)setDropdownArray:(NSArray *)array;

@end
