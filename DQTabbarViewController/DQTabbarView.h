//
//  DQTabbarView.h
//  Tide
//
//  Created by Alex on 15-3-20.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DQTabbarViewDelegate <NSObject>

@required
/*
 按钮响应事件
 @param:index           按钮的索引
 */
- (void)didSelectButtonAtIndex:(int)index;

/*
 点击弹出按钮
 @param:index           弹出按钮的索引
 */
- (void)didSelectPopupButtonAtIndex:(int)index;

@end


@interface DQTabbarView : UIView

@property (nonatomic, weak) id<DQTabbarViewDelegate> delegate;

/*
 初始化Tabbar
 @param:count Tabbar按钮数量(除去中间按钮)
 @param:popupCount 弹出按钮数量
 */
- (id)initWithButtonCount:(int)count withPopupButtonCount:(int)popupCount;

/*
 设置Tabbar按钮的背景图
 @param:imageName       背景图片名称，不带2x或3x
 @param:index           按钮的索引
 @param:state           按钮的状态，只填写UIControlStateNormal或UIControlStateSelected
 */
- (void)setButtonBackgroundImage:(NSString *)imageName atIndex:(int)index forState:(UIControlState)state;

/*
 设置中间按钮的背景图
 @param:imageName       背景图名称，不带2x或3x
 @param:state           按钮的状态，只填写UIControlStateNormal或UIControlStateSelected
 */
- (void)setCenterButtonBackgroundImage:(NSString *)imageName forState:(UIControlState)state;

/*
 设置弹出按钮的背景图
 @param:imageName       弹出按钮背景图片名称，不带2x或3x
 @param:index           弹出按钮的索引
 @param:state           弹出按钮的状态，只填写UIControlStateNormal或UIControlStateSelected
 */
- (void)setPopupButtonBackgroundImage:(NSString *)imageName atIndex:(int)index forState:(UIControlState)state;

/*
 设置Tabbar背景的透明度
 @param:alpha           透明度
 */
- (void)setBackgroundAlpha:(CGFloat)alpha;

/*
 设置Tabbar当前选中的按钮
 @param:index           选中button的index(除去中间按钮)
 */
- (void)setSelectButton:(int)index;

/*
 设置弹出按钮当前选中的按钮
 @param:index           选中弹出按钮的index
 */
- (void)setSelectPopupButton:(int)index;

/*
 设置未读消息条数
 @param:index           选中按钮的index(除去中间按钮)
 @param:unread          未读条数
 */
- (void)setUnreadCount:(int)unread AtIndex:(int)index;


@end
