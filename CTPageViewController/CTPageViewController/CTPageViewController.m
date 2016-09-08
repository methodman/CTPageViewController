//
//  CTPageViewController.m
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import "CTPageViewController.h"

// CT Component

// Model

// View

// Controller
#import "CTPageContentViewController.h" // 內容的viewController


// Other


@interface CTPageViewController ()

@property (nonatomic, assign) CGFloat           mainPagePositionY;
@property (nonatomic, retain) NSMutableArray    *menuViewCategoryArray;
@property (nonatomic, assign) CGFloat           scrollViewLastContentOffsetAtY;

@end

@implementation CTPageViewController

static const CGFloat navgationBarHeight = 44.0f;





#pragma mark - Init & Dealloc
#pragma mark -
//================================================================================
//
//================================================================================
- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self == [super initWithCoder:aDecoder]) {

        _dealDataModel = [DealDataModel sharedInstance];
        [self.dealDataModel addObserver:self forKeyPath:@"currentSelectCategoryIndex" options:NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}


//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    // 屬性設定 & 資料載入
    _isViewCreateMenuView = NO;
    _isViewCreateNavigationBar = YES; // 目前個頁面幾乎都要，先設為YES
    
    //////////////////////////////////////////////////
    // 取得當前頁面之類別的基本資訊
    [self.dealDataModel updateCurrentCahnnelData];
    _menuViewCategoryArray = self.dealDataModel.categoryArray;
    
    //////////////////////////////////////////////////
    // setup layout
    _mainPagePositionY = HEIGHT_OF_STATUSBAR;
    
    [self createNavigationBarWithFlag:self.isViewCreateNavigationBar];
    
    //////////////////////////////////////////////////
    
    if (self.dealDataModel.categoryArray != nil && [self.dealDataModel.categoryArray count] > 0) {
        
        self.isViewCreateMenuView = YES; // 若categoryArray有item代表需要建立scroll menu
    }
    
    [self createMenuViewWithFlag:self.isViewCreateMenuView];

    //////////////////////////////////////////////////

    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [self.pageController.view setFrame:self.view.bounds];

    CTPageContentViewController *initViewController = [self viewControllerAtIndex:0];
    initViewController.delegate = self;
    initViewController.dealDataModel.delegate = initViewController;
    [self.pageController setViewControllers:@[initViewController] //P.S 這邊是傳index而非type
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self.dealDataModel reloadDealsDataForChannelWithIndex:initViewController.index];
    [self addChildViewController:self.pageController];
    
    //////////////////////////////////////////////////
    
    if (self.menuView != nil) {
        
        [self.view insertSubview:self.pageController.view belowSubview:self.menuView];
    }
    else {
        
        [self.view addSubview:self.pageController.view];
    }
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.pageController didMoveToParentViewController:self];
}


//================================================================================
//
//================================================================================
- (void)dealloc {
    
    [self.dealDataModel removeObserver:self forKeyPath:@"currentSelectCategoryIndex"];
    self.dealDataModel = nil;
}



#pragma mark - setup layout
#pragma mark -
//================================================================================
// 由Flag判斷該頁面是否需要建立Navigation Bar
//================================================================================
- (void)createNavigationBarWithFlag:(BOOL)isViewCreateNavigationBar {
    
    if (self.isViewCreateNavigationBar) {
        
        _navbar = [[UINavigationBar alloc] init];
        self.navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.view.bounds.size.width,
                                                                       self.mainPagePositionY + navgationBarHeight)];
        self.mainPagePositionY += self.navbar.frame.size.height;
        NSMutableArray *titleItemArray = [NSMutableArray array];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:self.dealDataModel.channelTitle];
        [titleItemArray addObject:navItem];
        self.navbar.items = [titleItemArray copy];
        [self.view addSubview:self.navbar];
    }
}


