//
//  Common.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#ifndef BiTuBiPV_Common_h
#define BiTuBiPV_Common_h

#import "UIViewExt.h" //全局布局变量类

#import "BaseMd5.h" //全局用户登陆信息

#define BTBWidth  [UIScreen mainScreen].bounds.size.width    // 屏幕宽度
#define BTBHeight [UIScreen mainScreen].bounds.size.height   // 屏幕高度
#define BTBTabBarheight 49                                   // 标签视图高度
#define BTBNavigationBarHeight 64                            // 导航视图高度

#define BTBUrl @"http://h5.feelee.cc/"                  // 上线地址

#define flash_login @"api/login"                             // 短信验证
#define flash_login_check @"api/check_login"                 // 验证码验证
#define flash_article_list @"api/article_list"               // 常见问题

#define BTB_Get_default_DZ @"api/get_default_address"        // 获取默认地址
#define BTB_PostDZ @"api/address_list"                       // 获取用户地址
#define BTB_AddDZ @"api/address_add"                         // 添加地址
#define BTB_XGDZ @"api/address_save"                         // 修改地址
#define BTB_DelDZ @"api/address_del"                         // 删除地址
#define BTB_Default @"api/address_default"                   // 修改默认地址

#define BTB_Pay @"api/pay"                                   // 生成订单
#define BTB_order_act @"api/order_act"                       // 提交订单
#define BTB_success @"api/success"                           // 订单成功
#define BTB_order @"api/my_order"                            // 我的订单
#define BTB_order_detail @"api/order_detail"                 // 订单详情
#define BTB_cancel_order @"api/cancel_order"                 // 取消订单

#define BTB_Coupon @"api/coupon"                             // 得到优惠劵
#define BTB_coupon_count @"api/coupon_count"                 // 获取优惠卷数量

#define BTB_feedback @"api/feedback"                         // 投书建议接口 意见反馈type==1 投诉建议type==0
#define BTB_complaint @"api/complaint"                       // 投诉类型

#define BTB_logistics @"api/logistics"                       // 物流消息

#define BTB_edit_nick @"api/edit_nick"                       // 编辑昵称

#define BTB_get_user_info @"api/get_user_info"               // 获取用户信息
#define BTB_set_user_info @"api/set_user_info"               //修改用户信息

#define BTB_favorite_list @"api/favorite_list"               // 我的关注

#define BTB_message_list @"api/message_list"                 // 消息中心（主页面）

#define BTB_Home @"http://h5.feelee.cc/"                // 主页
#define BTB_Category_list @"http://h5.feelee.cc/Goods/category_list"       //分类页面
#define BTB_Select_list @"Goods/lists?q="     //  按商品名称查询
#define BTB_ShopInfo @"http://h5.feelee.cc/Goods/sku"    // 商品详情（按商品id查询）

#define BTB_wx_orderquery @"api/wx_orderquery"                // 检查服务器是否收到

#define BTBBanDouID @"Api/check_update_for_ios"               // 检查版本

#define BTB_partner @"2088612871263400"
#define BTB_seller @"kequankeji@163.com"
#define BTB_privateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMvVOdI5eXXdyarEREhPkmCQzOIM4OEcLSY0H4LgRQy8gcO7K4rMKI64IT/TN5mf06UsST6RfhLzecr+c+hhxl3mDgDJ0Ql6/4Q1jmAMyafJznt3eH7z2IVNIHcbG5bLYmKZbEn2SYzMazFJd0l18Pa1A+NXAQt+1Ekl7QuzInGFAgMBAAECgYA9NWqHlnrCyjck8IsQq9Ro6xKbTwK4lp14O266/l291V2iSTJqG6SSNvjFEchAeZ40m3fjMg2J41NPgdmMjs/iGTFn3gyfLpL3o9bqpqyGRd8Pf6b/7iUChvxoqkdebza7fbkGv0UcyL6kN0+UWthAdzK139YGCPyD3HZVEy9kAQJBAPDCLTCO7fXU9C4X250r9vxjzoKKXuWh6//rWxwb4qOPaNhAvuQmxsWs3s0rolNA1i45Y7gzTS+fvZ/Z65/t890CQQDYvJ6IV19u3k5hL5CJ9IVFpYGutK/OdhHcai/ju71vj9GHCwRNgbtwiHS/42+jJf1cFUFbNvsYpFoUgt8Dvs3JAkBg3rASBqBGNl3dIepSLftdh8byjTwrhuAPA6KQB8RD7RLRWBO2dseph6nJwZG5j6/dv2eZGMMos0w3whXlLnfdAkEAr9WuxCwmZ3sBmcUN/W4cZVmV8VfzvYt6iBi6C4c3c/f45BdjAUJ8ABskpLzuyCy89OTlpgvgAKjtz/Aw4Af/SQJAaoLSnMcfvul3gQNJb7nkDx4VKZgw56cAfknosTeCsTuSyPyPRU+aZ9VHfTGzdj982N+VnJLJYg3mGQPVmcSGGw=="



#endif
