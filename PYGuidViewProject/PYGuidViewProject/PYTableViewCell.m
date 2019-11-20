//
//  PYTableViewCell.m
//  PYGuidViewProject
//
//  Created by 水泥座 on 2019/11/20.
//  Copyright © 2019 水泥座. All rights reserved.
//

#import "PYTableViewCell.h"

@implementation PYTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 200, 100)];
        self.redView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.redView];
        
        UIView *dot1 = [[UIView alloc] initWithFrame:CGRectMake(15, 20, 60, 60)];
        dot1.backgroundColor = [UIColor purpleColor];
        [self.redView addSubview:dot1];
        
        UIView *dot2 = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 60, 60)];
        dot2.backgroundColor = [UIColor purpleColor];
        [self.redView addSubview:dot2];
        
        self.greenView = [[UIView alloc] initWithFrame:CGRectMake(230, 15, 80, 60)];
        self.greenView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.greenView];
    }
    return self;
}

@end
