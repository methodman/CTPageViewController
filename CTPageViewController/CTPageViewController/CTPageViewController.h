//
//  CTPageContentViewController.h
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPageContentViewController.h"

// CT Component

// Model
#import "DealDataModel.h"

// View
#import "MenuView.h"

// Controller

// Other
#import "CommonDef.h"

@class CTPageViewController;

@protocol CTPageViewControllerDelegate <NSObject>

@required
- (void)viewController:(CTPageViewController *)channelPageViewController scrollToViewWithIndex:(NSInteger)viewIndex;

@optional
- (void)viewController:(CTPageViewController *)channelPageViewController updateTheDealArray:(NSMutableArray *)dealsArray;

@end





@interface CTPageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, CTPageContentViewControllerDelegate, MenuViewDelegate>

@property (nonatomic, assign) id<CTPageViewControllerDelegate>      delegate;
@property (nonatomic, retain) DealDataModel                         *dealDataModel;
@property (nonatomic, retain) CTPageContentViewController           *contentViewController;
@property (nonatomic, retain) MenuView                              *menuView;

@property (nonatomic, retain) UIPageViewController                  *pageController;
@property (nonatomic, retain) UINavigationBar                       *navbar;

@property (nonatomic, assign) BOOL                                  isViewCreateMenuView;
@property (nonatomic, assign) BOOL                                  isViewCreateNavigationBar;

@end
