//
//  DealDataModel.m
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright © 2016年 17life. All rights reserved.
//

#import "DealDataModel.h"

// CT Component

// Model

// View

// Controller

// Other

@interface DealDataModel ()

@end


@implementation DealDataModel

#pragma mark - Class Method
#pragma mark -
//================================================================================
//
//================================================================================
+ (instancetype)sharedInstance
{
    static id sharedInstance;
    
    @synchronized(self) {
        
        if (sharedInstance == nil) {
            
            sharedInstance = [self new];
        }
    }
    
    return sharedInstance;
}


//================================================================================
//
//================================================================================
- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}





#pragma mark - Private Method
#pragma mark - 
//================================================================================
//
//================================================================================
- (void)updateCurrentCahnnelData {
    
    self.channelTitle = @"testingPage";
    _categoryArray = [self categoryArrayFromAPI];
}


//================================================================================
//
//================================================================================
- (void)reloadDealsDataForChannelWithIndex:(NSInteger)index {
    
    //////////////////////////////////////////////////
    // 取得所有的資料條件才進行取得詳細列表的動作
    
    self.currentSelectCategoryIndex = index;
}


//================================================================================
//
//================================================================================
- (NSString *)titleStringFromAPI {
    
    NSString *returnString = @"17Life Channel";
    return returnString;
}


//================================================================================
//
//================================================================================
- (NSMutableArray *)dealsArrayFromAPI {
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    NSString *pageTitleString = @"contentDisplay_";
    
    for (NSInteger i = 0; i < 50; i++) {
        
        NSString *assignPageTitleString = [NSString stringWithFormat:@"%@%ld", pageTitleString, (long)i];
        [returnArray addObject:assignPageTitleString];
    }
    return returnArray;
}


//================================================================================
//
//================================================================================
- (NSMutableArray *)categoryArrayFromAPI {
    
    NSMutableArray *returnArray = [NSMutableArray array];

    NSString *pageTitleString = @"pageDisplay_0";
    
    for (NSInteger i = 0; i < 10; i++) {
        
        NSString *assignPageTitleString = [NSString stringWithFormat:@"%@%ld", pageTitleString, (long)i];
        [returnArray addObject:assignPageTitleString];
    }
    return returnArray;
}


//================================================================================
//
//================================================================================
- (void)updateDealsDataWithCategoryIndex:(NSInteger)index {
    
    [self updatePresentDealsArrayWithCategoryIndex:index];
}


//================================================================================
//
//================================================================================
- (void)updatePresentDealsArrayWithCategoryIndex:(NSInteger)index {
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    returnArray = [self dealsArrayFromAPI];
    
    self.presentDealsArray = [returnArray copy];
    
    if (self.presentDealsArray != nil && [self.presentDealsArray count] > 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dealDataModel:updateDataArray:)]) {
            
            [self.delegate dealDataModel:self updateDataArray:self.presentDealsArray];
        }
    }
}

@end
