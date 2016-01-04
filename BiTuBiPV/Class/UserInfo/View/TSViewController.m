//
//  TSViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/14.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "TSViewController.h"

#import "AFNetworking.h"

@interface TSViewController ()<UITextViewDelegate>
{
    NSArray *DataArr;
    
    NSArray *PostArr;
}
@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据加载
    [self _loadData];
    
   
}

//加载数据
-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_complaint];
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        DataArr = dicss[@"list"];
        
        //设置button
        [self _loadView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *arl = [[UIAlertView alloc] initWithTitle:@"警告" message:@"亲，您的网络未连接喔！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [arl show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

//视图设置
-(void)_loadView{
    self.headView.backgroundColor = BTBColor(255, 255, 255);
    
    self.view.backgroundColor  = BTBColor(247, 247, 247);
    //    BTB_complaint
    
    self.mytext.layer.borderColor = BTBColor(153, 153, 153).CGColor;
    self.mytext.layer.borderWidth = 1.0;
    self.mytext.backgroundColor = BTBColor(228, 228, 228);
    self.mytext.layer.cornerRadius = 16.0;
    self.mytext.text = @"请输入投诉的具体问题（限300字）";
    self.mytext.delegate = self;
    self.mytext.textColor = [UIColor grayColor];
    self.rjbut.backgroundColor = BTBColor(255, 173, 0);
    
    self.butview.backgroundColor = BTBColor(247, 247, 247);
    for (int i = 0; i < 6; i ++) {
        if (i < 3) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.butview.frame.size.width / 3) * i + 5 + (5 * i), 10, self.butview.frame.size.width / 4, (self.butview.frame.size.height / 2) - 21)];
            button.layer.cornerRadius = 8.0;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = BTBColor(234, 234, 234).CGColor;
            [button setTitle:DataArr[i][@"name"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.tag = [DataArr[i][@"id"] integerValue];
            [button addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (button.selected == NO) {
                button.backgroundColor = BTBColor(247, 247, 247);
            }else{
                button.backgroundColor = BTBColor(51, 51, 51);
            }
            [self.butview addSubview:button];
        }else{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.butview.frame.size.width / 3) * (i - 3) + 5 + (5 * (i - 3)), (self.butview.frame.size.height / 2) - 21 + (10 * 2), self.butview.frame.size.width / 4, (self.butview.frame.size.height / 2) - 21)];
            button.layer.cornerRadius = 8.0;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = BTBColor(234, 234, 234).CGColor;
            [button setTitle:DataArr[i][@"name"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.tag = [DataArr[i][@"id"] integerValue];
            [button addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (button.selected == NO) {
                button.backgroundColor = BTBColor(247, 247, 247);
            }else{
                button.backgroundColor = BTBColor(51, 51, 51);
            }
            [self.butview addSubview:button];
        }
    }

}

-(void)BtnAction:(UIButton *)btn{
//    NSLog(@"%ld",btn.tag);
    btn.selected = ! btn.selected;
    if (btn.selected == NO) {
        btn.backgroundColor = BTBColor(247, 247, 247);
    }else{
        btn.backgroundColor = BTBColor(15, 15, 15);
    }
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)open:(id)sender {
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 1; i < 7; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        if (button.selected == YES) {
            [marr addObject:[NSString stringWithFormat:@"%ld",button.tag]];
        }
    }
    //    NSLog(@"%@",self.textfd.text);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_feedback];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:@"0" forKey:@"type"];
    [dic setObject:self.mytext.text forKey:@"question"];
    [dic setObject:marr forKey:@"category_id"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];}

//点击键盘以外的地方取消键盘的第一响应者
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.mytext isExclusiveTouch]) {
        [self.mytext resignFirstResponder];
    }
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
