//
//  DealDataModel.h
//  CTPageViewController
//
//  Created by johnny_wu on 2016/9/6.
//  Copyright © 2016年 17life. All rights reserved.
//

#import <Foundation/Foundation.h>

// CT Component

// Model

// View

// Controller

// Other


@class DealDataModel;

@protocol DealDataModelDelegate <NSObject>

@optional
- (void)dealDataModel:(DealDataModel *)dealDataModel updateDataArray:(NSMutableArray *)presentArray;

@end

@interface DealDataModel : NSObject

@property (nonatomic, assign) id<DealDataModelDelegate> delegate;
@property (nonatomic, assign) NSInteger                 currentSelectCategoryIndex;
@property (nonatomic, assign) NSString                  *channelTitle;
@property (nonatomic, retain) NSMutableArray            *categoryArray;
@property (nonatomic, retain) NSMutableArray            *dealsArray;
@property (nonatomic, retain) NSMutableArray            *presentDealsArray;





+ (instancetype)sharedInstance;

- (void)updateDealsDataWithCategoryIndex:(NSInteger)index;
- (void)updateCurrentCahnnelData;
- (void)reloadDealsDataForChannelWithIndex:(NSInteger)index;

@end
