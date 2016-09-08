//
//  MenuView.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ScrollMenuView.h"
#import "CommonDef.h"

@class MenuView;

//////////////////////////////////////////////////

@protocol MenuViewDelegate <NSObject>

@required
- (void)endScrollingAction:(MenuView *)menu index:(NSInteger)index;
- (void)tapTheSameMenuCell:(MenuView *)menu index:(NSInteger)index;

@end


@interface MenuView : UIView<ScrollMenuViewDataSource, ScrollMenuViewDelegate>

@property (nonatomic, assign) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) ScrollMenuView *scrollMenuView;
@property (nonatomic, strong) UIView *fakeBackgroundView;
@property (nonatomic, retain) NSMutableArray *dataArray; // Model
@property (nonatomic, assign) CGFloat viewInPositionY;
@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic, retain) UIColor *customBackgroundColor;
@property (nonatomic, assign) BOOL    isBackgroundUseImage;

- (instancetype)initWithFrame:(CGRect)frame andMenuViewType:(MenuViewType)menuViewType;

- (void)setViewStyleByMenuViewType:(MenuViewType)menuViewType;
- (void)setDisplayBackGroundColor:(UIColor *)color;
- (void)setDisplayBackGroundWithImage:(UIImage *)image;
- (void)scrollingPostionWithIndex:(NSInteger)index;
- (void)setLeftRightWithGradientImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage;
- (void)prepareDataModelWithArray:(NSArray *)dataArray assignIndex:(NSInteger)assignIndex;

@end