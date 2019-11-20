//
//  ViewController.m
//  PYGuidViewProject
//
//  Created by 水泥座 on 2019/11/20.
//  Copyright © 2019 水泥座. All rights reserved.
//

#import "ViewController.h"
#import "PYTableViewCell.h"
#import "PYGuideView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, PYGuideViewDataSource, PYGuidViewLayoutDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PYGuideView *firstGuideView;
@property (nonatomic, strong) NSArray<PYGuideItemModel *> *guid0Array;
@property (nonatomic, strong) NSArray<PYGuideItemModel *> *guid1Array;
@property (nonatomic, assign) CGRect tradeRect;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, strong) UIView *tradeDescriptionView;
@property (nonatomic, strong) UIView *scanDescriptionView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)btnAction:(UIButton *)button {
    [self showGuidView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PYTableViewCell"];
    if (cell == nil) {
        cell = [[PYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PYTableViewCell"];
    }
    return cell;
}

#pragma mark - PYGuideViewDataSource
- (NSInteger)numberOfSectionsInGuideView:(PYGuideView *)guideView {
    return 2;
}

- (NSArray<PYGuideItemModel *> *)guideView:(PYGuideView *)guideView modelsAtSection:(NSInteger)section {
    if (section == 0) {
        return self.guid0Array;
    } else {
        return self.guid1Array;
    }
}

- (UIView *)guideView:(PYGuideView *)guideView descriptionViewInSection:(NSInteger)section {
    if (section == 0) {
        return self.tradeDescriptionView;
    } else {
        return self.scanDescriptionView;
    }
}

#pragma mark - PYGuidViewLayoutDelegate
- (CGFloat)guideView:(PYGuideView *)guideView cornerRadiusForItemAtSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 10;
    }
}

- (UIEdgeInsets)guideView:(PYGuideView *)guideView insetsForItemAtSection:(NSInteger)section {
    if (section == 0 ) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
        return UIEdgeInsetsMake(-5, -5, -5, -5);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PYTableViewCell class] forCellReuseIdentifier:@"PYTableViewCell"];
        _tableView.rowHeight = 120;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (PYGuideView *)firstGuideView {
    if (_firstGuideView == nil) {
        _firstGuideView = [[PYGuideView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _firstGuideView.dataSource = self;
        _firstGuideView.delegate = self;
    }
    return _firstGuideView;
}

- (void)showGuidView {
    // 第一组
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGRect inCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect cellRect = [self.tableView convertRect:inCellRect toView:[UIApplication sharedApplication].keyWindow];
    self.tradeRect = cellRect;
    
    PYGuideItemModel *model00 = [PYGuideItemModel new];
    model00.rect = cellRect;
    self.guid0Array = @[model00];
    
    // 第二组
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
    CGRect inCellRect1 = [self.tableView rectForRowAtIndexPath:indexPath1];
    CGRect cellRect1 = [self.tableView convertRect:inCellRect1 toView:[UIApplication sharedApplication].keyWindow];
    
    // 计算两个紫色的视图距离屏幕的相对rect(具体位置和计算可以进去cell里查看)
    CGRect dot1Rect = CGRectMake(30, cellRect1.origin.y + 15 + 20, 60, 60);
    CGRect dot2Rect = CGRectMake(15 + 100, cellRect1.origin.y + 15 + 20, 60, 60);
    
    self.scanRect = dot1Rect;
    PYGuideItemModel *model10 = [PYGuideItemModel new];
    model10.rect = dot1Rect;
    
    PYGuideItemModel *model11 = [PYGuideItemModel new];
    model11.rect = dot2Rect;
    
    self.guid1Array = @[model10, model11];
    [self.firstGuideView show];
}

- (UIView *)tradeDescriptionView {
    if (!_tradeDescriptionView) {
        _tradeDescriptionView = [UIView new];
        _tradeDescriptionView.backgroundColor = [UIColor clearColor];
        _tradeDescriptionView.frame = CGRectMake(0, CGRectGetMaxY(self.tradeRect), [UIScreen mainScreen].bounds.size.width, 100);
        
        // 说明
        UIImageView *explainImgV = [UIImageView new];
        [_tradeDescriptionView addSubview:explainImgV];
        explainImgV.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 191) / 2.0, 14, 191, 27);
        explainImgV.image = [UIImage imageNamed:@"guid_text"];
        
        // 按钮
        UIImageView *okBtn = [UIImageView new];
        [_tradeDescriptionView addSubview:okBtn];
        okBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 101) / 2.0, CGRectGetMaxY(explainImgV.frame) + 11, 101, 35);
        okBtn.userInteractionEnabled = YES;
        okBtn.image = [UIImage imageNamed:@"guid_btn_ok"];
    }
    return _tradeDescriptionView;
}

- (UIView *)scanDescriptionView {
    if (!_scanDescriptionView) {
        _scanDescriptionView = [UIView new];
        _scanDescriptionView.backgroundColor = [UIColor clearColor];
        _scanDescriptionView.frame = CGRectMake(0, CGRectGetMaxY(self.scanRect), [UIScreen mainScreen].bounds.size.width, 100);
        
        // 说明
        UIImageView *explainImgV = [UIImageView new];
        [_scanDescriptionView addSubview:explainImgV];
        explainImgV.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 191) / 2.0 - 30, 14, 191, 27);
        explainImgV.image = [UIImage imageNamed:@"guid_text"];
        
        // 按钮
        UIImageView *okBtn = [UIImageView new];
        [_scanDescriptionView addSubview:okBtn];
        okBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 101) / 2.0 - 30, CGRectGetMaxY(explainImgV.frame) + 11, 101, 35);
        okBtn.userInteractionEnabled = YES;
        okBtn.image = [UIImage imageNamed:@"guid_btn_ok"];
    }
    return _scanDescriptionView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 30, [UIScreen mainScreen].bounds.size.width - 30, 40);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"开始显示" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [_footerView addSubview:btn];
    }
    return _footerView;
}


@end
