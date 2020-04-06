//
//  HHTool.m
//  
//
//  Created by Huang on 2019/4/16.
//  Copyright © 2019 hjn. All rights reserved.
//

#import "HHTool.h"
#import <YBModelFile/YBModelFile.h>
#import <YYKit/YYKit.h>

static HHTool *_hhTool = nil;

@implementation HHTool

+ (instancetype)sharedHHTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hhTool = [[HHTool alloc] init];
    });
    return _hhTool;
}

+ (void)load{
    
    //具体用法 https://github.com/indulgeIn/YBModelFile
    [YBMFConfig shareConfig].framework = YBMFFrameworkMJ;
    //属性和方法之间是否空行
    [YBMFConfig shareConfig].fileMHandler.ybmf_skipLine = YES;
    //不实现NSCoding 和 NSCopying 协议
    [YBMFConfig shareConfig].needCoding = NO;
    [YBMFConfig shareConfig].needCopying = NO;
    //数据类型用NSString代替
    [YBMFConfig shareConfig].ignoreType = YBMFIgnoreTypeAllDigital | YBMFIgnoreTypeMutable;
    //默认情况下，类名公用后缀为Model，可以自行定制
    //[YBMFConfig shareConfig].fileSuffix = @"File"
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (void)createModelClassUseClassName:(NSString *)className
                                data:(id)data{
    [YBModelFile createFileWithName:className data:data];
}

@end
