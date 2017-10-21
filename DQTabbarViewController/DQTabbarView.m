//
//  DQTabbarView.m
//  Tide
//
//  Created by Alex on 15-3-20.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQTabbarView.h"
#import "M13BadgeView.h"

#define DQ_TABBAR_BUTTON_TAG        1000
#define DQ_TABBAR_POPUP_BUTTON_TAG  2000

static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 90;
static const float kSphereDamping = 0.3;

@interface DQTabbarView ()

@property (nonatomic, assign) int buttonCount;
@property (nonatomic, assign) int popupButtonCount;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *badgeArray;
@property (nonatomic, strong) NSMutableArray *popupButtonArray;
@property (nonatomic, strong) NSMutableArray *popupButtonPositions;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *centerButton;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat sphereDamping;
@property (nonatomic, assign) CGFloat sphereLength;

// animator and behaviors
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSMutableArray *snaps;

@property (nonatomic, assign) BOOL expanded;

@property (nonatomic, strong) UIView *blackBackview;
@property (nonatomic, assign) BOOL firstClickCenterButton;

@end

@implementation DQTabbarView

#pragma mark Public Methods

- (id)initWithButtonCount:(int)count withPopupButtonCount:(int)popupCount
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, rect.size.width, TABBAR_HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        
        _buttonCount = count;
        _popupButtonCount = popupCount;
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:count];
        _badgeArray = [[NSMutableArray alloc] initWithCapacity:count];
        _popupButtonArray = [[NSMutableArray alloc] initWithCapacity:popupCount];
        _popupButtonPositions = [[NSMutableArray alloc] initWithCapacity:popupCount];
        _snaps = [[NSMutableArray alloc] initWithCapacity:popupCount];
        
        _angle = kAngleOffset;
        _sphereLength = kSphereLength;
        _sphereDamping = kSphereDamping;
        
        _firstClickCenterButton = YES;
        
        [self layoutView];
    }
    return self;
}

- (void)setButtonBackgroundImage:(NSString *)imageName atIndex:(int)index forState:(UIControlState)state
{
    if (index >= _buttonCount) {
        return;
    }
    
    UIButton *button = [_buttonArray objectAtIndex:index];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:state];
}

- (void)setCenterButtonBackgroundImage:(NSString *)imageName forState:(UIControlState)state
{
    [_centerButton setBackgroundImage:[UIImage imageNamed:imageName] forState:state];
}

- (void)setPopupButtonBackgroundImage:(NSString *)imageName atIndex:(int)index forState:(UIControlState)state
{
    if (index >= _popupButtonCount) {
        return;
    }
    
    UIButton *button = [_popupButtonArray objectAtIndex:index];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:state];
}

- (void)setBackgroundAlpha:(CGFloat)alpha
{
    _backgroundView.alpha = alpha;
}

- (void)setSelectButton:(int)index
{
    for (int i=0; i<_buttonCount; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        if (i == index) {
            button.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }
    
    //  弹出按钮全部置为selected=NO
    for (int i=0; i<_popupButtonCount; i++) {
        UIButton *button = [_popupButtonArray objectAtIndex:i];
        button.selected = NO;
    }
}

- (void)setSelectPopupButton:(int)index
{
    for (int i=0; i<_popupButtonCount; i++) {
        UIButton *button = [_popupButtonArray objectAtIndex:i];
        if (i == index) {
            button.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }
    
    //  Tabbar按钮全部置为selected=NO
    for (int i=0; i<_buttonCount; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        button.selected = NO;
    }
}


- (void)setUnreadCount:(int)unread AtIndex:(int)index {
    
    M13BadgeView *badge = [_badgeArray objectAtIndex:index];
    
    if(unread < 100) {
        badge.hidden = NO;
        [badge setText:[NSString stringWithFormat:@"%d", unread]];
    }
    else {
        badge.hidden = NO;
        [badge setText:@"99+"];
    }
    
    UIButton *button = [_buttonArray objectAtIndex:index];
    
    //    NSLog(@"button.bounds = (%f, %f)", button.bounds.size.width, button.bounds.size.height);
    badge.frame = CGRectMake(button.bounds.size.width * 0.55, button.bounds.size.height * 0.07, badge.bounds.size.width, badge.bounds.size.height);
    
    //    badge.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -badge.bounds.size.width - 20, 48-badge.bounds.size.height/2, badge.bounds.size.width, badge.bounds.size.height);
}


#pragma mark Private Methods

- (void)layoutView
{
    self.backgroundColor = [UIColor clearColor];
    
    ///////////////////////////////////////
    //  背景
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backgroundView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithWhite:248.0f/255.0f alpha:1.0f];
    [self addSubview:_backgroundView];
    
    //  黑色蒙版背景
    _blackBackview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height-self.frame.size.height)];
    _blackBackview.backgroundColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBlackViewTapped)];
    [_blackBackview addGestureRecognizer:tap];
    
    ///////////////////////////////////////
    //  三条顶部分隔栏
    UIView *segView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    segView1.backgroundColor = [UIColor colorWithWhite:211.0f/255.0f alpha:1.0f];
    [_backgroundView addSubview:segView1];
    
