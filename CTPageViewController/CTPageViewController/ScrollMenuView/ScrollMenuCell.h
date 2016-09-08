//
//  ScrollMenuCell.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/11.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ScrollMenuCellSubView.h"

@interface ScrollMenuCell : NSObject

@property (nonatomic, assign) CGSize                   cellSize;
@property (nonatomic, assign) NSInteger                cellIndex;
@property (nonatomic, assign) CGFloat                  leftBoundPosition;
@property (nonatomic, assign) CGFloat                  rightBoundPosition;
@property (nonatomic, retain) ScrollMenuCellSubView    *cellTextView;
@property (nonatomic, assign) BOOL                     isSelected;
@property (nonatomic, strong) UIColor                  *unSelectedColor;
@property (nonatomic, strong) UIColor                  *selectedColor;

@end
