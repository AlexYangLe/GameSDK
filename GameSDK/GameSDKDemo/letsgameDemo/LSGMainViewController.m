//
//  LSGMainViewController.m
//  letsgameDemo
//
//  Created by zhy on 14-5-24.
//
//

#import "LSGMainViewController.h"
#import "LetsGameAPI.h"
#import "VKBridge.h"


@interface LSGMainViewController ()

@property (nonatomic, strong) UILabel *resultLabel;

@property(nonatomic,strong) UIButton *vkActivityShareBtn;

@property(nonatomic,copy) NSString *sessionKey;
@end

@implementation LSGMainViewController

- (void)loadView {
    [super loadView];
    NSLog(@"i come in");
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 100, 30)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"测试入口" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(onClickTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    UIButton *bindtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
    bindtn.backgroundColor = [UIColor orangeColor];
    [bindtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [bindtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bindtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bindtn addTarget:self action:@selector(onLogoutTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindtn];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 160, 100, 30)];
    payBtn.backgroundColor = [UIColor orangeColor];
    [payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payBtn addTarget:self action:@selector(onPayTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    
    UIButton *iapBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 220, 100, 30)];
    iapBtn.backgroundColor = [UIColor orangeColor];
    [iapBtn setTitle:@"IAP" forState:UIControlStateNormal];
    [iapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    iapBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [iapBtn addTarget:self action:@selector(onIapTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iapBtn];

}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 90, self.view.frame.size.width, 60)];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.textColor = [UIColor redColor];
        _resultLabel.font = [UIFont systemFontOfSize:15];
        _resultLabel.numberOfLines = 4;
        _resultLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:_resultLabel];
    }
    
    return _resultLabel;
}


- (void)onClickTest {

    [LetsGameAPI instance].appId = @"100";
    [LetsGameAPI instance].appKey = @"f899139df5e1059396431415e770c6dd";
    [LetsGameAPI instance].channelId = @"1000";
    [LetsGameAPI hiddenLogo:YES];
    NSLog(@"sdk version:%@",[[LetsGameAPI instance] version]);
    //sdk login 初始化
    [[LetsGameAPI instance] SDKLoginInitofResponse:^(BOOL result) {
        if (result) {
            NSLog(@"初始化成功");
            //    [LetsGameAPI disableFB:YES];
            //    [LetsGameAPI disableGoogle:YES];
            //    [LetsGameAPI disableLine:YES];
            //    [LetsGameAPI disableWeChat:YES];
            //启用vk登录
            VKBridge *vkBridge = [[VKBridge alloc] initWithVKAppId:@"5029792"];
            [LetsGameAPI instance].vkBridge = vkBridge;
            //微信登陆
            [[LetsGameAPI instance] registerAppWeChatOfSuccess:^{
                NSLog(@"注册成功");
            } failure:^{
                NSLog(@"注册失败");
            }];
            
            [LetsGameAPI instance].succBlock = ^(NSString *userId, NSString *sessionKey, LSGAccountType type) {
                self.sessionKey = sessionKey;
                self.resultLabel.text = [NSString stringWithFormat:@"login succ: userId = %@, sessionKey = %@, accountType = %ld", userId, sessionKey, type];
            };
            [LetsGameAPI instance].dismissBlock = ^() {
                //登录失败操作
                self.resultLabel.text = @"dismiss without login";
            };
            
            [[LetsGameAPI instance] showLoginView];
        }else{
            NSLog(@"初始化失败");
            self.resultLabel.text = @"初始化失败";
        }
    }];
}


- (void)onLogoutTest {
    [LetsGameAPI instance].appId = @"10056";
    [LetsGameAPI instance].appKey = @"b59c21a078fde074a6750e91ed19fb21";
    [[LetsGameAPI instance] logout];
  
}

-(void)onPayTest{
    [LetsGameAPI instance].appId = @"10022";//@"10056";//10022
    [LetsGameAPI instance].appKey = @"93a27b0bd99bac3e68a440b48aa421ab";//@"b59c21a078fde074a6750e91ed19fb21";//93a27b0bd99bac3e68a440b48aa421ab
    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
    [payInfo setValue:@"100" forKey:@"serverId"];
    [payInfo setValue:@"10010" forKey:@"roleId"];
    [payInfo setValue:@"1000" forKey:@"channelId"];
    [payInfo setValue:@"10" forKey:@"amount"];
    [payInfo setValue:@"ios demo" forKey:@"extraInfo"];
    [payInfo setValue:@"test" forKey:@"product"];
    [payInfo setValue:@"76c17cc68ff9f7f40bd3d096ccc5600a" forKey:@"sessionKey"]; //self.sessionKey
    [[LetsGameAPI instance] pWeb:payInfo handleCallBack:^{
        NSLog(@"第三方支付完成");
    }];
}

-(void)onIapTest{
    [LetsGameAPI instance].appId = @"10056";
    [LetsGameAPI instance].appKey = @"b59c21a078fde074a6750e91ed19fb21";
    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
    [payInfo setValue:@"5001" forKey:@"serverId"];
    [payInfo setValue:@"10010" forKey:@"roleId"];
    [payInfo setValue:@"1000" forKey:@"channelId"];
    [payInfo setValue:@"10" forKey:@"amount"];
    [payInfo setValue:@"ios demo" forKey:@"extraInfo"];
    [payInfo setValue:@"test.product.1" forKey:@"product"];
    [[LetsGameAPI instance] iap:payInfo forUser:@"" succCallback:^(NSString *orderId) {
        //注意测试仅仅是通知客户端成功，但是还需要向服务器请求验证是否成功，以服务端验证为准
        NSLog(@"IAP completed orderId of Gumptech:%@",orderId);
    } failCallback:^(NSString *orderId) {
        NSLog(@"IAP file orderId of Gumptech:%@",orderId);
    }];
}


- (BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
