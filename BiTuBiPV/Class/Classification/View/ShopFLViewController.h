//
//  ShopFLViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopFLViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,copy) NSString *Url;

@property (weak, nonatomic) IBOutlet UITextView *txtView;

- (IBAction)butAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *txtbut;

- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *nav;


@end
