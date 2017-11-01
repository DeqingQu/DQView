//
//  DQRefreshTableViewController.h
//  Tide
//
//  Created by Alex on 15-4-2.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#define STATS_AND_NAVI_HEIGHT       64

@protocol DQRefreshTableViewControllerDelegate <NSObject>

@required
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DQRefreshTableViewController : UIViewController

@property (nonatomic, weak) id<DQRefreshTableViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) EGORefreshTableFooterView *refreshFooterView;
@property (nonatomic, assign) BOOL allowLoadMore;
@property (nonatomic, assign) BOOL isReloading;            //  是否正在刷新

- (void)refreshView;

- (void)getMoreView;

- (void)finishReloadingData;

- (void)removeFooterView;

- (void)showRefreshHeader:(BOOL)animated;


@end
