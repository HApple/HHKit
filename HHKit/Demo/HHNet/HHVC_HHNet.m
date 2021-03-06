//
//  HHVC_HHNet.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/22.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHVC_HHNet.h"
#import "HHNetManager.h"


static NSString * const url1 = @"http://c.m.163.com/nc/video/home/1-10.html";
static NSString * const url2 = @"http://apis.baidu.com/apistore/";
static NSString * const url3 = @"http://yycloudvod1932283664.bs2dl.yy.com/djMxYTkzNjQzNzNkNmU4ODc1NzY1ODQ3ZmU5ZDJlODkxMTIwMjM2NTE5Nw";
static NSString * const url4 = @"http://www.aomy.com/attach/2012-09/1347583576vgC6.jpg";
static NSString * const url5 = @"http://chanyouji.com/api/users/likes/268717.json";

static NSString * const url6 = @"http://li.itingwang.com:9007/service/userlogin";

static NSString * const url7_https = @"https://api.jingjiribao.cn/v300/push/pushList";

#define defaultUrl        @"http://zl160528.15.baidusx.com/app/log_mobile.php"

/*！国内天气预报融合版－apikey */
//#define apikey  @"82428a4618b6aa313be6914d727cb9b7"

#define HHKit_ShowAlertWithMsg(msg) UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确 定" style:UIAlertActionStyleDefault handler:nil];\
[alert addAction:sureAction];\
[self presentViewController:alert animated:YES completion:nil];

@interface HHVC_HHNet ()

@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;

@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end

@implementation HHVC_HHNet

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"HHNetManager";
    
    /*! 网络状态实时监测可以使用 block 回调，也可以使用单独方法判断 */
    [self HH_netType];
    
    // 清楚所有缓存，可以自由定义删除时间
    [HHNetManager clearAllHttpCache:nil];
    
    HHNetManagerShared.isOpenLog = YES;
}

