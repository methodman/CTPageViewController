//
//  ScrollMenuView.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "ScrollMenuView.h"


@interface ScrollMenuView()

@end


@implementation ScrollMenuView

@dynamic delegate;

const CGFloat paddigSize = 4.0f;

#pragma mark -
#pragma mark - init & dealloc
//================================================================================
//
//================================================================================
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //////////////////////////////////////////////////
    
    if (self) {
        
        [self initializeSetup];
    }
    
    return self;
}





#pragma mark -
#pragma mark - Instance Method
//================================================================================
//
//================================================================================
- (BOOL)hasDataToReloadWithRefreshFlag:(BOOL)isFreshView {

    BOOL hasData = NO;

    if (!self.delegate || ![self.delegate respondsToSelector:@selector(numberOfPageInScrollMenuView:)]) {
        
        return hasData;
    }
    
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(scrollMenuView:viewForRowAtIndex:)]) {
        
        return hasData;
    }
    
    _padding = paddigSize;
    
    _cellNumber = [self.delegate numberOfPageInScrollMenuView:self];
    
    [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if (isFreshView) {
    
        [_cellArray  removeAllObjects];
        [self.cellArray removeAllObjects];
        
        for (UIView *subView in self.subviews) {
            
            if (![subView isKindOfClass:[ScrollMenuCell class]]) { // 檢查contents內皆為ExpandTableViewData
                
                [subView removeFromSuperview];
            }
        }
    }

    //////////////////////////////////////////////////
    
    UIColor *selectedColor = nil;
    UIColor *unSelectedColor = nil;
    
    switch (self.menuViewType) {
            
        case MenuViewDefaultType:
            selectedColor = [UIColor colorWithRed: 199/255.0f green: 0/255.0f blue: 0/255.0f alpha:1.0f];
            unSelectedColor = [UIColor colorWithRed: 102/255.0f green: 102/255.0f blue: 102/255.0f alpha:1.0f];
            break;
            
        case MenuViewPiinLifeType:
            selectedColor = [UIColor whiteColor];
            unSelectedColor = [UIColor whiteColor];
            break;
            
        default:
            selectedColor = [UIColor colorWithRed: 199/255.0f green: 0/255.0f blue: 0/255.0f alpha:1.0f];
            unSelectedColor = [UIColor colorWithRed: 102/255.0f green: 102/255.0f blue: 102/255.0f alpha:1.0f];
            break;
    }
    
    //////////////////////////////////////////////////
    
    float startX = 0;
    
    for (NSInteger i = 0; i < self.cellNumber; i++) {
        
        ScrollMenuCell *scrollMenuCell = [[ScrollMenuCell alloc] init];
        
        if ([self.delegate respondsToSelector:@selector(sizeCellForScrollMenuView:index:)]) {
            
            scrollMenuCell.cellSize = [self.delegate sizeCellForScrollMenuView:self index:i];
            scrollMenuCell.selectedColor = selectedColor;
            scrollMenuCell.unSelectedColor = unSelectedColor;
        }
        
        scrollMenuCell.cellIndex = i;
        
        //////////////////////////////////////////////////
        
        float topY = (self.frame.size.height - scrollMenuCell.cellSize.height - 3); // 3 = (陰影圖的高度 / 2)
        
        scrollMenuCell.cellTextView = (ScrollMenuCellSubView *)[self.dataSource scrollMenuView:self viewForRowAtIndex:i];
        scrollMenuCell.cellTextView.frame = CGRectMake(startX,
                                                       topY,
                                                       scrollMenuCell.cellSize.width,
                                                       scrollMenuCell.cellSize.height);
        
        UIImage *arrowImage = [UIImage imageNamed:@"ch_drop_down_arrow_red"];
        
        if (scrollMenuCell.cellTextView.itemArrowImageView == nil) {
            
            [scrollMenuCell.cellTextView.itemArrowImageView setImage:arrowImage];
        }
    
        [scrollMenuCell.cellTextView.itemArrowImageView setHidden:YES];
        
        if (self.currentSelectedIndex == scrollMenuCell.cellIndex) {
            
            scrollMenuCell.isSelected = YES;
            
            for (UIView *textView in scrollMenuCell.cellTextView.subviews) {
                
                if([textView isKindOfClass:[UILabel class]]) {
                    
                    ((UILabel *)textView).textColor = scrollMenuCell.selectedColor;
                    
                    if (scrollMenuCell.cellTextView.itemArrowImageView) {
                        
                        if (scrollMenuCell.cellTextView.hasLevel0ChildToExpand) {
    
                            [scrollMenuCell.cellTextView.itemArrowImageView setHidden:NO];
                        }
                    }
                }
            }
        }
        else {
            
            scrollMenuCell.isSelected = NO;
            
            for (UIView *textView in scrollMenuCell.cellTextView.subviews) {
                
                if([textView isKindOfClass:[UILabel class]]) {
                    
                    ((UILabel *)textView).textColor = scrollMenuCell.unSelectedColor;
                    
                    if (scrollMenuCell.cellTextView.itemArrowImageView) {
                        
                        if (scrollMenuCell.cellTextView.hasLevel0ChildToExpand) {
                            
                            [scrollMenuCell.cellTextView.itemArrowImageView setHidden:YES];
                        }
                    }
                }
            }
        }
        
        [self addSubview:scrollMenuCell.cellTextView];
        
        //////////////////////////////////////////////////
        
        if (i == 0) {
            // 這邊特別在index = 0時減去寬度的1/2作為left bound是因為初始位置0位於第一個menu cell的中間
            scrollMenuCell.leftBoundPosition = startX - (scrollMenuCell.cellSize.width / 2);
        }
        else {
            
            scrollMenuCell.leftBoundPosition = startX;
        }
        
        startX += scrollMenuCell.cellSize.width;
        scrollMenuCell.rightBoundPosition = startX;
        startX += self.padding;
        
        [self.cellArray addObject:scrollMenuCell];
      
    }
    
    //////////////////////////////////////////////////
    
    if ([self.cellArray count] > 0) {
        
        hasData = YES;
        
        ScrollMenuCell *initMenuCell = [self.cellArray objectAtIndex:0];
        
        self.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - initMenuCell.cellSize.width) / 2,
                                0,
                                initMenuCell.cellSize.width,
                                44);
        
        CGFloat scrollViewSizeWith = startX - self.padding; // 扣除最後一格無須padding
        self.contentSize = CGSizeMake(scrollViewSizeWith, 1);
    }
    
    return hasData;
}


