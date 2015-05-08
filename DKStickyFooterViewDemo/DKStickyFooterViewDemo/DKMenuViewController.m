//
//  DKMenuViewController.m
//  DKStickyFooterViewDemo
//
//  Created by ZhangAo on 15/5/8.
//  Copyright (c) 2015年 ZhangAo. All rights reserved.
//

#import "DKMenuViewController.h"
#import "DKStickyFooterView.h"

@interface DKMenuViewController ()

@end

@implementation DKMenuViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DKStickyFooterView *footerView = [[DKStickyFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    footerView.layer.zPosition = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:footerView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"This is a footer";
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [footerView addSubview:label];
    
    [self.tableView addSubview:footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
