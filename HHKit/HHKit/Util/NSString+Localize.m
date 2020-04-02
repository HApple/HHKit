//
//  NSString+Localize.m
//  Localizing
//
//  Created by Jn.Huang on 2018/10/15.
//  Copyright © 2018年 huang. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localized{
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] stringValue];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:self value:nil table:nil];
}

@end
