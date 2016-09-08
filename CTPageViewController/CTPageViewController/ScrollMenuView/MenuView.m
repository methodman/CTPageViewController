//
//  MenuView.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView





#pragma mark -
#pragma mark - init & dealloc
//================================================================================
// 若使用storyBoard載入，請在初始化後，設定menuViewType
//================================================================================
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //////////////////////////////////////////////////
    
    [self setupMenuViewDetail];
}


//================================================================================
//
//================================================================================
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //////////////////////////////////////////////////
    
    if (self) {
        
        [self setupMenuViewDetail];
    }
    
    return self;
}


//================================================================================
//
//================================================================================
- (instancetype)initWithFrame:(CGRect)frame andMenuViewType:(MenuViewType)menuViewType {
    
    self = [self initWithFrame:frame];
    
    if (self) {
        
        [self setViewStyleByMenuViewType:menuViewType];
    }
    
    return self;
}



//================================================================================
//
//================================================================================
- (void)layoutSubviews {
    
    for(UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    if (!self.isBackgroundUseImage) {
        
        [self setDisplayBackGroundColor:self.backgroundColor];
    }
    
    UIImage *leftImage = nil;
    UIImage *rightImage = nil;
    
    
    if (self.scrollMenuView.menuViewType != MenuViewPiinLifeType) {
        
        leftImage = [UIImage imageNamed:@"shadow_left"];
        rightImage = [UIImage imageNamed:@"shadow_right"];
    }
    else {
        
        leftImage = [UIImage imageNamed:@"shadow_left_pinglife"];
        rightImage = [UIImage imageNamed:@"shadow_right_pinglife"];
    }
    
    [self setLeftRightWithGradientImage:leftImage rightImage:rightImage];
    
    //////////////////////////////////////////////////
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                 self.frame.size.height - 6,
                                                                                 self.frame.size.width,
                                                                                 6)];
    shadowImageView.image = [UIImage imageNamed:@"category_bg_shadow"];
    [shadowImageView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:shadowImageView];
}





#pragma mark -
#pragma mark - Instance Method
//================================================================================
//
//================================================================================
- (void)setViewStyleByMenuViewType:(MenuViewType)menuViewType
{
    _scrollMenuView.menuViewType = menuViewType;
}


//================================================================================
//
//================================================================================
- (void)setDisplayBackGroundColor:(UIColor *)color {
    
    if (self.fakeBackgroundView) {
        
        if (color == nil) {
            
            if (self.scrollMenuView.menuViewType != MenuViewPiinLifeType) {
                
                [self.fakeBackgroundView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
                
            }
            else {
                
                [self.fakeBackgroundView setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:108.0/255.0 blue:89.0/255.0 alpha:1.0]];
            }
        }
        else { // 自訂色
            
            if (self.customBackgroundColor != self.backgroundColor) {
                
                 [self .fakeBackgroundView setBackgroundColor:self.customBackgroundColor];
            }
            self.customBackgroundColor = color;
           
        }
        
    }
}


//================================================================================
//
//================================================================================
- (void)setDisplayBackGroundWithImage:(UIImage *)image {
    
    if (image != nil) {
        
        self.isBackgroundUseImage = YES;
    }
    
    UIGraphicsBeginImageContext(self.fakeBackgroundView.frame.size);
    [image drawInRect:self.fakeBackgroundView.bounds];
    UIImage *displayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.fakeBackgroundView.backgroundColor = [UIColor colorWithPatternImage:displayImage];
}


//================================================================================
//
//================================================================================
- (void)scrollingPostionWithIndex:(NSInteger)index
{
    [self.scrollMenuView goToPositionWithIndex:index];
    
    [self setCurrentLabelTextBeSelectedWithIndex:self.scrollMenuView.currentSelectedIndex scrollview:self.scrollMenuView isSelected:NO];
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:self.scrollMenuView isSelected:YES];
    
    self.scrollMenuView.currentSelectedIndex = index;
}


//================================================================================
//
//================================================================================
- (void)setLeftRightWithGradientImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage {
    
    if (!leftImage || !rightImage) {
        
        return;
    }
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:leftImage];
    leftImageView.frame = CGRectMake(0,
                                     0,
                                     leftImage.size.width,
                                     self.fakeBackgroundView.frame.size.height);
    [self addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:rightImage];
    rightImageView.frame = CGRectMake(self.frame.size.width - rightImage.size.width,
                                      0,
                                      rightImage.size.width,
                                      self.fakeBackgroundView.frame.size.height);
    [self addSubview:rightImageView];
}


