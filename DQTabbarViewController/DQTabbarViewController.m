//
//  DQTabbarViewController.m
//  Tide
//
//  Created by Alex on 15-3-26.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQTabbarViewController.h"
#import "DQTabbarView.h"

@interface DQTabbarViewController () <DQTabbarViewDelegate>

//  Views
@property (nonatomic, strong) UIView *containerView;                        //  Container View
@property (nonatomic, strong) DQTabbarView *tabbarView;                     //  Tabbar View

//  Models
@property (nonatomic, strong) NSArray *viewControllers;                     //  ViewControllers
@property (nonatomic, strong) NSArray *popupViewControllers;                //  弹出按钮的ViewControllers
@property (nonatomic, strong) NSArray *images;                              //  Tabbar Images
@property (nonatomic, strong) NSArray *popupImages;                         //  弹出按钮的Images
@property (nonatomic, copy) NSString *centerImageName;                      //  中间按钮的图片名称

//  currentIndex和startIndex的范围在[0, [viewControllers count] + [popupViewControllers count]]之间，如果index < [viewControllers count]，表示对应的vc属于viewControllers，否则属于popupViewControllers
@property (nonatomic, assign) int currentIndex;                             //  Current VC Index
@property (nonatomic, assign) int startIndex;                               //  起始页面index

@end

@implementation DQTabbarViewController

