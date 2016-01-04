//
//  SPInfoViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/26.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPInfoViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,copy) NSString *Url;

- (IBAction)FHAction:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *nav;

@end
