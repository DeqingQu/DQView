//
//  ViewController.m
//  DQViewDemo
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ViewController.h"
#import "DQNaviDropdownView.h"
#import "NewViewController.h"

#define WAVE_BLUE   [UIColor colorWithRed:133.0f/255.0f green:191.0f/255.0f blue:242.0f/255.0f alpha:1.0f]


@interface ViewController () <DQNaviDropdownViewDelegate, DQRefreshTableViewControllerDelegate>

@property (nonatomic, strong) DQNaviDropdownView *naviView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *createrArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //  delegate and other setup
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
//    self.allowLoadMore = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:237.0f/255.0f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:237.0f/255.0f alpha:1.0f];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //  Model Init
    _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_titleArray addObject:@"All Groups"];
    [_titleArray addObject:@"My"];
    [_titleArray addObject:@"Friends"];
    
    _membersArray = [[NSMutableArray alloc] initWithCapacity:0];
    _createrArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //  View Init
    //  customize nav bar
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:WAVE_BLUE];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:WAVE_BLUE forKey:NSForegroundColorAttributeName]];
    
    _naviView = [[DQNaviDropdownView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.bounds.size.height)withDropdownArray:_titleArray];
    _naviView.delegate = self;
    self.navigationItem.titleView = _naviView;

    [self refreshView];
    
    [self reloadTable];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self finishReloadingData];
}

#pragma mark DQNaviDropdownViewDelegate

- (void)didClickedDropdownViewAtIndex:(NSInteger)index {
    
    NSLog(@"This is index %ld", index);
    
    [self refreshView];

    [self showRefreshHeader:YES];
    [self reloadTable];
}

#pragma mark DQRefreshTableViewControllerDelegate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_membersArray count] == 0) {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_createrArray count];
    }
    else {
        return [_membersArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    titleLabel.textColor = [UIColor colorWithWhite:140.0f/255.0f alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    if (section == 0) {
        titleLabel.text = @"Creator";
    }
    else {
        titleLabel.text = @"Member";
    }
    [customView addSubview:titleLabel];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UserInfoTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *numberToShow = @"";
    if (indexPath.section == 0) {
        numberToShow = [_createrArray objectAtIndex:indexPath.row];
    }
    else {
        numberToShow = [_membersArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = numberToShow;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_membersArray count] == 0 && [_createrArray count] == 0) {
        return;
    }
    
    NSString *numberToShow = @"";
    
    if (indexPath.section == 0) {
        numberToShow = [_createrArray objectAtIndex:indexPath.row];
    }
    else {
        numberToShow = [_membersArray objectAtIndex:indexPath.row];
    }
    
    NSLog(@"Show line: %@", numberToShow);
    
    NewViewController *vc = [[NewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}


//  保证section的header不跟随滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 30; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


#pragma Private Methods
- (void)refreshView
{
    [_createrArray removeAllObjects];
    [_membersArray removeAllObjects];
    
    [_createrArray addObject:@"Creator"];
    for (NSInteger i=0; i<10; i++) {
        [_membersArray addObject:[NSString stringWithFormat:@"Member No%ld", i+1]];
    }
    
    [self reloadTable];
}

- (void)getMoreView {
    
    [super getMoreView];
 
    [_createrArray addObject:@"Creator"];
    for (NSInteger i=0; i<2; i++) {
        [_membersArray addObject:[NSString stringWithFormat:@"Member No%ld", i+10]];
    }
    
    [self reloadTable];
}

- (void)reloadTable {
    [self.tableView reloadData];
    [self finishReloadingData];
}
@end

