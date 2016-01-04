//
//  ShopJSViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/4.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopJSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)Fanhui:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@property (weak, nonatomic) IBOutlet UILabel *zje;

- (IBAction)tijiaodd:(id)sender;

@property(nonatomic,strong) NSString *shbz;//收获备注

@property (nonatomic,strong) NSArray *sku_id;

@property (nonatomic,strong) NSArray *number;

@property(nonatomic, strong)NSMutableArray *productList;

@property (weak, nonatomic) IBOutlet UIButton *tjbut;

@end
