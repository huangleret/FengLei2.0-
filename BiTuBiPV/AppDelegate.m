//
//  AppDelegate.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>

#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"

#import "AFNetworking.h"

#import "DDInfoViewController.h"

#import "LaunchViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "IQKeyboardManager.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    NSString *urlString;
}
//什么时候 一定用到这个对象 也就是当我们调用getter的时候
@property(nonatomic, strong) CLLocationManager * manager;

//用来做地理编码和反地理编码的类
@property(nonatomic, strong) CLGeocoder * geocoder;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //检查版本更新
    [self banbengx];
    
    //启用键盘管理库
    IQKeyboardManager *boardMamger = [IQKeyboardManager sharedManager]; //初始化键盘管理库
    boardMamger.enable = YES;   //enable控制整个功能是否启用。
    boardMamger.shouldResignOnTouchOutside = YES;   //shouldResignOnTouchOutside控制点击背景是否收起键盘。
    boardMamger.shouldToolbarUsesTextFieldTintColor = YES;  //shouldToolbarUsesTextFieldTintColor 控制键盘上的工具条文字颜色是否用户自定义。
    boardMamger.enableAutoToolbar = NO; //enableAutoToolbar控制是否显示键盘上的工具条。
    
    // 取出数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [[userDefault valueForKey:@"Guide"] boolValue];
    
    //    NSLog(@"%d",flag);
    // 如果存在数据，调用主控制器，否则调用引导页面
    if (flag) {
        
        //进入主页面
        //1.拿到故事版(Storyboard)
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //2.获取Storyboard里面的主控制器
        UIViewController *mainVc = [story instantiateInitialViewController];
        
        self.window.rootViewController = mainVc;
        
    }else {
        
        //进入欢迎页面
        LaunchViewController *LaunchVc= [[LaunchViewController alloc]init];
        self.window.rootViewController = LaunchVc;
        [LaunchVc reloadInputViews];
        
    }
    
    //向微信注册
    BOOL isOK = [WXApi registerApp:@"wx25d4918185b2d144"];
    if (isOK) {
//        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信注册成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alt show];
    }else{
//        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信注册失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alt show];
    }
    
    //地理编码
    [self dilibianma];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 跳转到URL scheme中配置的地址
    NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    return [WXApi handleOpenURL:url delegate:self];
}

//检测版本更新
-(void)banbengx{
    //获取当前app的版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *label = [NSString stringWithFormat:@"%@", version];
    
    //打印当前版本号
    //    NSLog(@"%@",label);
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTBBanDouID];
//    NSLog(@"string : %@",string);
    
    //3.请求参数（放到字典中）
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"version"] = label;
    NSLog(@"%@",label);
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager GET:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        NSDictionary *dic = responseObject;
//        NSLog(@"%@",responseObject);
        if ([dic[@"is_must"] isEqualToString:@"0"] && [dic[@"is_need_update"] isEqualToString:@"1"]) {
            
//            NSLog(@"可以更新");
            UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"发现有新版本，是否升级？"] delegate:self cancelButtonTitle:@"马上升级" otherButtonTitles:@"暂不升级", nil];
            urlString = dic[@"url"];
            [alertview show];
        }else if([dic[@"is_must"] isEqualToString:@"1"] && [dic[@"is_need_update"] isEqualToString:@"1"]){
//            NSLog(@"强制更新");
            UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"发现有新版本，是否升级？"] delegate:self cancelButtonTitle:@"马上升级" otherButtonTitles:nil];
            urlString = dic[@"url"];
            [alertview show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        NSLog(@"error : %@", error);
        return;
        
    }];
    
}

//版本升级
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:urlString]];
    }
}

//（2）跳转处理
//实现分享跳转页面
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    NSLog(@"1url = %@   [url host] = %@",url,[url host]);
    
    if(url != nil && [[url host] isEqualToString:@"pay"]){
        //微信支付
//        NSLog(@"微信支付");
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        //其他
        return YES;
    }

}

// 3.支付结果回调
- (void)onResp:(BaseResp *)resp
{
//    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收到回调" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alt show];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        // 4.支付返回结果，实际支付结果需要去自己的服务器端查询  由于demo的局限性这里直接使用返回的结果
        strTitle = [NSString stringWithFormat:@"支付结果"];
        // 返回码参考：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_12
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION"object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:strTitle message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSLog(@"知道了");
    }];
    [alert addAction:action];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    NSLog(@"title = %@ message = %@", strTitle, strMsg);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //支付宝部分
    //跳转支付宝钱包进行支付，处理支付结果