//================================================================================
//
//================================================================================
- (void)goToPositionWithIndex:(NSInteger)index {
    
    CGFloat forwardPosition = 0;
    
    if (self.cellArray && [self.cellArray count] > 0) {
        
        ScrollMenuCell *initMenuCell = [self.cellArray objectAtIndex:0];
        ScrollMenuCell *currentMenuCell = [self.cellArray objectAtIndex:index];
        
        if (index > 0) {
            
            forwardPosition = initMenuCell.cellSize.width / 2 + self.padding * index + currentMenuCell.cellSize.width / 2;
            
            for (NSInteger i = 1; i <= (currentMenuCell.cellIndex - 1); i++) {
                
                ScrollMenuCell *middleMenuCell = [self.cellArray objectAtIndex:i];
                forwardPosition += middleMenuCell.cellSize.width;
            }
        }
        else {
            
            forwardPosition = 0;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setContentOffset:CGPointMake(forwardPosition, 0)];
        }];
    }
    else {
        
        NSLog(@"goToPositionWithIndex:  the Index = nil at Array");
    }
}


//================================================================================
// 移動scroll到滑動/拖曳後的位置 (不可使用系統預設的paging效果)
//================================================================================
- (NSInteger)IndexFromSelectionPositionWithEndScrollEvent:(UIScrollView *)scrollView
{
    CGFloat detectedLeftBound = 0;
    CGFloat detectedRightBound = 0;
    ScrollMenuCell *initMenuCell = [self.cellArray objectAtIndex:0];
    CGFloat initPosition = initMenuCell.cellSize.width / 2;
    
    for (NSInteger i = 0; i < self.cellNumber; i++) {
        
        ScrollMenuCell *currentMenuCell = [self.cellArray objectAtIndex:i];
        detectedLeftBound = currentMenuCell.leftBoundPosition - initPosition - (self.padding / 2);
        detectedRightBound = currentMenuCell.rightBoundPosition - initPosition + (self.padding / 2);
        
        if (scrollView.contentOffset.x > detectedLeftBound && scrollView.contentOffset.x < detectedRightBound) {
            
            [UIView animateWithDuration:0.3 animations:^{
                // 用右邊界來算比較簡潔，不要用左邊界，會有起始位置的問題
                [self setContentOffset:CGPointMake(detectedRightBound - (self.padding / 2) - (currentMenuCell.cellSize.width / 2) , 0)];
            }];
            
            self.currentSelectedIndex = i;
            
            return i;
        }
    }
    return 0;
}


