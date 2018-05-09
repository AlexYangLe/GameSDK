
#import <Foundation/Foundation.h>
#import "LSGAccount.h"
#import "VKBridgeProtocol.h"


typedef void (^LSGLoginSuccBlock)(NSString *userId, NSString *sessionKey, LSGAccountType type);
typedef void (^LSGDismissBlock)(void);

static BOOL isDisableFB = NO;

static BOOL isEnableVK = NO;

static BOOL isDisableLine = NO;

static BOOL isDisableWeChat = NO;

static BOOL isDisableGoogle = NO;

static BOOL hiddenLogo = NO;

//默认横屏
static BOOL DeviceOrientationIsHorizontal = YES;

static NSString *version = @"3.5.5";

@interface LetsGameAPI : NSObject<UIApplicationDelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;
@property(nonatomic, strong) NSString *channelId;
@property (nonatomic, copy) LSGLoginSuccBlock succBlock;
@property (nonatomic, copy) LSGDismissBlock dismissBlock;
@property (nonatomic, assign) int isDebug;
@property (nonatomic, assign) int decideWebTo;
@property (nonatomic,retain) id<VKBridgeProtocol> vkBridge;
//@property(nonatomic,strong) NSString *version;

+ (instancetype)instance;

-(NSString*)version;

- (void)showLoginView;
- (void)showLoginViewInView:(UIView *)view;

+(void)disableFB:(BOOL)isDisable;
+(void)disableGoogle:(BOOL)isDisable;
+(void)disableWeChat:(BOOL)isDisable;
+(void)disableLine:(BOOL)isDissable;
+(BOOL)isFBDisable;
+(BOOL)isVKEnable;
+(BOOL)isWeChatDisable;
+(BOOL)isGoogleDisable;
+(BOOL)isLineDisable;
+(void)hiddenLogo:(BOOL)isHidden;
+(BOOL)isHiddenLogo;
+(void)DeviceOrientationIsHorizontal:(BOOL)isDisable;
+(BOOL)DeviceOrientationIsHorizontal;

- (void)logout;

- (void)hide;
//是否安装微信
-(BOOL)isWeChatInstall;
//向微信注册应用
-(void)registerAppWeChatWithAppId:(NSString *)appId
                           appKey:(NSString *)appKey
                          Success:(void (^)())success
                          failure:(void (^)())failure;

- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication;

-(void)pWeb:(NSDictionary*) pWebInfo handleCallBack:(void (^)()) pWebAccomplistCallback;

-(void)iap:(NSDictionary*) payInfo forUser:(NSString*) uid succCallback:(void (^)(NSString* orderId)) succCallback failCallback:(void (^)(NSString* orderId)) failCallback;

-(void)registeIapObserver;

-(void)decideIsDebug:(int)isDebug;

-(void)decideWebToVersion:(int)decideWebTo;

-(void)obtainAccessTokenSuccess:(void (^)(NSString *tokenString, NSString *refreshTime, NSString *expirationTime))success
                        failure:(void (^)(NSString *errorString))failure;

//获取是否展示安全页面,YES展示侵权页面，NO展示非侵权页面
-(void)gameObtainSafeSetInfoWithAppId:(NSString *)appId
                            ChannelId:(NSString *)channelId
                           handleCallBack:(void (^)(BOOL resultStatus))callBack;
@end
