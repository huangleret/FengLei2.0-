//
//  ShopInfoViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/30.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopInfoViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,copy) NSString *Url;

- (IBAction)FHAction:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *nav;


@property(nonatomic,copy) NSString *gid;

@end
