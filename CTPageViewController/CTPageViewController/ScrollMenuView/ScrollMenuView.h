//
//  ScrollMenuView.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ScrollMenuCell.h"

typedef NS_ENUM(NSUInteger, MenuViewType) {
    MenuViewDefaultType  = 0,
    MenuViewPiinLifeType = 1,
};

@class ScrollMenuView;

//////////////////////////////////////////////////

@protocol ScrollMenuViewDelegate <UIScrollViewDelegate>

@required
- (NSInteger)numberOfPageInScrollMenuView:(ScrollMenuView *)scrollMenuView;

@optional
- (CGSize)sizeCellForScrollMenuView:(ScrollMenuView *)scrollMenuView index:(NSInteger)index;
- (void)scrollMenuView:(ScrollMenuView *)scrollMenuView didTapPageAtIndex:(NSInteger)index;

@end

//////////////////////////////////////////////////

@protocol ScrollMenuViewDataSource <UIScrollViewDelegate>

@required
- (UIView *)scrollMenuView:(ScrollMenuView *)scrollMenuView viewForRowAtIndex:(NSInteger)index;

@end

//////////////////////////////////////////////////

@interface ScrollMenuView : UIScrollView

@property (nonatomic, assign) id<ScrollMenuViewDataSource> dataSource;
@property (nonatomic, assign) id<ScrollMenuViewDelegate> delegate;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) NSMutableArray *cellArray;
@property (nonatomic, assign) NSInteger cellNumber;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, assign) MenuViewType menuViewType;

- (BOOL)hasDataToReloadWithRefreshFlag:(BOOL)isFreshView;
- (void)goToPositionWithIndex:(NSInteger)index;
- (NSInteger)IndexFromSelectionPositionWithEndScrollEvent:(UIScrollView *)scrollView;
- (CGSize)currentSizeOfCellWithScrollMenuCell:(ScrollMenuCell *)scrollMenuCell;

@end
