# Gump IOS SDK使用文档


接入手册        
V 3.5.5      
2018年5月9日    
        
## 概述  
#### 本SDK提供gump账号，fb账号，vk账号，Google帐号四种账号登录，iap支付和第三方支付两种支付功能，其中gump账号登录和fb账号登录功能为必须接入，支付可根据需要选择性接入。

## 接入步骤
### 1、添加Framework和资源文件  
+ 以下为必须添加的framework以及资源bundle：  
MobileCoreServices.framework、SystemConfiguration.framework、libz.dylib、CFNetwork.framework、GameSDK.framework、StoreKit.framework、GameSDKResources.bundle
+ 以下为可选，若接入vk登录则需要添加以下framework和bundle，其中VKSdk.framework和VKSDKResources.bundle请自行从vk.com下载，使用1.3版本  
 VKSdk.framework、VKBridge.framework、VKSDKResources.bundle
+ 以下可选，若接入微信登陆则需要添加如下的framework：
libsqlite3.0.dylib, libc++.dylib, Security.framework, CoreTelephony.framework, CFNetwork.framework


### 2、引入头文件，设置build setting  
需要使用头文件有LetsGameAPI.h和VKBridge.h，其中VKBridge.h为接入vk时使用，不接入vk可忽略。  
因sdk内使用了category，需要设置other linker flag为 -ObjC
 

### 3、增加必要配置  
1）在application delegate中， 在application:openURL:sourceApplication:annotation:添加返回：

    return [[LetsGameAPI instance] handleOpenURL:url sourceApplication:sourceApplication];

	
2）配置URL-schema(vk专用，不接入vk可忽略)  
Xcode 5: Open your application settings then select the Info tab. In the URL Types section click the plus sign. Enter vk+APP_ID (e.g. vk1234567) to the Identifier and URL Schemes fields.  
![](images/vk1.jpg)     
Xcode 4: Open your Info.plist then add a new row URL Types. Set the URL identifier to vk+APP_ID
![](images/vk2.jpg)   
3）配置URL-schema（weChat专用，不接入可以忽略）
选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
选中“TARGETS”一栏，在“info”标签栏的“LSApplicationQueriesSchemes“添加weixin和wechat
 
### 4、在工程里添加SDK登录代码  

	[LetsGameAPI instance].appId = @"100"; // 设置appId
	[LetsGameAPI instance].appKey = @"100"; // 设置appKey
	[LetsGameAPI instance].channelId = @"100"; //设置channelId
	
	//启用vk的代码，需要填入vk appId，若不接入vk，可以忽略
	//VKBridge *vkBridge = [[VKBridge alloc] initWithVKAppId:@"5029792"];
	//[LetsGameAPI instance].vkBridge = vkBridge;
	
	//隐藏fb登录
	[LetsGameAPI disableFB:YES];
	//隐藏Google登录
	[LetsGameAPI disableGoogle:YES];
	//隐藏gumptech的logo
	[LetsGameAPI hiddenLogo:YES];
	//隐藏line登录
	[LetsGameAPI disableLine:YES];
	//隐藏wechat登录
    [LetsGameAPI disableWeChat:YES];

	[[LetsGameAPI instance] showLoginView]; // 弹出登录页面

	// 登录成功回调
	[LetsGameAPI instance].succBlock = ^(NSString *userId, NSString *sessionKey, LSGAccountType type) {
	NSLog(@"%@", [NSString stringWithFormat:@"login succ: userId = %@, sessionKey = %@, accountType = %d", userId, sessionKey, type]);
	};

	// 登录失败回调
	[LetsGameAPI instance].dismissBlock = ^() {
	 NSLog(@"dismiss without login");
	};

### 5、登录注销
注销接口只要设置过appId和appKey之后就不需要设置了，注销完成之后会回到登录界面。FB登录回到登录页面，Gump登录或者游客登录回到登录框。

	[LetsGameAPI instance].appId = @"100";//设置appId
    [LetsGameAPI instance].appKey = @"100";//设置appkey
    [[LetsGameAPI instance] logout];  //注销
    

### 6、第三方支付    
    [LetsGameAPI instance].appId = @"10022";
    [LetsGameAPI instance].appKey = @"f899139df5e1059396431415e770c6dd";
    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
    [payInfo setValue:@"5001" forKey:@"serverId"];//服务器id,必传参数
    [payInfo setValue:@"10010" forKey:@"roleId"];//用户角色id
    [payInfo setValue:@"1000" forKey:@"channelId"];//渠道id
    [payInfo setValue:@"10" forKey:@"amount"];//金额
    [payInfo setValue:@"ios demo" forKey:@"extraInfo"];//外部订单信息
    [payInfo setValue:@"元宝" forKey:@"product"];//物品信息
    [payInfo setValue:self.sessionKey forKey:@"sessionKey"];//登录成功的sessionKey
    [[LetsGameAPI instance] pWeb:payInfo handleCallBack:^{
    	//第三方支付完成时的回调(包括支付成功和支付失败，除了支付过程中取消的),取消的不会有回调
        NSLog(@"第三方支付完成");
    }]];
    
