//
//  HHTool.h
//  
//
//  Created by Huang on 2019/4/16.
//  Copyright © 2019 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTool : NSObject

/**
 根据json数据生成 model类(.h .m文件)
 生成的路径默认保存在桌面上
 仅在模拟器上运行有效
 
 className 主类名 注意 类名公用后缀为Model 所以命名的时候不需要再加model
 data  接口返回的经过json转对象的数据
 */
+ (void)createModelClassUseClassName:(NSString *)className
                                data:(id)data;
@end

NS_ASSUME_NONNULL_END