//================================================================================
//
//================================================================================
- (void)prepareDataModelWithArray:(NSArray *)dataArray assignIndex:(NSInteger)assignIndex {
    
    if (self.dataArray != nil && [self.dataArray count] > 0) {
        
        [self.dataArray removeAllObjects];
        self.scrollMenuView.currentSelectedIndex = assignIndex;
    }
    
    NSInteger index = 0;
    
    for (NSString *titleItem in dataArray) {
        
        ScrollMenuCell *scrollMenuCell = [[ScrollMenuCell alloc] init];
        scrollMenuCell.cellTextView = [[ScrollMenuCellSubView alloc] init];
        scrollMenuCell.cellTextView.cellTextLabel = [[UILabel alloc] init];
        scrollMenuCell.cellTextView.cellTextLabel.text = titleItem;
        scrollMenuCell.cellIndex = index;
        [self.dataArray addObject:scrollMenuCell];
        [self setCurrentItemWithArray:self.dataArray];
        
        index++;
    }
    
    [self scrollingPostionWithIndex:assignIndex];
}





#pragma mark -
#pragma mark - Override Method
//================================================================================
//
//================================================================================
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    point.y += self.viewInPositionY;
    
    if (CGRectContainsPoint(self.frame, point) || CGRectContainsPoint(self.scrollMenuView.frame, point)) {
        
        return self.scrollMenuView;
    }
    
    UIView *returnView = [super hitTest:point withEvent:event];
    return returnView;
}





#pragma mark -
#pragma mark - ScrollMenuView DataSource
//================================================================================
//
//================================================================================
- (UIView *)scrollMenuView:(ScrollMenuView *)scrollMenuView viewForRowAtIndex:(NSInteger)index {
    
    ScrollMenuCell *currentMenuCell = [self.dataArray objectAtIndex:index];
    CGSize cellTextSize = [scrollMenuView currentSizeOfCellWithScrollMenuCell:currentMenuCell];
    
    //////////////////////////////////////////////////
    
    ScrollMenuCell *addMenuCell = [[ScrollMenuCell alloc] init];
    addMenuCell.cellTextView = currentMenuCell.cellTextView;
    addMenuCell.cellTextView.frame = CGRectMake(0,
                                                0,
                                                cellTextSize.width,
                                                self.scrollViewHeight);
    addMenuCell.cellTextView.backgroundColor = [UIColor clearColor];
    addMenuCell.cellTextView.cellTextLabel.frame = CGRectMake(0,
                                                                0,
                                                                cellTextSize.width,
                                                                self.scrollViewHeight);
    addMenuCell.cellTextView.cellTextLabel.textAlignment = NSTextAlignmentCenter;
    [addMenuCell.cellTextView.cellTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    [addMenuCell.cellTextView addSubview:addMenuCell.cellTextView.cellTextLabel];
    
    return addMenuCell.cellTextView;
}




#pragma mark -
#pragma mark - ScrollMenuView Delegate
//================================================================================
//
//================================================================================
- (NSInteger)numberOfPageInScrollMenuView:(ScrollMenuView *)scrollMenuView {
    
    NSInteger itemCount = [self.dataArray count];
    return itemCount;
}


//================================================================================
//
//================================================================================
- (CGSize)sizeCellForScrollMenuView:(ScrollMenuView *)scrollMenuView index:(NSInteger)index {
    
    ScrollMenuCell *currentMenuCell = [self.dataArray objectAtIndex:index];
    CGSize sizeOfCell = [scrollMenuView currentSizeOfCellWithScrollMenuCell:currentMenuCell];
    sizeOfCell = CGSizeMake(sizeOfCell.width, self.scrollMenuView.frame.size.height);
    
    return sizeOfCell;
}


//================================================================================
// 點擊某個item後的事件
//================================================================================
- (void)scrollMenuView:(ScrollMenuView *)scrollMenuView didTapPageAtIndex:(NSInteger)index {
    
    // NSLog(@"click cell at %ld",index);
    
    if (scrollMenuView.currentSelectedIndex == index) {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapTheSameMenuCell:index:)]) {
            
            [self.delegate tapTheSameMenuCell:self index:index];
            return;
        }
    }
    
    [self setCurrentLabelTextBeSelectedWithIndex:scrollMenuView.currentSelectedIndex scrollview:scrollMenuView isSelected:NO];
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollMenuView isSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
    
    scrollMenuView.currentSelectedIndex = index;
}





