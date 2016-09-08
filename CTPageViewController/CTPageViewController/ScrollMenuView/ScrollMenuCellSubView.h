//
//  ScrollMenuCellSubView.h
//  New17life
//
//  Created by johnny_wu on 2016/3/28.
//
//

#import <UIKit/UIKit.h>

@interface ScrollMenuCellSubView : UIView

@property (nonatomic, assign) BOOL        hasLevel0ChildToExpand;
@property (nonatomic, retain) UILabel     *cellTextLabel;
@property (nonatomic, retain) UIImageView *itemArrowImageView;
@property (nonatomic, assign) NSString    *idString;
@end
