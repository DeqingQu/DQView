//
//  DQTabbarViewController.h
//  Tide
//
//  Created by Alex on 15-3-26.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DQTabbarViewControllerDelegate <NSObject>

- (void)didSelectInTabbar;

@end

@interface DQTabbarViewController : UIViewController

/*
 @param: controllers        点击Tabbar按钮跳转ViewControllers的数组
 @param: images             ViewController对应的Tabbar上的图片，每个Tabbar需要两张不同状态的图片，按Tabbar顺序将图片塞入数组。
                            如 { @"tab1", @"tab1_pressed", @"tab2", @"tab2_pressed" }
 @param: centerImageName    Tabbar中间按钮的图片
 @param: popupControllers   点击弹出按钮的跳转ViewCtronllers的数组
 @param: popupImages        弹出按钮的图片
 */
- (id)initWithViewControllers:(NSArray *)controllers withTabbarImages:(NSArray *)images withCenterImage:(NSString *)centerImageName withPopupViewControllers:(NSArray *)popupControllers withPopupImages:(NSArray *)popupImages;


/*
 设置未读消息条数
 @param:index           选中item的index
 @param:unread          未读条数
 */
- (void)setUnreadCount:(int)unread AtIndex:(int)index;

/*
 跳转到第index个页面的root页面
 */
- (void)jumpToRootViewControllerAtIndex:(int)index;

@end
