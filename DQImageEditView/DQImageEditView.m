//
//  DQImageEditView.m
//  Tide
//
//  Created by Alex on 15-4-28.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQImageEditView.h"

#define IMAGE_VIEW_TAG  3000

#pragma mark UploadImageData

@implementation UploadImageData

@end


#pragma mark DQImageEditView

@interface DQImageEditView ()

- (void)refreshView;

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, weak) id<DQImageEditViewDelegate> delegate;

@end

@implementation DQImageEditView

- (id)initWithFrame:(CGRect)frame withImageViews:(NSArray *)imageViews withDelegate:(id<DQImageEditViewDelegate>)delegate isEditMode:(BOOL)isEdit withMaxImageCount:(int)maxImageCount
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maxImageCount = maxImageCount;
        _countPerRow = 4;
        _verticalPad = 10.0f;
        _horizontalPad = 5.0f;
        _imageEdgePad = 4.0f;
        _isEditMode = isEdit;
        _delegate = delegate;
        
        if ([imageViews count] > 0) {
            _imageViews = [[NSMutableArray alloc] initWithArray:imageViews];
        }
        else {
            _imageViews = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        [self refreshView];
    }
    return self;
}

- (void)refreshView
{
    self.backgroundColor = [UIColor colorWithWhite:240.0f/255.0f alpha:1.0f];
    
    //  清空subviews
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    //计算每个cell的宽度和高度, 调整整个view的高度
    
    float cellWidth = (self.frame.size.width - 2*_horizontalPad - (_countPerRow-1)*_imageEdgePad)/_countPerRow;
    
    int imageCount = (int)[_imageViews count];
    if (imageCount > _maxImageCount) {
        imageCount = _maxImageCount;
    }
    int maxColumn = 0;
    if (_isEditMode && imageCount < _maxImageCount) {
        maxColumn = ceilf((float)(imageCount+1) / (float)_countPerRow);
    }
    else {
        maxColumn = ceilf((float)imageCount / (float)_countPerRow);
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 2*_verticalPad + (maxColumn-1)*_imageEdgePad + maxColumn*cellWidth);
    
    //  绘制View
    for (int i=0; i<imageCount; i++) {
        
        int rowIndex = i/_countPerRow;
        int columnIndex = i%_countPerRow;
        
        UIImageView *imageView = [_imageViews objectAtIndex:i];
        imageView.frame = CGRectMake(_horizontalPad + columnIndex*(cellWidth+_imageEdgePad), _verticalPad + rowIndex*(cellWidth+_imageEdgePad), cellWidth, cellWidth);
        imageView.tag = IMAGE_VIEW_TAG + i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTapped:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesture];
        
        [self addSubview:imageView];
    }
    
    //  绘制添加照片按钮
    if(imageCount < _maxImageCount && _isEditMode)
    {
        int rowIndex = imageCount/_countPerRow;
        int columnIndex = imageCount%_countPerRow;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_horizontalPad + columnIndex*(cellWidth+_imageEdgePad), _verticalPad + rowIndex*(cellWidth+_imageEdgePad), cellWidth, cellWidth)];
        [button setBackgroundImage:[UIImage imageNamed:@"DQ_ImageEdit_edit"] forState:UIControlStateNormal];
        [button addTarget:_delegate action:@selector(onAddImageView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)addImageView:(UIImageView *)imageView
{
    [_imageViews addObject:imageView];
    
    [self refreshView];
    
    if ([_delegate respondsToSelector:@selector(onImageEditViewHeightChanged)]) {
        [_delegate onImageEditViewHeightChanged];
    }
}

- (void)addImageViews:(NSArray *)imageViews
{
    [_imageViews addObjectsFromArray:imageViews];
    
    [self refreshView];
    
    if ([_delegate respondsToSelector:@selector(onImageEditViewHeightChanged)]) {
        [_delegate onImageEditViewHeightChanged];
    }
}

- (void)removeImageViewAtIndex:(int)index
{
    [_imageViews removeObjectAtIndex:index];
    
    [self refreshView];
    
    if ([_delegate respondsToSelector:@selector(onImageEditViewHeightChanged)]) {
        [_delegate onImageEditViewHeightChanged];
    }
}

- (void)replaceImageView:(UIImageView *)imageView AtIndex:(int)index
{
    [_imageViews replaceObjectAtIndex:index withObject:imageView];
    
    [self refreshView];
}

#pragma UIGesture

- (void)onImageViewTapped:(UIGestureRecognizer *)gesture
{
    int index = (int)(gesture.view.tag) - IMAGE_VIEW_TAG;
    if ([_delegate respondsToSelector:@selector(onEditImageViewAtIndex:)]) {
        [_delegate onEditImageViewAtIndex:index];
    }
}

@end