//    UIView *segView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, 1)];
//    segView2.backgroundColor = [UIColor colorWithWhite:222.0f/255.0f alpha:1.0f];
//    [_backgroundView addSubview:segView2];
//    
//    UIView *segView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, 1)];
//    segView3.backgroundColor = [UIColor whiteColor];
//    [_backgroundView addSubview:segView3];
    
    ///////////////////////////////////////
    //  按钮
    for (int i=0; i<_buttonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int positionIndex = i;
        if (i>=_buttonCount/2) {
            positionIndex++;
        }
        button.frame = CGRectMake(self.frame.size.width*positionIndex/(_buttonCount+1), 0, 320.0f/(_buttonCount+1), self.frame.size.height);
        button.center = CGPointMake(self.frame.size.width*(positionIndex*2+1)/((_buttonCount+1)*2), self.frame.size.height/2);
        button.tag = i+DQ_TABBAR_BUTTON_TAG;
        [button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
        button.selected = NO;
        
        [self addSubview:button];
        
        [_buttonArray addObject:button];
        
        //  初始小红点
        M13BadgeView *badge = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
        badge.font = [UIFont systemFontOfSize:13.0f];
        badge.hidesWhenZero = YES;
        [button addSubview:badge];
        [_badgeArray addObject:badge];
        
        [self setUnreadCount:0 AtIndex:i];
    }
    
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerButton.frame = CGRectMake(self.frame.size.width/2 - 320.0f/(_buttonCount+1)/2, 0, 320.0f/(_buttonCount+1), self.frame.size.height);
    [_centerButton addTarget:self action:@selector(onCenterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_centerButton];
    
    for (int i=0; i<_popupButtonCount; i++) {
        UIButton *popupButton = [UIButton buttonWithType: UIButtonTypeCustom];
        popupButton.frame = CGRectMake(0, 0, 50, 50);
        popupButton.center = _centerButton.center;
        popupButton.tag = i + DQ_TABBAR_POPUP_BUTTON_TAG;
        [popupButton addTarget:self action:@selector(onPopupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        popupButton.selected = NO;
        
        [_popupButtonArray addObject:popupButton];
    }
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    for (int i = 0; i < _popupButtonCount; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_popupButtonArray[i] snapToPoint:self.center];
        snap.damping = self.sphereDamping;
        [self.snaps addObject:snap];
    }
    
    //  centerButton移到顶层
    [self bringSubviewToFront:_centerButton];
}

- (CGPoint)centerForSphereAtIndex:(int)index
{
    NSLog(@"tabbar center (%f, %f)", self.center.x, self.center.y);
    
    CGFloat firstAngle = M_PI + (M_PI_2 - self.angle) + index * self.angle;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(firstAngle) * self.sphereLength;
    CGFloat y = startPoint.y + sin(firstAngle) * self.sphereLength;
    CGPoint position = CGPointMake(x, y);
    return position;
}

- (void)expandSubmenu
{
    
    [self.superview addSubview:_blackBackview];

    //  按钮弹出动画
    for (int i = 0; i < _popupButtonCount; i++) {
        [self snapToPostionsWithIndex:i];
    }
    
    //  背景渐变和中间按钮旋转的动画
    [UIView animateWithDuration:0.3 animations:^{
        
        _blackBackview.alpha = 0.5f;
        
        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/4);
        [_centerButton setTransform:at];
        
    } completion:^(BOOL finished) {
        
    }];
    
    self.expanded = YES;
}

- (void)shrinkSubmenu
{
    //  按钮收起动画
    for (int i = 0; i < _popupButtonCount; i++) {
        [self snapToStartWithIndex:i];
    }
    
    //  背景渐变和中间按钮旋转的动画
    [UIView animateWithDuration:0.3 animations:^{
        
        _blackBackview.alpha = 0.0f;
        
        CGAffineTransform at =CGAffineTransformMakeRotation(0);
        [_centerButton setTransform:at];
        
    } completion:^(BOOL finished) {
        
        [_blackBackview removeFromSuperview];
    }];
    
    [self.superview bringSubviewToFront:self];
    
    self.expanded = NO;
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    //  将popupButton置为center的代码不使用animator，使用animator会和removeFromSuperview有冲突
    
    UIButton *button = _popupButtonArray[index];
    
    [UIView animateWithDuration:0.4 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        button.center = self.center;
        
    } completion:^(BOOL finished) {

        [button removeFromSuperview];
    }];
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    UIButton *button = _popupButtonArray[index];
    button.center = self.center;
    [self.superview addSubview:button];
    [self.superview bringSubviewToFront:self];
    
    id positionValue = _popupButtonPositions[index];
    CGPoint position = [positionValue CGPointValue];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_popupButtonArray[index] snapToPoint:position];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

#pragma mark UIButton Actions

- (void)onButtonPressed:(UIButton *)button
{
    int selectIndex = (int)(button.tag) - DQ_TABBAR_BUTTON_TAG;
    [self setSelectButton:selectIndex];
    
    if (_expanded) {
        [self shrinkSubmenu];
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
        [_delegate didSelectButtonAtIndex:selectIndex];
    }
}

- (void)onCenterButtonPressed:(UIButton *)button
{
    [self removeSnapBehaviors];
    
    _blackBackview.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height-self.frame.size.height);
    
    //  延迟计算popupButton的位置
    if (_firstClickCenterButton) {
        
        for (int i=0; i<_popupButtonCount; i++) {
            
            CGPoint position = [self centerForSphereAtIndex:i];
            [self.popupButtonPositions addObject:[NSValue valueWithCGPoint:position]];
        }
        _firstClickCenterButton = NO;
    }
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
}

- (void)onPopupButtonPressed:(UIButton *)button
{
    int selectIndex = (int)(button.tag) - DQ_TABBAR_POPUP_BUTTON_TAG;
    [self setSelectPopupButton:selectIndex];
    
    [self shrinkSubmenu];
    
    if ([_delegate respondsToSelector:@selector(didSelectPopupButtonAtIndex:)]) {
        [_delegate didSelectPopupButtonAtIndex:selectIndex];
    }
    
}

- (void)onBlackViewTapped
{
    [self removeSnapBehaviors];

    [self shrinkSubmenu];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