//================================================================================
// 以字數來計算該cell需要多少寬度
//================================================================================
- (CGSize)currentSizeOfCellWithScrollMenuCell:(ScrollMenuCell *)scrollMenuCell {
    
    NSString *stringDisplayInCell = scrollMenuCell.cellTextView.cellTextLabel.text;
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *textAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize cellTextSize = [stringDisplayInCell sizeWithAttributes:textAttributes];
        
    UIImage *arrowImage = nil;
    
   // if (scrollMenuCell.cellTextView.hasLevel0ChildToExpand) {
        
        arrowImage = [UIImage imageNamed:@"ch_drop_down_arrow_red"];
    //}
    
    scrollMenuCell.cellTextView.itemArrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    scrollMenuCell.cellTextView.itemArrowImageView.frame = CGRectMake(scrollMenuCell.cellTextView.itemArrowImageView.frame.size.width + cellTextSize.width + self.padding,
                                                                  cellTextSize.height + scrollMenuCell.cellTextView.itemArrowImageView.frame.size.height / 2 + 3,
                                                                  scrollMenuCell.cellTextView.itemArrowImageView.frame.size.width,
                                                                  scrollMenuCell.cellTextView.itemArrowImageView.frame.size.height);
    [scrollMenuCell.cellTextView addSubview:scrollMenuCell.cellTextView.itemArrowImageView];
    CGFloat totalSizeWidth = cellTextSize.width + scrollMenuCell.cellTextView.itemArrowImageView.frame.size.width + self.padding;
    cellTextSize = CGSizeMake(totalSizeWidth + scrollMenuCell.cellTextView.itemArrowImageView.frame.size.width, cellTextSize.height);
    [scrollMenuCell.cellTextView.itemArrowImageView setHidden:YES];
    
    return cellTextSize;
}





#pragma mark -
#pragma mark - Gesture Action
//================================================================================
// 判斷是否點擊在menu item內
//================================================================================
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    CGFloat forwardPosition = 0;
    
    //////////////////////////////////////////////////
    
    CGFloat frameHeight = self.frame.size.height;
    
    for (ScrollMenuCell *menuCell in self.cellArray) {
    
        CGFloat topY = (frameHeight - menuCell.cellSize.height) / 2;
        
        BOOL yInCell = NO;
        
        if (tapPoint.y > topY && tapPoint.y < frameHeight - topY) {
            
            yInCell = YES;
        }
        
        //////////////////////////////////////////////////
        
        NSInteger xInCellNumber = 0;
        
        BOOL xInCell = NO;
        
        if (tapPoint.x > menuCell.leftBoundPosition && tapPoint.x < menuCell.rightBoundPosition) {
            
            xInCell = YES;
        }
        
        if (xInCellNumber < 0 || xInCellNumber >= self.cellNumber) {
            
            xInCell = NO;
        }
        
        //////////////////////////////////////////////////
        
        if (yInCell && xInCell) {
        
            if (menuCell.cellIndex - 1 < 0) {
                
                forwardPosition = 0;
            }
            else {
                
                ScrollMenuCell *initMenuCell = [self.cellArray objectAtIndex:0];
                ScrollMenuCell *currentMenuCell = [self.cellArray objectAtIndex:menuCell.cellIndex];
                
                if (menuCell.cellIndex > 0) {
                    
                    forwardPosition = initMenuCell.cellSize.width / 2 + self.padding * menuCell.cellIndex + currentMenuCell.cellSize.width / 2;
                    
                    for (NSInteger i = 1; i <= (currentMenuCell.cellIndex - 1); i++) {
                        
                        ScrollMenuCell *middleMenuCell = [self.cellArray objectAtIndex:i];
                        forwardPosition += middleMenuCell.cellSize.width;
                    }
                }
                else {
                    
                    forwardPosition = 0;
                }
            }
            
            xInCellNumber = menuCell.cellIndex;
            
            if ([self.delegate respondsToSelector:@selector(scrollMenuView:didTapPageAtIndex:)]) {
                
                [self.delegate scrollMenuView:self didTapPageAtIndex:xInCellNumber];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                [self setContentOffset:CGPointMake(forwardPosition, 0)];
            }];
            return;
        }
    }
}





#pragma mark -
#pragma mark - Class Method
//================================================================================
//
//================================================================================
- (void)initializeSetup
{
    _currentSelectedIndex = 0;
    
    self.clipsToBounds = NO;
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.autoresizesSubviews = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.multipleTouchEnabled = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //////////////////////////////////////////////////
    
    _cellArray = [NSMutableArray array];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.tapGesture];
    self.scrollsToTop = NO;
}

@end