//    [self _loadALert:@"回调了1"];
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self _loadALert:resultDic[@"result"]];
    }];
    NSLog(@"2url = %@   [url host] = %@",url,[url host]);
    
    if(url != nil && [[url host] isEqualToString:@"pay"]){//微信支付
//        NSLog(@"微信支付");
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{//其他
        return YES;
    }
}

//收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
//- (void)onResp:(BaseResp *)resp
//{
//    if ([resp isKindOfClass:[PayResp class]])
//    {
//        PayResp *response = (PayResp *)resp;
//        
//        //        NSLog(@"支付结果 %d===%@",response.errCode,response.errStr);
//        
//        switch (response.errCode) {
//            case WXSuccess: {
//                
//                NSLog(@"支付成功");
//                
//                //...支付成功相应的处理，跳转界面等
//                
//                break;
//            }
//            case WXErrCodeUserCancel: {
//                
//                NSLog(@"用户取消支付");
//                
//                //...支付取消相应的处理
//                
//                break;
//            }
//            default: {
//                
//                NSLog(@"支付失败");
//                
//                //...做相应的处理，重新支付或删除支付
//                
//                break;
//            }
//        }
//    }
//    
//}

#pragma mark - 获取当前地理位置

//懒加载创建 地理编码对象，
- (CLGeocoder *)geocoder{
    
    if (_geocoder == nil) {
        
        _geocoder = [[CLGeocoder alloc]init];
    }
    
    
    return _geocoder;
}

//懒加载创建对象
- (CLLocationManager *)manager{
    
    
    //如果对象为空，我们就创建， 如果不为空，那么就直接返回。
    if (_manager == nil) {
        
        _manager = [[CLLocationManager alloc]init];
    }
    
    return _manager;
}

-(void)dilibianma{
    //向系统要求授权分为两方面：（1）位置管理者 向系统申请  （2）info.plist里面加上一个key
    //iOS8才需要
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        //前台授权， 只有在前台的时候，才获取用户位置
        //仅仅这样写，没有效果，要配合info.plist中的key来使用
        [self.manager requestWhenInUseAuthorization];
        
        //前台后台都授权， 应用程序能始终获取到用户设备的地理位置
        //[self.manager requestAlwaysAuthorization];
    }
    
    //可以通过manager设置一个 回去设备位置的 过滤条件
    //小余你设置的米数的话， 代理就不接受 位置信息更新的通知
    self.manager.distanceFilter = 3000;
    
    //设置精确度
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    
    //2.设置代理，利用协议方法， 把获取到的用户信息传递给对应的类
    self.manager.delegate = self;
    
    //3.开始监听位置，
    [self.manager startUpdatingLocation];
    
}

//这个方法获取用户设备的位置，是一直调用的，也就是说，它不间断 一直在获取用户的位置。
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *jwd = [locations lastObject];
    
    CLLocationCoordinate2D cool = jwd.coordinate;
    
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    
    //停掉位置更新
    [self.manager stopUpdatingLocation];
    
    //    NSLog(@"%.4f,-%.4f",cool.latitude,cool.longitude);
    //    NSLog(@"%.4f",cool.longitude);
    //通过给定经纬度创建地理位置对象
    CLLocation * location = [[CLLocation alloc]initWithLatitude:cool.latitude longitude:cool.longitude];
    
    //参数一： 是一个地理位置对象，这个对象中包含有经纬度， 通过这个经纬度进行反地理编码获取 地名
    //参数二： 反地理编码结束之后的回调。 如果反地理编码成功，会把编码到的值，存在地标对象中，
    //如果反地理编码失败，那么error中会有值，不再是nil
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        if (error != nil ) {
            
            NSLog(@"错误: %@", error);
            
            return;
        }
        
        CLPlacemark * mark = [placemarks firstObject];
        //name属性 是指 街区地址
        //locality是指这个城市名字
        //地址字典中 有非常多位置信息（国家，城市，街区）
        
        //        NSLog(@"地址字典： %@, 名字： %@,  城市：%@", mark.addressDictionary, mark.name, mark.locality);
        UserModel *umodel = [[UserModel  alloc] init];
        [umodel saveDZ:mark.locality];
//        NSLog(@"123%@",mark.locality);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"后台转前台");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "bitubit.BiTuBiPV" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BiTuBiPV" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BiTuBiPV.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//弹出框
-(void)_loadALert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

+(void)tiaozhuan{
    //    NSLog(@"点击了");
    //1.拿到故事版(Storyboard)
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //2.获取Storyboard里面的主控制器
    UIViewController *mainVc = [story instantiateInitialViewController];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = mainVc;
//    self.window.rootViewController = mainVc;
}
@end