### 7、IAP支付
若要使用apple IAP支付，需要在AppDelegate的application: didFinishLaunchingWithOptions:方法内注册iap observer，使用如下方法   

    [[LetsGameAPI instance] registeIapObserver];  
具体调用iap支付的方法如下：   
    
    [LetsGameAPI instance].appId = @"10022";
    [LetsGameAPI instance].appKey = @"93a27b0bd99bac3e68a440b48aa421ab";
    NSMutableDictionary *payInfo = [NSMutableDictionary dictionary];
    [payInfo setValue:@"5001" forKey:@"serverId"];//当前用户所在的服务器Id
    [payInfo setValue:@"10010" forKey:@"roleId"];//当前用户的角色id
    [payInfo setValue:@"1000" forKey:@"channelId"];//渠道id，用于统计
    [payInfo setValue:@"10" forKey:@"amount"];//对应支付项的支付金额，实际支付金额以itunes配置为准
    [payInfo setValue:@"ios demo" forKey:@"extraInfo"];//扩展信息，可以游戏自定义，建议传自有订单号
    [payInfo setValue:@"test.product.1" forKey:@"product"];//itunes 后台配置的对应支付项的productId
    [[LetsGameAPI instance] iap:payInfo forUser:@"" succCallback:^(NSString *orderId) {
        //此处的回调表明支付已经完成，但此时支付不一定成功，需要服务端验证支付结果
        //orderId为gump生成的订单号，此订单号可以在gump server查询此笔支付是否成功
        NSLog(@"IAP completed orderId of Gumptech:%@",orderId);
    } failCallback:^(NSString *orderId) {
    	 //支付失败
        NSLog(@"IAP file orderId of Gumptech:%@",orderId);
    }];
### 8、token的获取
FB登录之后会产生token并自动登录，需要如果需要token的话，需要自己调用接口获取。

	//tokenString：token字符串
	//refreshTime：refreshTime token最后刷新的时间，即获取的token的时间
	//expirationTime：expirationTime token最后的有效时间
    [[LetsGameAPI instance] obtainAccessTokenSuccess:^(NSString *tokenString, NSString *refreshTime, NSString *expirationTime) {
        NSLog(@"tokenString %@, refreshTime %@, expirationTime %@", tokenString, refreshTime, expirationTime);
    } failure:^(NSString *errorString) {
        NSLog(@"get token faile");
    }];
    
    
### 9、第三方支付版本
第三方支付，分成两个版本：没有gump币和有gump币，不设置时默认为不带gump币版本，如果使用带gump币的版本如下设置：
	
	需要在 application:didFinishLaunchingWithOptions方法中添加:
	
	[[LetsGameAPI instance] decideWebToVersion:1]


### 10、关于侵权还是侵权的接口显示
运营在后台配置此包名和版本在什么时候显示侵权内容还是不侵权内容，此接口调用需要在游戏才开始加载的时候调用，返回值是YES的时候显示侵权内容，在NO的时候显示不侵权内容。

注意：关于运营配置的游戏的版本号，我们默认取的是Bulid版本号的值，请注意。

	    [[LetsGameAPI instance] gameObtainSafeSetInfoWithAppId:@"10056" ChannelId:@"1000" handleCallBack:^(BOOL resultStatus) {
        if (resultStatus) {
            NSLog(@"YES 侵权");
        }else{
            NSLog(@"NO 不侵权");
        }
    }];
### 11、横竖屏设置

    首先设置SDK默认是横屏，在General->Deployment Info->Device Orientain下，只选择Landscape Left 和 Landscape Right,SDK的界面默认是横屏。
    其次如果想使用竖屏的模式，需要在General->Deployment Info->Device Orientain下，只选择Portrait模式，并且需要在AppDelegate中的方法：
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions；靠前的位置添加代码设置：
    
    [LetsGameAPI DeviceOrientationIsHorizontal:NO];
    
    
    


### 12、微信登陆

    首先在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions；方法中向微信注册应用
    //微信登陆
    [[LetsGameAPI instance] registerAppWeChatWithAppId:@"appId" appKey:@"appKey" Success:^{
        NSLog(@"注册成功");
    } failure:^{
        NSLog(@"注册失败");
    }];
