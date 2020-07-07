//
//  WebViewModel.h
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewModel : NSObject

@property (nonatomic, copy) NSString *contentHtml;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
