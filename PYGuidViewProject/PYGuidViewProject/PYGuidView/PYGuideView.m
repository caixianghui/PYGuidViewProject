//
//  PYGuidView.m
//  PYGuidViewProject
//
//  Created by 水泥座 on 2019/11/20.
//  Copyright © 2019 水泥座. All rights reserved.
//

#import "PYGuideView.h"

@implementation PYGuideItemModel

@end

@interface PYGuideView()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) UIView *currentDescriptionView;

@end

@implementation PYGuideView {
    NSInteger _countSection; //记录总组数
}

#pragma mark - 懒加载
- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer)
    {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}

- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _maskView;
}

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    /// 添加子视图
    [self addSubview:self.maskView];
    
    /// 设置默认数据
    self.backgroundColor     = [UIColor clearColor];
    self.maskBackgroundColor = [UIColor blackColor];
    self.maskAlpha  = .7f;
}

- (void)setMaskBackgroundColor:(UIColor *)maskBackgroundColor
{
    _maskBackgroundColor = maskBackgroundColor;
    self.maskView.backgroundColor = maskBackgroundColor;
}

- (void)setMaskAlpha:(CGFloat)maskAlpha
{
    _maskAlpha = maskAlpha;
    self.maskView.alpha = maskAlpha;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.currentDescriptionView removeFromSuperview];
    [self showMask];
    [self configureItemsFrame];
}

#pragma mark - Privite Method
/**
 *  显示蒙板
 */
- (void)showMask
{
    CGPathRef fromPath = self.maskLayer.path;
    
    /// 更新 maskLayer 的 尺寸
    self.maskLayer.frame = self.bounds;
    self.maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGFloat maskCornerRadius = 5;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideView:cornerRadiusForItemAtSection:)]) {
        maskCornerRadius = [self.delegate guideView:self cornerRadiusForItemAtSection:self.currentIndex];
    }
    /// 获取终点路径
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.bounds];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(guideView:modelsAtSection:)]) {
        NSArray *items = [self.dataSource guideView:self modelsAtSection:self.currentIndex];
        for (int i = 0; i < items.count; i++) {
            /// 获取可见区域的路径(开始路径)
            UIBezierPath *visualPath = [UIBezierPath bezierPathWithRoundedRect:[self obtainVisualFrameWithModel:items[i]] cornerRadius:maskCornerRadius];
            [toPath appendPath:visualPath];
        }
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(guideView:descriptionViewInSection:)]) {
        self.currentDescriptionView = [self.dataSource guideView:self descriptionViewInSection:self.currentIndex];
        [[UIApplication sharedApplication].keyWindow addSubview:self.currentDescriptionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.currentDescriptionView addGestureRecognizer:tap];
    }
    
    /// 遮罩的路径
    self.maskLayer.path = toPath.CGPath;
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = self.maskLayer;
    
    /// 开始移动动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration  = 0.3;
    anim.fromValue = (__bridge id _Nullable)(fromPath);
    anim.toValue   = (__bridge id _Nullable)(toPath.CGPath);
    [self.maskLayer addAnimation:anim forKey:NULL];
    
    if (self.currentDescriptionView) {
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.duration  = 0.3;
        opacityAnim.fromValue = @(0);
        opacityAnim.toValue   = @(1);
        [self.currentDescriptionView.layer addAnimation:opacityAnim forKey:NULL];
    }
}

/**
 *  设置 items 的 frame
 */
- (void)configureItemsFrame
{
    
}

/**
 *  获取可见的视图的frame
 */
- (CGRect)obtainVisualFrameWithModel:(PYGuideItemModel *)model
{
    if (self.currentIndex >= _countSection)
    {
        return CGRectZero;
    }
    CGRect visualRect = model.rect;
    
    /// 每个 item 的 view 与蒙板的边距
    UIEdgeInsets maskInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideView:insetsForItemAtSection:)]) {
        maskInsets = [self.delegate guideView:self insetsForItemAtSection:self.currentIndex];
    }
    visualRect.origin.x += maskInsets.left;
    visualRect.origin.y += maskInsets.top;
    visualRect.size.width  -= (maskInsets.left + maskInsets.right);
    visualRect.size.height -= (maskInsets.top + maskInsets.bottom);
    
    return visualRect;
}

#pragma mark - Public Method

/**
 *  显示
 */
- (void)show
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInGuideView:)])
    {
        _countSection = [self.dataSource numberOfSectionsInGuideView:self];
    }
    
    /// 如果当前没有可以显示的 item 的数量
    if (_countSection < 1)  return;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:.3f animations:^{
        
        self.alpha = 1;
    }];
    
    /// 从 0 开始进行显示
    self.currentIndex = 0;
}

#pragma mark - Action Method

/**
 *  隐藏
 */
- (void)hide
{
    [UIView animateWithDuration:.3f animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.currentDescriptionView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self nextStep];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self nextStep];
}

- (void)nextStep {
    /**
    *  如果当前下标不是最后一个，则移到下一个介绍的视图
    *  如果当前下标是最后一个，则直接返回
    */
    if (self.currentIndex < _countSection-1)
    {
        self.currentIndex ++;
    }
    else
    {
        [self hide];
    }
}


@end
