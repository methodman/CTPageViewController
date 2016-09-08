//
//  CTPageContentViewController.h
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealDataModel.h"

// CT Component

// Model

// View

// Controller

// Other
#import "CommonDef.h"

@class CTPageContentViewController;

@protocol CTPageContentViewControllerDelegate <NSObject>

@optional
- (void)viewController:(CTPageContentViewController *)pageContentViewController scrollTableView:(UIScrollView *)scrollView;
- (void)viewControllerBeginScrollTableView:(UIScrollView *)scrollView;
- (void)viewControllerEndScrollTableView:(UIScrollView *)scrollView;

@end




// 這邊繼承iOS7RelayoutViewController只是因為ActionManager [doGotoPponDealViewByBid:fromViewController:]這個method，之後看有沒有機會改寫
@interface CTPageContentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DealDataModelDelegate>

@property (nonatomic, assign) id<CTPageContentViewControllerDelegate>       delegate;
@property (nonatomic, retain) DealDataModel                                 *dealDataModel;
@property (nonatomic, retain) UITableView                                   *tableView;
@property (nonatomic, retain) UIRefreshControl                              *refreshControl;
@property (nonatomic, assign) CGRect                                        currentFrameRect;
@property (nonatomic, assign) NSInteger                                     index;

@property (nonatomic, assign) BOOL                                          hasMenuViewAboveTableView;

- (id)initWithFrame:(CGRect)rect;

@end
