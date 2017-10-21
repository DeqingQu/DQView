//
//  DQNaviDropdownView.m
//  NaviDropdownMenu
//
//  Created by Alex on 15/7/14.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQNaviDropdownView.h"

#import "DQNaviDropdownCell.h"

@interface DQNaviDropdownView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *dropdownView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation DQNaviDropdownView

- (id)initWithFrame:(CGRect)frame withDropdownArray:(NSArray *)array {

    self = [super initWithFrame:frame];
    if (self) {
        
        //  Models
        _titleArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        _isActive = NO;
        _selectedIndex = 0;
        
        //  UI
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _button.backgroundColor = [UIColor clearColor];
        [_button setTitleColor:WAVE_BLUE forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 7)];
        _arrowView.image = [UIImage imageNamed:@"arrow_down"];
        [self addSubview:_arrowView];
        
        [self updateButtonTitleWithIndex:_selectedIndex];
        
        float dropdownHeight = [array count] * DQNaviDropdownCellHeight + 5;
        if ([array count] > DQNaviDropdownMaxLines) {
            dropdownHeight = DQNaviDropdownMaxLines * DQNaviDropdownCellHeight + 5;
        }
        
        //  下拉菜单
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }

        _dropdownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _dropdownView.hidden = YES;
        [window addSubview:_dropdownView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0f - frame.size.width/2.0f, 64, frame.size.width, dropdownHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.layer.borderColor = [UIColor colorWithWhite:208.0f/255.0f alpha:1.0f].CGColor;
        _tableView.layer.borderWidth = 0.5f;
        [_dropdownView addSubview:_tableView];
        
        //  _dropdownView增加手势操作
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self;
        [_dropdownView addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)setDropdownArray:(NSArray *)array {
    
    [_titleArray removeAllObjects];
    [_titleArray addObjectsFromArray:array];
    
    float dropdownHeight = [array count] * DQNaviDropdownCellHeight + 5;
    if ([array count] > DQNaviDropdownMaxLines) {
        dropdownHeight = DQNaviDropdownMaxLines * DQNaviDropdownCellHeight + 5;
    }
    _tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.0f - self.frame.size.width/2.0f, 64, self.frame.size.width, dropdownHeight);

    [_tableView reloadData];
}

#pragma mark Private Methods

- (void)showDropdownView {
    
    _isActive = YES;
    [UIView animateWithDuration:0.2f animations:^{

        _dropdownView.hidden = NO;
        _arrowView.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
    }];
}

- (void)hideDropdownView {
    
    _isActive = NO;
    [UIView animateWithDuration:0.2f animations:^{
        
        _dropdownView.hidden = YES;
        _arrowView.transform = CGAffineTransformMakeRotation(360 *M_PI / 180.0);
    }];
    
}

- (void)updateButtonTitleWithIndex:(int)index {
 
    NSString *title = [_titleArray objectAtIndex:_selectedIndex];
    [_button setTitle:title forState:UIControlStateNormal];
    
    //  计算箭头的位置
    NSDictionary *attributes = @{NSFontAttributeName: _button.titleLabel.font};
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                      options: NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    _arrowView.center = CGPointMake(self.frame.size.width/2.0f + rect.size.width/2.0f + 8 + 5, self.frame.size.height/2.0f);
}

#pragma mark UIButton Actions

- (void)onButtonPressed {
    
    if (_isActive) {
        [self hideDropdownView];
    }
    else {
        [self showDropdownView];
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender {
    
    [self onButtonPressed];
}

#pragma mark UIGestureDelegate 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
 
    CGPoint touchPoint = [touch locationInView:_dropdownView];
    return !CGRectContainsPoint(_tableView.frame, touchPoint);
}

#pragma mark UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"DQNaviDropdownCell";
    DQNaviDropdownCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {

        cell = [[DQNaviDropdownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [cell setTitleText:[_titleArray objectAtIndex:indexPath.row]];
    [cell setTitleWidth:self.frame.size.width];
    
    if (indexPath.row == _selectedIndex) {
        [cell setCellBeenSelected:YES];
    }
    else {
        [cell setCellBeenSelected:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DQNaviDropdownCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedIndex = (int)(indexPath.row);
    for (int i=0; i<[_titleArray count]; i++) {
    
        DQNaviDropdownCell *cell = (DQNaviDropdownCell *)([tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]);
        if (i==_selectedIndex) {
            [cell setCellBeenSelected:YES];
        }
        else {
            [cell setCellBeenSelected:NO];
        }
    }
    
    [self updateButtonTitleWithIndex:_selectedIndex];
    [self onButtonPressed];
    
    if (_delegate) {
        [_delegate didClickedDropdownViewAtIndex:(int)(indexPath.row)];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DQNaviDropdownCell *cell = (DQNaviDropdownCell *)([tableView cellForRowAtIndexPath:indexPath]);
    [cell setCellBeenSelected:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DQNaviDropdownCell *cell = (DQNaviDropdownCell *)([tableView cellForRowAtIndexPath:indexPath]);
    [cell setCellBeenSelected:NO];
}

@end