//================================================================================
// 由Flag判斷該頁面是否需要建立MenuView
//================================================================================
- (void)createMenuViewWithFlag:(BOOL)isViewCreateMenuView {
    
    if (isViewCreateMenuView) {
        
        CGRect menuViewRect = CGRectMake(0,
                                         HEIGHT_OF_STATUSBAR + HEIGHT_OF_SCROLLMENU,
                                         ScreenSize.width,
                                         HEIGHT_OF_SCROLLMENU + HEIGHT_OF_MENUVIEW_SHADOW);
        
        _menuView = [[MenuView alloc] initWithFrame:menuViewRect andMenuViewType:MenuViewDefaultType];
        //[self.menuView setDisplayBackGroundWithImage:[UIImage imageNamed:@"Rainbow-Download-PNG.png"]]; // 設定背景圖後，若不設，則menuview背景為預設的顏色
        //[self.menuView setDisplayBackGroundColor:[UIColor greenColor]];
        // MARK:: 若setDisplayBackGroundWithImage及setDisplayBackGroundColor都有設定值，則不管先後次序，一律會顯示image
        // MARK:: 若都沒設定，就顯示白色（預色
        self.menuView.delegate = self;
        self.menuView.dataArray = [NSMutableArray array];
        
        for (NSString *categoryDataString in self.dealDataModel.categoryArray) {
                
            ScrollMenuCell *scrollMenuCell = [[ScrollMenuCell alloc] init];
            scrollMenuCell.cellTextView = [[ScrollMenuCellSubView alloc] init];
            scrollMenuCell.cellTextView.cellTextLabel = [[UILabel alloc] init];
            scrollMenuCell.cellTextView.cellTextLabel.text = categoryDataString;
            scrollMenuCell.cellTextView.idString = categoryDataString;
            
            [self.menuView.dataArray addObject:scrollMenuCell];
        }
        
         [self.menuView.scrollMenuView hasDataToReloadWithRefreshFlag:NO];
        
        NSInteger index = 0;
        [self.view insertSubview:self.menuView belowSubview:self.navbar];
        self.dealDataModel.currentSelectCategoryIndex = index;
        
        [self.menuView scrollingPostionWithIndex:self.dealDataModel.currentSelectCategoryIndex];
    }
    else {
        
        self.dealDataModel.currentSelectCategoryIndex = 0;
    }
}





#pragma mark - UIPageViewController DataSource
#pragma mark -
//================================================================================
//
//================================================================================
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (self.menuViewCategoryArray == nil) {
        
        return nil;
    }
    
    //////////////////////////////////////////////////
    
    NSInteger index = [(CTPageContentViewController *)viewController index];
    
    if (self.isViewCreateMenuView) {
    
        index --;
        
        if (index == -1) {
            
            if ([self.menuViewCategoryArray count] > 0) {
                
                index = ([self.menuViewCategoryArray count] - 1);
            }
            else {
                
                index = 0;
            }
        }
    }
    else {
        
        index = 0;
    }

    CTPageContentViewController *returnContentViewController = [self viewControllerAtIndex:index];
    return returnContentViewController;
}


//================================================================================
//
//================================================================================
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (self.menuViewCategoryArray == nil) {
        
        return nil;
    }
    
    NSInteger index = [(CTPageContentViewController *)viewController index];
    
    if (self.isViewCreateMenuView) {
        
        index++;
        
        if (index == self.menuViewCategoryArray.count) {
            
            index = 0;
        }
    }
    else {
        
        index = 0;
    }
   
    CTPageContentViewController *returnContentViewController = [self viewControllerAtIndex:index];
    return returnContentViewController;

}


//================================================================================
//
//================================================================================
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    if (self.menuViewCategoryArray == nil || [self.menuViewCategoryArray count] == 0) {
        
        return 1;
    }
    
    NSInteger returnCount = self.menuViewCategoryArray.count;
    return returnCount;
}





#pragma mark - UIPageViewController Delegate
#pragma mark -
//================================================================================
//
//================================================================================
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        
        CTPageContentViewController *contentViewController = [self.pageController.viewControllers lastObject];
        contentViewController.delegate = self;
        contentViewController.dealDataModel.delegate = contentViewController; // 特別留意這個delegate，必須在這
        self.dealDataModel.currentSelectCategoryIndex =  contentViewController.index;
        [self menuViewDisply:YES index:contentViewController.index]; // 這一頁是否要顯示menuVuew
    }
}


