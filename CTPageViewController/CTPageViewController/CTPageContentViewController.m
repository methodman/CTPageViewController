//
//  CTPageContentViewController.m
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import "CTPageContentViewController.h"

// CT Component

// Model

// View

// Controller

// Other

@interface CTPageContentViewController ()

@end

@implementation CTPageContentViewController





#pragma mark - Init & Dealloc
#pragma mark -
//================================================================================
//
//================================================================================
- (id)initWithFrame:(CGRect)rect {
    
    if (self = [super init]) {
        
        self.view.frame = rect;
        _currentFrameRect = self.view.frame;
    }
    return self;
}


//================================================================================
//
//================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}


//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    
    _dealDataModel = [DealDataModel sharedInstance];
}





#pragma mark - UITableView Datasource
#pragma mark -
//================================================================================
//
//================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


//================================================================================
//
//================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger returnCount = 0;
    
    if (self.dealDataModel.presentDealsArray && [self.dealDataModel.presentDealsArray count] > 0) {
        
        returnCount = [self.dealDataModel.presentDealsArray count];
    }
    
    return returnCount;
}


//================================================================================
//
//================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"testCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = (NSString *)[self.dealDataModel.presentDealsArray objectAtIndex:indexPath.row];
    return cell;
}





#pragma mark - UITableView Delegate
#pragma mark -
//================================================================================
//
//================================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat returnHeight = 80;
    return returnHeight;
}





#pragma mark - UIScrollViewDelegate Methods
#pragma mark -
//================================================================================
//
//================================================================================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerBeginScrollTableView:)]) {
        
        [self.delegate viewControllerBeginScrollTableView:scrollView];
    }
}


//================================================================================
//
//================================================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerEndScrollTableView:)]) {
        
        [self.delegate viewControllerEndScrollTableView:scrollView];
    }
}


//================================================================================
//
//================================================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:scrollTableView:)]) {
        
        [self.delegate viewController:self scrollTableView:scrollView];
    }
}





#pragma mark - CTPageContentViewController Private
#pragma mark -
//================================================================================
// 更新目前應呈現的檔次陣列
//================================================================================
- (void)dealDataModel:(DealDataModel *)dealDataModel updateDataArray:(NSMutableArray *)presentArray {
    
    if (presentArray != nil) {
        
       [self createTableViewWithPresentArray:presentArray];
    }
}


//================================================================================
// 使用應呈現的檔次陣列產生tableView
//================================================================================
- (void)createTableViewWithPresentArray:(NSMutableArray *)presentArray {

    if (self.refreshControl.isRefreshing) {
        
        [self.refreshControl endRefreshing];
    }
    
    if (self.dealDataModel.categoryArray != nil && [self.dealDataModel.categoryArray count] > 0) {
        
        self.hasMenuViewAboveTableView = YES;
    }
    
    if (presentArray != nil) {
        
        if (_tableView == nil) {
            
            CGFloat topSpace =  HEIGHT_OF_STATUSBAR + HEIGHT_OF_SCROLLMENU + self.view.frame.origin.y + HEIGHT_OF_MENUVIEW_SHADOW;

            if (self.hasMenuViewAboveTableView) {
                
                self.currentFrameRect = CGRectMake(self.currentFrameRect.origin.x,
                                                   self.currentFrameRect.origin.y + HEIGHT_OF_SCROLLMENU - HEIGHT_OF_MENUVIEW_SHADOW,
                                                   self.currentFrameRect.size.width,
                                                   self.currentFrameRect.size.height - HEIGHT_OF_SCROLLMENU + HEIGHT_OF_MENUVIEW_SHADOW
                                                   );
            }
            
            //////////////////////////////////////////////////
            
            _tableView = [[UITableView alloc] initWithFrame:self.currentFrameRect
                                                      style:UITableViewStylePlain];
            //[self.tableView setBackgroundColor:[UIColor colorWithRed: 242.0 / 255.0 green: 242.0 / 255.0 blue: 242.0 / 255.0 alpha: 1.0]];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView registerNib:[UINib nibWithNibName:@"PDealSynopsesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PDealSynopsesCell"];
            [self.tableView registerNib:[UINib nibWithNibName:@"PponDeliveryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PponDeliveryCell"];
            [self.tableView registerNib:[UINib nibWithNibName:@"CurationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CurationTableViewCell"];
            
            if (self.hasMenuViewAboveTableView) {
                
                [self.tableView setContentInset:UIEdgeInsetsMake(topSpace, 0, 0, 0)];
                [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(topSpace, 0, 0, 0)];
            }
            else {
                
                [self.tableView setContentInset:UIEdgeInsetsMake(topSpace, 0, topSpace, 0)];
                [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(topSpace, 0, topSpace, 0)];
            }
            
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.view addSubview: self.tableView];
            [self.tableView reloadData];
            
            //////////////////////////////////////////////////
            
            _refreshControl = [[UIRefreshControl alloc]init];
            [self.tableView addSubview:self.refreshControl];
        
            //////////////////////////////////////////////////
            
            [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        }
        else {
            
            [self.tableView reloadData];
        }
    }
}





#pragma mark - Get Data
#pragma mark -
//================================================================================
//
//================================================================================
- (void)refresh
{
    self.dealDataModel.currentSelectCategoryIndex = self.index;
}

@end