- (id)initWithViewControllers:(NSArray *)controllers withTabbarImages:(NSArray *)images withCenterImage:(NSString *)centerImageName withPopupViewControllers:(NSArray *)popupControllers withPopupImages:(NSArray *)popupImages
{
    self = [super init];
    if (self) {
        
        _viewControllers = [[NSArray alloc] initWithArray:controllers];
        _images = [[NSArray alloc] initWithArray:images];
        _centerImageName = centerImageName;
        _popupViewControllers = [[NSArray alloc] initWithArray:popupControllers];
        _popupImages = [[NSArray alloc] initWithArray:popupImages];
        _startIndex = 4;
        _currentIndex = _startIndex;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ///////////////////////////////////////
    //  自定义状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    ///////////////////////////////////////
    //  ContainerView
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_containerView];
    
    ///////////////////////////////////////
    //  初始化ChildView
    [self initChildVC];
    
    ///////////////////////////////////////
    //  TabBar设置
    _tabbarView = [[DQTabbarView alloc] initWithButtonCount:(int)[_viewControllers count] withPopupButtonCount:(int)[_popupViewControllers count]];
    _tabbarView.center = CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height - 0.5*_tabbarView.frame.size.height);
    _tabbarView.delegate = self;
    [_tabbarView setBackgroundAlpha:1.0];
    if (_startIndex < [_viewControllers count]) {
        [_tabbarView setSelectButton:_startIndex];
    }
    else {
        [_tabbarView setSelectPopupButton:(int)(_startIndex - [_viewControllers count])];
    }
    
    //  设置tabbar图片
    for (int i=0; i<[_viewControllers count]; i++) {
        [_tabbarView setButtonBackgroundImage:[_images objectAtIndex:i*2] atIndex:i forState:UIControlStateNormal];
        [_tabbarView setButtonBackgroundImage:[_images objectAtIndex:i*2+1] atIndex:i forState:UIControlStateSelected];

    }
    //  设置Tabbar的中间按钮图片
    [_tabbarView setCenterButtonBackgroundImage:_centerImageName forState:UIControlStateNormal];
    //  设置Tabbar的弹出按钮图片
    for (int i=0; i<[_popupViewControllers count]; i++) {
        [_tabbarView setPopupButtonBackgroundImage:[_popupImages objectAtIndex:i*2] atIndex:i forState:UIControlStateNormal];
        [_tabbarView setPopupButtonBackgroundImage:[_popupImages objectAtIndex:i*2+1] atIndex:i forState:UIControlStateSelected];
    }

    //  Tabbar添加到ViewController上，不添加在DQTabbarViewController本身
    if (_startIndex < [_viewControllers count]) {
        UIViewController<DQTabbarViewControllerDelegate> *vc = [((UINavigationController *)[_viewControllers objectAtIndex:_startIndex]).viewControllers objectAtIndex:0];
        [vc.view addSubview:_tabbarView];
        
        if ([vc respondsToSelector:@selector(didSelectInTabbar)]) {
            [vc didSelectInTabbar];
        }
    }
    else {
        UIViewController<DQTabbarViewControllerDelegate> *vc = [((UINavigationController *)[_popupViewControllers objectAtIndex:(_startIndex - [_viewControllers count])]).viewControllers objectAtIndex:0];
        [vc.view addSubview:_tabbarView];
        
        if ([vc respondsToSelector:@selector(didSelectInTabbar)]) {
            [vc didSelectInTabbar];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Methods

#pragma mark Private Methods

- (void)initChildVC
{
    UIViewController *vc;
    if (_startIndex < [_viewControllers count]) {
        vc = [_viewControllers objectAtIndex:_startIndex];
    }
    else {
        vc = [_popupViewControllers objectAtIndex:(_startIndex - [_viewControllers count])];
    }
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [_containerView addSubview:vc.view];
}

#pragma mark DQTabbarViewDelegate

- (void)didSelectButtonAtIndex:(int)index
{
    if (index < 0 || index >= [_viewControllers count]) {
        return;
    }
    
    if (_currentIndex != index) {
        
        UIViewController *oldNaviVC;
        if (_currentIndex < [_viewControllers count]) {
            oldNaviVC = [_viewControllers objectAtIndex:_currentIndex];
        }
        else {
            oldNaviVC = [_popupViewControllers objectAtIndex:(_currentIndex - [_viewControllers count])];
        }
        UIViewController *newNaviVC = [_viewControllers objectAtIndex:index];
        
        //  添加ChildViewController
        [self addChildViewController:newNaviVC];
        [newNaviVC didMoveToParentViewController:self];
        
        //  切换TabbarView
        [_tabbarView removeFromSuperview];
        UIViewController<DQTabbarViewControllerDelegate> *newVC = [((UINavigationController *)newNaviVC).viewControllers objectAtIndex:0];
        [newVC.view addSubview:_tabbarView];
        
        //  切换VC
        [self transitionFromViewController:oldNaviVC toViewController:newNaviVC duration:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
        } completion:^(BOOL finished) {
            
            [oldNaviVC willMoveToParentViewController:nil];
            [oldNaviVC removeFromParentViewController];
            
            _currentIndex = index;
        }];
        
        
        if ([newVC respondsToSelector:@selector(didSelectInTabbar)]) {
            [newVC didSelectInTabbar];
        }
    }
}

- (void)didSelectPopupButtonAtIndex:(int)index
{
    if (index < 0 || index >= [_popupViewControllers count]) {
        return;
    }
    
    if (_currentIndex != index + [_viewControllers count]) {

        UIViewController *oldNaviVC;
        if (_currentIndex < [_viewControllers count]) {
            oldNaviVC = [_viewControllers objectAtIndex:_currentIndex];
        }
        else {
            oldNaviVC = [_popupViewControllers objectAtIndex:(_currentIndex - [_viewControllers count])];
        }

        UIViewController *newNaviVC = [_popupViewControllers objectAtIndex:index];
        
        //  添加ChildViewController
        [self addChildViewController:newNaviVC];
        [newNaviVC didMoveToParentViewController:self];
        
        //  切换TabbarView
        [_tabbarView removeFromSuperview];
        UIViewController<DQTabbarViewControllerDelegate> *newVC = [((UINavigationController *)newNaviVC).viewControllers objectAtIndex:0];
        [newVC.view addSubview:_tabbarView];
        
        //  切换VC
        [self transitionFromViewController:oldNaviVC toViewController:newNaviVC duration:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
        } completion:^(BOOL finished) {
            
            [oldNaviVC willMoveToParentViewController:nil];
            [oldNaviVC removeFromParentViewController];
            
            _currentIndex = index + (int)[_viewControllers count];
        }];
        
        
        if ([newVC respondsToSelector:@selector(didSelectInTabbar)]) {
            [newVC didSelectInTabbar];
        }
    }
}

#pragma mark Others

- (void)setUnreadCount:(int)unread AtIndex:(int)index {

    [_tabbarView setUnreadCount:unread AtIndex:index];
}

- (void)jumpToRootViewControllerAtIndex:(int)index {
    
    //  跳转到第index个页面
    [_tabbarView setSelectButton:index];
    [self didSelectButtonAtIndex:index];
    
    //  回到首级页面
    UIViewController *vc = [_viewControllers objectAtIndex:index];
    [((UINavigationController *)vc) popToRootViewControllerAnimated:YES];
}


@end
