//
//  NewDiZiViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "NewDiZiViewController.h"

#import "AddDZTableViewCell.h"

#import "AddDZSexTableViewCell.h"

#import "DzData.h"

#import "AFNetworking.h"

@interface NewDiZiViewController ()
{
    NSArray * Label;
    
    NSArray * mytext;
    
    UIView *pikview;
    
    NSArray *dq;
    
    NSArray *dqq;
    
    UIButton *qd;
}
@end

@implementation NewDiZiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadpickerView];

    Label = @[@"联系人",@"",@"手机号码",@"所在城市",@"详细地址"];
    
    mytext = @[@"收货人姓名",@"",@"蜂雷联系您的电话",@"请选择城市",@"详细地址",@"请输入楼号门牌号等详细信息"];
    
    dq = @[@"屯溪区",@"黄山区",@"徽州区",@"歙县",@"休宁县",@"黟县",@"祁门县"];
    
    dqq = @[@"341002",@"341003",@"341004",@"341021",@"341022",@"341023",@"341024"];
    
    DzData *model = [[DzData alloc] init];
    model.accept_name = @"";
    model.phone = @"";
    model.mobile = @"";
    model.county = @"";
    model.province = @"";
    model.addr = @"";
    model.sex = @"";
    
    [self _loadTable];
}

-(void)_loadTable{
    _MyTable.delegate = self;
    _MyTable.dataSource = self;
    self.MyTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DzData *model = [[DzData alloc] init];
    AddDZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddDZTableViewCell" owner:self options:nil] lastObject];
        cell.Label.text = Label[indexPath.row];
        cell.MyText.placeholder = mytext[indexPath.row];
        cell.MyText.tag = indexPath.row;
        if (indexPath.row == 0) {
            if (![model.accept_name isEqualToString:@""]) {
                cell.MyText.text = model.accept_name;
            }
        }
        if (indexPath.row == 1) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddDZSexTableViewCell" owner:self options:nil] lastObject];
        }
        if (indexPath.row == 2) {
            if (![model.phone isEqualToString:@""]) {
                cell.MyText.text = model.phone;
            }
        }
        if (indexPath.row == 3){
//            if (![model.phone isEqualToString:@""]) {
                cell.MyText.userInteractionEnabled = NO;
//                NSInteger ins = [model.county integerValue];
                cell.MyText.placeholder = dq[1];
//            }
        }
        if (indexPath.row == 4) {
            if (![model.addr isEqualToString:@""]) {
                cell.MyText.text = model.addr;
            }

        }
    }
    return cell;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 3){
        [UIView animateWithDuration:1.0f animations:^{
            pikview.hidden = NO;
        }];
    }
}

-(void)_loadpickerView{
    pikview = [[UIView alloc] initWithFrame:CGRectMake(0, BTBHeight - 210, BTBWidth, 210)];
    pikview.backgroundColor = [UIColor whiteColor];
    pikview.layer.borderColor = [UIColor blackColor].CGColor;
    pikview.layer.borderWidth = 1.0;
    [self.view addSubview:pikview];
    
    qd = [[UIButton alloc] initWithFrame:CGRectMake(BTBWidth - 60, 5, 60, 15)];
    [qd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qd setTitle:@"确定" forState:UIControlStateNormal];
    [qd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [pikview addSubview:qd];

    //创建 --》 设置属性 --》 添加显示
    UIPickerView * picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, BTBWidth, 180)];
    picker.backgroundColor = BTBColor(209, 213, 219);
    
    //设置代理
    picker.delegate = self;
    picker.dataSource = self;
    
    pikview.hidden = YES;
    [pikview addSubview:picker];
}

-(void)YesAction:(UIButton *)btn{
    [UIView animateWithDuration:1.0f animations:^{
        pikview.hidden = YES;
    }];
    [self.MyTable reloadData];
}

//返回这个 pickerView的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

//返回 每列中有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 1;
    }else if(component == 1){
        return 1;
    }else{
        return 5;
    }
}

//返回列中 每行单元格 的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return @"安徽省";
    }else if(component == 1){
        return @"黄山市";
    }else{
        return dq[row];
    }
}

//选中哪一个列中的哪一行单元格
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    DzData *model = [[DzData alloc] init];
    model.province = @"340000";
    model.city = @"341000";
    if (component == 2 && row != 1) {
        [self _loadALert:@"派送范围仅限黄山太平城区，超区不派送，联系电话：0559-8536128"];
        [qd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        [qd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [qd addTarget:self action:@selector(YesAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //设置地区
    model.county = [NSString stringWithFormat:@"%@",@"1"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)FanHui:(id)sender {
    //5.发送通知 参数1：名称 参数2：本地 参数3：数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sx" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addData:(id)sender {
    DzData *data = [[DzData alloc] init];
//    NSLog(@"%@，%@，%@,%@,%@,%@,%@,%@",data.accept_name,data.mobile,data.phone,data.province,data.city,data.county,data.addr,data.sex);
//    NSLog(@"保存");
    BOOL phone = [self checkTel:data.phone];
    if (!phone) {
        return;
    }
    if ([data.accept_name isEqualToString:@""] || [data.mobile isEqualToString:@""] || [data.phone isEqualToString:@""] || [data.province isEqualToString:@""] || [data.county isEqualToString:@""] || [data.addr isEqualToString:@""] || [data.sex isEqualToString:@""] || data.accept_name == nil || data.mobile == nil || data.phone == nil || data.province == nil || data.county == nil || data.addr == nil || data.sex == nil) {
    
        if (data.accept_name == nil || [data.accept_name isEqualToString:@""]) {
            [self _loadALert:@"请填写收货人姓名"];
        }else if(data.sex == nil || [data.sex isEqualToString:@""]){
            [self _loadALert:@"请选择性别"];
        }else if(data.phone == nil || [data.phone isEqualToString:@""]){
            [self _loadALert:@"请填写手机号码"];
        }else if (data.addr == nil || [data.addr isEqualToString:@""]){
            [self _loadALert:@"请填写详细地址"];
        }else{
            [self _loadALert:@"请认真填写用户信息"];
        }
        
        
        
        
    }else{
        //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
        
        //1.创建 请求操作的管家对象
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        
        //2.url(不要拼接)
        NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_AddDZ];
//        NSLog(@"%@",string);
        
        //3.请求参数（放到字典中）
        
        //设置返回数据格式
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *mdic = [BaseMd5 _getData];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
        [dic setObject:data.accept_name forKey:@"accept_name"];
        [dic setObject:data.mobile forKey:@"mobile"];
        [dic setObject:data.phone forKey:@"phone"];
        [dic setObject:data.province forKey:@"province"];
        [dic setObject:data.city forKey:@"city"];
        NSInteger it = 1;
//        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",dq[it]);
        [dic setObject:dqq[it] forKey:@"county"];
        [dic setObject:data.addr forKey:@"addr"];
        [dic setObject:data.sex forKey:@"sex"];
        [dic setObject:@"1" forKey:@"is_default"];
        [dic setObject:@"242700" forKey:@"zip"];
//        NSLog(@"%@",dic);
        
        //4.请求
        [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSDictionary *dd = responseObject;
//            NSLog(@"%@",dd[@"msg"]);
            if ([dd[@"status"] isEqualToString:@"1"]) {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的输入有误，请核对您的信息后重新保存！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [al show];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"%@",error);
        }];
        
    }
}

//判断手机号
- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您的输入有误，请核对信息后再执行！", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        [self _loadALert:@"请输入正确的手机号码"];
        
        return NO;
        
    }
    
    
    
    return YES;
    
}

//弹出框
-(void)_loadALert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
@end
