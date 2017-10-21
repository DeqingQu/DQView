//
//  DQImageBrowserViewController.h
//  Tide
//
//  Created by Alex on 15-5-4.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQImageBrowserViewController : UIViewController

//  设置图片的URL数组
@property (nonatomic, strong) NSMutableArray *imageUrls;

//  设置起始图片的index
@property (nonatomic, assign) int startIndex;

@end
