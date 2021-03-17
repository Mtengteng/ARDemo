//
//  ViewController.m
//  ARTest
//
//  Created by 马腾 on 2019/2/21.
//  Copyright © 2019 beiwaionline. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewController.h"
#import "ARRecViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"静态AR" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openAr:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(self.view.bounds.size.width/2 - 100/2, self.view.bounds.size.height/2 - 80/2 - 120, 100, 80)];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"AR识别" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(openArReg:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(self.view.bounds.size.width/2 - 100/2, self.view.bounds.size.height/2 - 80/2 , 100, 80)];
    [self.view addSubview:button2];
    
}

- (void)openAr:(id)sender
{
    ARSCNViewController *arcnCtrl = [[ARSCNViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:arcnCtrl];
    [self presentViewController:navCtrl animated:YES completion:nil];
}
- (void)openArReg:(id)sender
{
    ARRecViewController *arrecCtrl = [[ARRecViewController alloc] init];
     UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:arrecCtrl];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

@end
