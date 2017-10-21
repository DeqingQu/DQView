//
//  DQNaviDropdownCell.m
//  NaviDropdownMenu
//
//  Created by Alex on 15/7/14.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "DQNaviDropdownCell.h"

@interface DQNaviDropdownCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DQNaviDropdownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    [self setCellBeenSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the selected state

}

- (void)setTitleText:(NSString *)title {
    
    _titleLabel.text = title;
}

- (void)setTitleWidth:(CGFloat)width {
    _titleLabel.frame = CGRectMake(10, 5, width - 20, self.bounds.size.height - 10);
}

- (void)setCellBeenSelected:(BOOL)selected {
    
    if (selected) {
        _titleLabel.backgroundColor = [UIColor colorWithWhite:232.0f/255.0f alpha:1.0f];
        _titleLabel.textColor = [UIColor colorWithRed:249.0f/255.0f green:161.0f/255.0f blue:141.0f/255.0f alpha:1.0f];
    }
    else {
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = WAVE_BLUE;
    }
}

@end