//================================================================================
//
//================================================================================
- (void)viewController:(CTPageContentViewController *)pageContentViewController scrollTableView:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
        // scroll到底部時，不處理menuView及tabBar
        return;
    }
    
    //////////////////////////////////////////////////
    
    __weak typeof(self) weakSelf = self;
    
    if (scrollView) {
        
        if ((self.scrollViewLastContentOffsetAtY > scrollView.contentOffset.y) ||
            scrollView.contentOffset.y < - (pageContentViewController.tableView.contentInset.top - 1)) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat delta = +10;
                
                if (weakSelf.menuView.frame.origin.y < 64) {
                    
                    weakSelf.menuView.frame = CGRectMake(weakSelf.menuView.frame.origin.x,
                                                         weakSelf.menuView.frame.origin.y + delta,
                                                         weakSelf.menuView.frame.size.width,
                                                         weakSelf.menuView.frame.size.height);
                }
            } completion:^(BOOL finished) {
                

            }];
        }
        else if (self.scrollViewLastContentOffsetAtY < scrollView.contentOffset.y) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat delta = -10;
                
                if (weakSelf.menuView.frame.origin.y > 0) {
                    
                    weakSelf.menuView.frame = CGRectMake(weakSelf.menuView.frame.origin.x,
                                                         weakSelf.menuView.frame.origin.y + delta,
                                                         weakSelf.menuView.frame.size.width,
                                                         weakSelf.menuView.frame.size.height);
                }

            } completion:^(BOOL finished) {
                

                
            }];
        }
        
        self.scrollViewLastContentOffsetAtY = scrollView.contentOffset.y;
    }
    
}





#pragma mark - MenuView Delegate
#pragma mark -
//================================================================================
//
//================================================================================
- (void)endScrollingAction:(MenuView *)menu index:(NSInteger)index {

    CTPageContentViewController *goThisContentView = [self viewControllerAtIndex:index];
    goThisContentView.delegate = self;
    goThisContentView.dealDataModel.delegate = goThisContentView;
    
    UIPageViewControllerNavigationDirection direction;
    
    if (self.dealDataModel.currentSelectCategoryIndex <= index) {
        
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [self.pageController setViewControllers:@[goThisContentView]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
    [self.dealDataModel reloadDealsDataForChannelWithIndex:goThisContentView.index];
}


//================================================================================
//  當點擊同一個cell時，其功能為開/關 pullDownMenu (option)
//================================================================================
- (void)tapTheSameMenuCell:(MenuView *)menu index:(NSInteger)index {
    

}





#pragma mark - KVO
#pragma mark -
//================================================================================
// 在所指定的key變化時，做出適當的回應
//================================================================================
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    [self.dealDataModel updateDealsDataWithCategoryIndex:self.dealDataModel.currentSelectCategoryIndex];
}





#pragma mark - PageControl Private Method
#pragma mark -
//================================================================================
// 回傳index畫面
//================================================================================
- (CTPageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    CGRect pageContentViewControllerRect = CGRectMake(0,
                                                      0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
    
    CTPageContentViewController *currentPresentContentViewController = [[CTPageContentViewController alloc] initWithFrame:pageContentViewControllerRect];

//    以下的random color僅是測試用
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    [currentPresentContentViewController.view setBackgroundColor:color];
    
    if (self.isViewCreateMenuView) {
        
        currentPresentContentViewController.hasMenuViewAboveTableView = YES;
    }
    
    currentPresentContentViewController.index = index;
    
    return currentPresentContentViewController;
}





#pragma mark - MenuView Private Method
#pragma mark -
//================================================================================
//
//================================================================================
- (void)menuViewDisply:(BOOL)isShow index:(NSInteger)index {
    
    if (self.menuView) {
        
        if (isShow) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                if (self.menuView.frame.origin.y < 64) {
                    
                    self.menuView.frame = CGRectMake(self.menuView.frame.origin.x,
                                                     HEIGHT_OF_STATUSBAR + HEIGHT_OF_SCROLLMENU,
                                                     self.menuView.frame.size.width,
                                                     self.menuView.frame.size.height);
                }
            } completion:^(BOOL finished) {
                
                [self.menuView scrollingPostionWithIndex:index];
            }];
        }
        else {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                if (self.menuView.frame.origin.y > 0) {
                    
                    self.menuView.frame = CGRectMake(self.menuView.frame.origin.x,
                                                     0,
                                                     self.menuView.frame.size.width,
                                                     self.menuView.frame.size.height);
                }
            }];
        }
    }
}

@end
