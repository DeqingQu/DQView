//
//  DQImageZoomScrollView.m
//  MyImageBrowser
//
//  Created by Alex on 15-5-21.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQImageZoomScrollView.h"

@interface DQImageZoomScrollView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DQImageZoomScrollView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.maximumZoomScale = 3.5;
        self.minimumZoomScale = 1.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    
    [_imageView setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)setFrame:(CGRect)frame {
    
    _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
