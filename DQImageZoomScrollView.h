//
//  DQImageZoomScrollView.h
//  MyImageBrowser
//
//  Created by Alex on 15-5-21.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface DQImageZoomScrollView : UIScrollView <UIScrollViewDelegate>

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;


@end
