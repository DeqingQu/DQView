//
//  DQImageBrowserViewController.m
//  Tide
//
//  Created by Alex on 15-5-4.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQImageBrowserViewController.h"
#import "DQImageZoomScrollView.h"

#import "UIImageView+WebCache.h"
#import "RMDownloadIndicator.h"

@interface DQImageBrowserViewController () <UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, assign) float originOffsetX;

@end

@implementation DQImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _originOffsetX = 0;
    
    //  _mainView容器
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mainView.backgroundColor = [UIColor blackColor];
    _mainView.contentSize = CGSizeMake(self.view.bounds.size.width * [_imageUrls count], self.view.bounds.size.height);
    _mainView.pagingEnabled = YES;
    _mainView.delegate = self;
    _mainView.maximumZoomScale = 3.0f;
    _mainView.minimumZoomScale = 1.0f;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mainView];
    
    //  pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 20, self.view.bounds.size.width, 10)];
    _pageControl.numberOfPages = [_imageUrls count];
    [self.view addSubview:_pageControl];
    
    //  容器增加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [_mainView addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
    [_mainView addGestureRecognizer:longpressGesture];
    
    //  向容器中增加ImageView
    _imageViews  = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<[_imageUrls count]; i++) {
        
        NSString *imageUrl = [_imageUrls objectAtIndex:i];
        DQImageZoomScrollView *imageView = [[DQImageZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, _mainView.bounds.size.width, _mainView.bounds.size.height)];
        [_imageViews addObject:imageView];
        
        RMDownloadIndicator *mixedIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake(0, 0, 40, 40) type:kRMMixedIndictor];
        [mixedIndicator setBackgroundColor:[UIColor clearColor]];
        [mixedIndicator setFillColor:[UIColor whiteColor]];
        [mixedIndicator setStrokeColor:[UIColor whiteColor]];
        [mixedIndicator setClosedIndicatorBackgroundStrokeColor:[UIColor whiteColor]];
        mixedIndicator.radiusPercent = 0.45;
        [_mainView addSubview:mixedIndicator];
        [mixedIndicator loadIndicator];

        __weak DQImageZoomScrollView *wImageView = imageView;
        __weak RMDownloadIndicator *wmixedIndicator = mixedIndicator;
        wImageView.center = CGPointMake(_mainView.bounds.size.width * (i+0.5), _mainView.bounds.size.height * 0.5);
        wmixedIndicator.center = wImageView.center;
        
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            
            [wmixedIndicator updateWithTotalBytes:expectedSize downloadedBytes:receivedSize];
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

            wmixedIndicator.hidden = YES;
            
            float imageRatio = image.size.width/ image.size.height;
            float screenRatio = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
            //  图片更宽
            if (imageRatio >= screenRatio) {
                
                float width = _mainView.bounds.size.width;
                float height = width / imageRatio;
                wImageView.frame = CGRectMake(0, 0, width, height);
            }
            //  图片更高
            else {
                float height = _mainView.bounds.size.height;
                float width = height * imageRatio;
                wImageView.frame = CGRectMake(0, 0, width, height);
            }
            wImageView.center = CGPointMake(_mainView.bounds.size.width * (i+0.5), _mainView.bounds.size.height * 0.5);
            
        }];
        [_mainView addSubview:imageView];
    }
    
    //  设置初始图片
    _mainView.contentOffset = CGPointMake(_mainView.bounds.size.width * _startIndex, 0);
    _pageControl.currentPage = _startIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIGesture Methods

- (void)onTapped:(UITapGestureRecognizer *)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press start.");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"保存图片", @""), nil];
        [sheet showInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
    }
    else {
        NSLog(@"Long press detected.");
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"index = %ld", buttonIndex);
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float page = scrollView.contentOffset.x/self.view.bounds.size.width;
    
    if (page >= _pageControl.currentPage + 0.5) {
        
        int pageMinus = (int)(_pageControl.currentPage);
        
        DQImageZoomScrollView *zoomMinusView = [_imageViews objectAtIndex:pageMinus];
        [zoomMinusView setZoomScale:1.0f];
        
        _pageControl.currentPage++;
    }
    
    if (page < _pageControl.currentPage - 0.5) {
        
        int pagePlus = (int)(_pageControl.currentPage);

        DQImageZoomScrollView *zoomPlusView = [_imageViews objectAtIndex:pagePlus];
        [zoomPlusView setZoomScale:1.0f];
        
        _pageControl.currentPage--;
    }
}

@end
