//
//  DQImageEditView.h
//  Tide
//
//  Created by Alex on 15-4-28.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DQImageEditViewDelegate <NSObject>

@required

//  增加图片按钮的回调
- (void)onAddImageView;

//  点击图片按钮的回调
- (void)onEditImageViewAtIndex:(int)index;

@optional

//  高度改变时的回调
- (void)onImageEditViewHeightChanged;

@end

@interface DQImageEditView : UIView

/*
 *  初始化
 *  @param frame: View的尺寸
 *  @param images: UIImageView数组
 */
- (id)initWithFrame:(CGRect)frame withImageViews:(NSArray *)imageViews withDelegate:(id<DQImageEditViewDelegate>)delegate isEditMode:(BOOL)isEdit withMaxImageCount:(int)maxImageCount;

/*
 *  增加一张图片
 *  @param imageView: 图片
 */
- (void)addImageView:(UIImageView *)imageView;

/*
 *  增加几张图片
 *  @param imageViews: 图片数组
 */
- (void)addImageViews:(NSArray *)imageViews;

/*
 *  删除某张图片
 *  @param index:
 */
- (void)removeImageViewAtIndex:(int)index;

/*
 *  替换某张图片
 *  @param imageView: 图片
 *  @param index:
 */
- (void)replaceImageView:(UIImageView *)imageView AtIndex:(int)index;

@property (nonatomic, assign) int maxImageCount;            //  最大图片数量
@property (nonatomic, assign) int countPerRow;              //  每行图片数量
@property (nonatomic, assign) float verticalPad;            //  垂直间隔（顶部、底部）
@property (nonatomic, assign) float horizontalPad;          //  水平间隔（左、右）
@property (nonatomic, assign) float imageEdgePad;           //  图片间隔
@property (nonatomic, assign) BOOL isEditMode;              //  是否属于编辑模式(只有编辑模式才显示按钮)

@end

@interface UploadImageData : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageURL;

@end
