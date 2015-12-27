//
//  ViewController.m
//  MulColumTextDemo
//
//  Created by 李佳 on 15/12/27.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#import "ViewController.h"
#import "TimMulColumTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TimMulColumTextView* view = [[TimMulColumTextView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
}



@end
