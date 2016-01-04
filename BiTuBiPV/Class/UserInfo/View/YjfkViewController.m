//
//  YjfkViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/14.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "YjfkViewController.h"

#import "AFNetworking.h"

@interface YjfkViewController ()<UITextViewDelegate>

@end

@implementation YjfkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textfd.layer.borderColor = BTBColor(153, 153, 153).CGColor;
    self.textfd.layer.cornerRadius = 8.0;
    self.textfd.layer.borderWidth = 1.0;
    self.textfd.backgroundColor = BTBColor(255, 255, 255);
    self.textfd.text = @"请输入宝贵意见";
    self.textfd.textColor = [UIColor grayColor];
    self.textfd.delegate = self;
    
    self.view.backgroundColor = BTBColor(247, 247, 247);
}

//点击键盘以外的地方取消键盘的第一响应者
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.textfd isExclusiveTouch]) {
        [self.textfd resignFirstResponder];
    }
}

- (IBAction)FanHui:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fs:(id)sender {
//    NSLog(@"%@",self.textfd.text);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_feedback];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:self.textfd.text forKey:@"question"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.text = @"";
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}
@end
