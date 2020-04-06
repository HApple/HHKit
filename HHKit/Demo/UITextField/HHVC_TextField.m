//
//  HHVC_TextField.m
//  HHKit
//
//  Created by Jn.Huang on 2020/4/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHVC_TextField.h"

@interface HHVC_TextField ()

@end

@implementation HHVC_TextField

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, kNavBarHeight, 200, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.hh_moneyInputEnable = YES;
    textField.hh_maxDecimalPointNumber = 8;
    [self.view addSubview:textField];
    
}
@end
