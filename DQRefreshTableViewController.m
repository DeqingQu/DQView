//
//  DQRefreshTableViewController.m
//  Tide
//
//  Created by Alex on 15-4-2.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQRefreshTableViewController.h"

@interface DQRefreshTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EGORefreshTableDelegate>

@end

@implementation DQRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isReloading = YES;

    ///////////////////////////////////////
    //  列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATS_AND_NAVI_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-STATS_AND_NAVI_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    //  下拉刷新
    [self createRefreshHeaderView];
    
    [self showRefreshHeader:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    
    //  should be calling your tableviews data source model to reload
    _isReloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getMoreView) withObject:nil afterDelay:0.0];
    }
    
    // overide, the actual loading data operation is done in the subclass
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _isReloading; // should return if data source model is reloading
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_delegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_delegate tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_delegate tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [_delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
//        return[_delegate tableView:tableView canEditRowAtIndexPath:indexPath];
//    }
    return NO;
}

#pragma mark Private Methods

-(void)createRefreshHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.frame.size.height,
                                     self.view.frame.size.width, self.view.frame.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         _tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

-(void)showRefreshHeader:(BOOL)animated{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        _tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [_tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        _tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [_tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _isReloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    if (_allowLoadMore) {
        if (_refreshFooterView) {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        }
        [self setFooterView];
    }


    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)refreshView
{
    
    
}

//加载调用的方法
-(void)getMoreView
{
    [self removeFooterView];
}

@end
