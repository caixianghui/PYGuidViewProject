//
//  PYGuidView.h
//  PYGuidViewProject
//
//  Created by 水泥座 on 2019/11/20.
//  Copyright © 2019 水泥座. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PYGuideView;

@interface PYGuideItemModel : NSObject

@property (nonatomic, assign) CGRect rect;          //!< 相对于window的rect

@end

@protocol PYGuideViewDataSource <NSObject>

@required

/// 多少组新手引导
/// @param guideView 新手引导页
- (NSInteger)numberOfSectionsInGuideView:(PYGuideView *)guideView;


/// 每组有多少个需要显示的
/// @param guideView 新手引导页
/// @param section 组数
- (NSArray<PYGuideItemModel *> *)guideView:(PYGuideView *)guideView modelsAtSection:(NSInteger)section;

@optional

/// 描述视图
/// @param guideView 新手引导页
/// @param section 组数
- (UIView *)guideView:(PYGuideView *)guideView descriptionViewInSection:(NSInteger)section;

@end

@protocol PYGuidViewLayoutDelegate <NSObject>

@optional
/**
 每个Item的蒙版的圆角:默认为5
 */
- (CGFloat)guideView:(PYGuideView *)guideView cornerRadiusForItemAtSection:(NSInteger)section;

/**
 每个Item与蒙版的边距:默认为(-1, -1, -1, -1)
 */
- (UIEdgeInsets)guideView:(PYGuideView *)guideView insetsForItemAtSection:(NSInteger)section;

@end

@interface PYGuideView : UIView

@property (nonatomic, strong) UIColor *maskBackgroundColor;                 //!< 背景色
@property (nonatomic, assign) CGFloat maskAlpha;                            //!< 透明度
@property (nonatomic, weak) id <PYGuideViewDataSource> dataSource;          //!< 数据源代理
@property (nonatomic, weak) id <PYGuidViewLayoutDelegate> delegate;         //!< 布局代理

- (void)show;

@end

NS_ASSUME_NONNULL_END