#pragma mark - 网络类型判断
- (void)HH_netType
{
//    HHWeak;
    [HHNetManager startNetWorkMonitoringWithBlock:^(HHNetworkStatus status) {
        NSString *msg;
        switch (status) {
            case 0:
            {
                msg = @"未知网络";
                HHKit_ShowAlertWithMsg(msg);
            }
                break;
            case 1:
            {
                msg = @"没有网络";
                HHKit_ShowAlertWithMsg(msg);
            }
                break;
            case 2:
            {
                msg = @"您的网络类型为：手机 3G/4G 网络";
                HHKit_ShowAlertWithMsg(msg);
            }
                break;
            case 3:
            {
                msg = @"您的网络类型为：wifi 网络";
                /*! wifi 网络下请求网络：可以在父类写此方法，具体使用demo，详见：https://github.com/boai/HHHHseProject */
                HHKit_ShowAlertWithMsg(msg);
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - get
- (IBAction)getData:(UIButton *)sender
{
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    HHDataEntity *entity = [HHDataEntity new];
    entity.urlString = url5;
    entity.needCache = YES;
    [HHNetManagerShared requestGetWithEnity:entity progerssBlock:nil successBlock:^(id  _Nonnull response, BOOL isCache) {
        NSString *msg = [NSString stringWithFormat:@"get 请求数据结果：%@", response];
        HHKit_ShowAlertWithMsg(msg);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - post
- (IBAction)postData:(UIButton *)sender
{
    [sender setTitle:@"post" forState:UIControlStateNormal];
    // 自定义超时设置
    HHNetManagerShared.timeoutInterval = 15;
    
    // 自定义添加请求头
//    NSDictionary *headerDict = @{@"Accept":@"application/json", @"Accept-Encoding":@"gzip", @"charset":@"utf-8"};
//    HHNetManagerShare.httpHeaderFieldDictionary = headerDict;
    
    // 自定义更改 requestSerializer
//        HHNetManagerShare.requestSerializer = BAHttpRequestSerializerHTTP;
    // 自定义更改 responseSerializer
//        HHNetManagerShare.responseSerializer = BAHttpRequestSerializerHTTP;
    
    // 清楚当前所有请求头
//    [HHNetManager ba_clearAuthorizationHeader];
    
    
//    NSString *url = @"http://115.29.201.135/mobile/mobileapi.php";
//    NSString *parameters = @"sAp3OxNlYMZZa7OlRi2TwguoTtwNwwFwOo5k8LL3ERtcTbAvGPhZ5yUWiiIJeXx2WjYlnMU1nFOoi2JSKJDINW62lcM9DB9XDdZQACnY60g=";
//    int page = 1;
    NSDictionary *parameters = @{
                           @"txtusername":@"13651789999",
                           @"txtpassword":@"123456"
                           };
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page).stringValue, @"page", @"10", @"per_page", nil];;
    
    HHDataEntity *entity = [HHDataEntity new];
    entity.urlString = url6;
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [HHNetManagerShared requestPostWithEnity:entity progerssBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        self.uploadLabel.text = [NSString stringWithFormat:@"上传进度：%.2lld%%",100 * bytesProgress/totalBytesProgress];
        [sender setTitle:@"上传中..." forState:UIControlStateNormal];
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        self.uploadLabel.text = @"上传完成";
        [sender setTitle:@"上传完成" forState:UIControlStateNormal];
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}

#pragma mark - 下载视频、图片
- (IBAction)downloadData:(UIButton *)sender
{
    UIButton *downloadBtn = (UIButton *)sender;
    NSString *path1 = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/半塘.mp4"]];
    //    NSString *path2 = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/image123.mp3"]];
    
    NSLog(@"路径：%@", path1);
    
    /*! 查找路径中是否存在"半塘.mp4"，是，返回真；否，返回假。 */
    //    BOOL result2 = [path1 hasSuffix:@"半塘.mp4"];
    //    NSLog(@"%d", result2);
    
    /*!
     下载前先判断该用户是否已经下载，目前用了两种方式：
     1、第一次下载完用变量保存，
     2、查找路径中是否包含改文件的名字
     如果下载完了，就不要再让用户下载，也可以添加alert的代理方法，增加用户的选择！
     */
    //    if (isFinishDownload || result2)
    //    {
    //        [[[UIAlertView alloc] initWithTitle:@"温馨提示：" message:@"您已经下载该视频！" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil] show];
    //        return;
    //    }
//    BAWeak;
    
    HHFileDataEntity *fileEntity = [HHFileDataEntity new];
    fileEntity.urlString = @"http://static.yizhibo.com/pc_live/static/video.swf?onPlay=YZB.play&onPause=YZB.pause&onSeek=YZB.seek&scid=pALRs7JBtTRU9TWy";
    fileEntity.filePath = path1;
    
    [HHNetManagerShared downloadFileWithEntity:fileEntity progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        self.downloadLabel.text = [NSString stringWithFormat:@"下载进度：%.2lld%%",100 * bytesProgress/totalBytesProgress];
        [downloadBtn setTitle:@"下载中..." forState:UIControlStateNormal];
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        
        NSLog(@"下载完成，路径为：%@", response);
        self.downloadLabel.text = @"下载完成";
        [downloadBtn setTitle:@"下载完成" forState:UIControlStateNormal];
        [downloadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        HHKit_ShowAlertWithMsg(@"视频下载完成！");
        
    } failureBlock:^(NSError * _Nonnull error) {
        

        
    }];
    

}

#pragma mark - 上传图片
- (IBAction)uploadImageData:(UIButton *)sender
{
    /*!
     
     1、此上传图片单张、多图上传都经过几十个项目亲测可用，大家可以放心使用，使用过程中有问题，请加群：479663605 进行反馈，多谢！
     2、注意：如果使用PHP后台，后台不会对接此接口的话，博爱已经为你们量身定做了PHP后台接口，你们只需要把文件夹中的 postdynamic.php 文件发送给你们的PHP后台同事，他们就知道了，里面都有详细说明！
     */
    
    HHImageDataEntity *imageEntity = [HHImageDataEntity new];
    
    [HHNetManagerShared uploadImageWithEntity:imageEntity progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}

#pragma mark - 上传视频
- (IBAction)uploadVideoData:(UIButton *)sender
{
    /*!
     
     1、此上传视频都经过几十个项目亲测可用，大家可以放心使用，使用过程中有问题，请加群：479663605 进行反馈，多谢！
     2、此处只需要传URL 和 parameters就行了，具体压缩方法都已经做好处理！
     
     */
    HHFileDataEntity *videoEntity = [HHFileDataEntity new];
    
    [HHNetManagerShared uploadVideoWithEntity:videoEntity progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - put 请求
- (IBAction)putData:(UIButton *)sender
{
    NSDictionary *dict = @{@"EquipmentType":@"iPhone", @"EquipmentGUID":@"b61df00d-87db-426f-bc5a-bc8fffa907db"};
    HHDataEntity *entity = [HHDataEntity new];
    entity.urlString = @"http://120.76.245.240:8080/bda/resetPassword/?account=761463699@qq.com&password=q&OTP=634613";
    entity.parameters = dict;
    
    [HHNetManagerShared requestPutWithEnity:entity progerssBlock:nil successBlock:^(id  _Nonnull response, BOOL isCache) {
        NSLog(@" put 请求 *********00000 : %@", response);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - delete 请求
- (IBAction)deleteData:(UIButton *)sender
{
    HHDataEntity *entity = [HHDataEntity new];
    [HHNetManagerShared requestDeleteWithEnity:entity progerssBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 上传文件
- (IBAction)uploadFileButtonAction:(UIButton *)sender
{
    HHFileDataEntity *fileEntity = [HHFileDataEntity new];
    [HHNetManagerShared uploadFileWithEntity:fileEntity progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } successBlock:^(id  _Nonnull response, BOOL isCache) {
        
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];

}

@end