#pragma mark -
#pragma mark - ScrollView Delegate
//================================================================================
//
//================================================================================
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    [self setCurrentLabelTextBeSelectedWithIndex:((ScrollMenuView *)scrollView).currentSelectedIndex scrollview:scrollView isSelected:NO];
}


//================================================================================
//
//================================================================================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self setCurrentLabelTextBeSelectedWithIndex:((ScrollMenuView *)scrollView).currentSelectedIndex scrollview:scrollView isSelected:NO];
}


//================================================================================
// 處理滑動後的事件
//================================================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self.scrollMenuView IndexFromSelectionPositionWithEndScrollEvent:scrollView];
    
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollView isSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
    
}


//================================================================================
// 處理拖曳後的事件
//================================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        NSInteger index = [self.scrollMenuView IndexFromSelectionPositionWithEndScrollEvent:scrollView];
        
        [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollView  isSelected:YES];
        
        if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
            
            [self.delegate endScrollingAction:self index:index];
        }
    }
}





#pragma mark - 
#pragma mark - Class Method
//================================================================================
//
//================================================================================
- (void)setupMenuViewDetail {
    
    self.dataArray = [NSMutableArray array];
    
    //////////////////////////////////////////////////
    
    self.backgroundColor = [UIColor whiteColor];
    _customBackgroundColor = self.backgroundColor;
    _isBackgroundUseImage = NO;
    [self setClipsToBounds:YES];
    
    //////////////////////////////////////////////////
    
    _scrollMenuView = [[ScrollMenuView alloc] initWithFrame:self.frame];
    self.scrollMenuView.menuViewType = MenuViewDefaultType;
    self.scrollMenuView.backgroundColor = [UIColor clearColor];
    self.scrollMenuView.currentSelectedIndex = 0;
    self.scrollMenuView.dataSource = self;
    self.scrollMenuView.delegate = self;
    self.viewInPositionY = self.frame.origin.y;
    self.scrollViewHeight = self.frame.size.height;
    
    //////////////////////////////////////////////////
    
    CGRect contentRect = CGRectMake(0,
                                    0,
                                    ScreenSize.width,
                                    self.frame.size.height - 6);
    _fakeBackgroundView = [[UIView alloc] initWithFrame:contentRect];
    self.fakeBackgroundView.backgroundColor = [UIColor whiteColor];
    
    //////////////////////////////////////////////////
    
    [self addSubview:self.fakeBackgroundView];
    [self addSubview:self.scrollMenuView];
}


//================================================================================
//
//================================================================================
- (void)setCurrentLabelTextBeSelectedWithIndex:(NSInteger)index scrollview:(UIScrollView *)scrollView isSelected:(BOOL)isSelected {
    
    // NSLog(@"current index : %ld",(long)index);
    ((ScrollMenuView *)scrollView).currentSelectedIndex = index;
    
    if (index < 0 || index > ([self.scrollMenuView.cellArray count] - 1)) {
        
        return;
    }
    
    ScrollMenuCell *cell = [self.scrollMenuView.cellArray objectAtIndex:index];
    
    
    if (isSelected) {
        
        cell.cellTextView.cellTextLabel.textColor = cell.selectedColor;
        cell.isSelected = YES;
        
        if (cell.cellTextView.hasLevel0ChildToExpand) {

            cell.cellTextView.itemArrowImageView.image = nil;
            UIImage *currentStatusCloseImage = [UIImage imageNamed:@"ch_drop_down_arrow_red"];
            [cell.cellTextView.itemArrowImageView setImage:currentStatusCloseImage];
            [cell.cellTextView.itemArrowImageView setHidden:NO];
        }
    }
    else {
        
        cell.cellTextView.cellTextLabel.textColor = cell.unSelectedColor;
        cell.isSelected = NO;
        
        if (cell.cellTextView.hasLevel0ChildToExpand) {
            
            cell.cellTextView.itemArrowImageView.image = nil;
            UIImage *currentStatusCloseImage = [UIImage imageNamed:@"ch_drop_down_arrow_red"];
            [cell.cellTextView.itemArrowImageView setImage:currentStatusCloseImage];
            [cell.cellTextView.itemArrowImageView setHidden:YES];
        }
    }
}


//================================================================================
//
//================================================================================
- (void)setCurrentItemWithArray:(NSMutableArray *)currentDataArray {

    self.scrollMenuView.cellArray = [NSMutableArray arrayWithArray:currentDataArray];
}



@end


