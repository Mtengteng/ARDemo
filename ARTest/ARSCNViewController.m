//
//  ARSCNViewController.m
//  ARTest
//
//  Created by 马腾 on 2019/2/21.
//  Copyright © 2019 beiwaionline. All rights reserved.
//

#import "ARSCNViewController.h"
//3D游戏框架
#import <SceneKit/SceneKit.h>
//ARKit框架
#import <ARKit/ARKit.h>

@interface ARSCNViewController ()
//AR视图：展示3D界面
@property(nonatomic,strong)ARSCNView *arSCNView;

//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;

//会话追踪配置：负责追踪相机的运动
@property(nonatomic,strong)ARConfiguration *arSessionConfiguration;


@end

@implementation ARSCNViewController

#pragma mark -搭建ARKit环境


//懒加载会话追踪配置
- (ARConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    
    //1.创建世界追踪会话配置（使用ARWorldTrackingConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    if (@available(iOS 11.3, *)) {
        configuration.autoFocusEnabled = YES;
    } else {
        // Fallback on earlier versions
    }
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    
    return _arSessionConfiguration;
    
}

//懒加载拍摄会话
- (ARSession *)arSession
{
    if(_arSession != nil)
    {
        return _arSession;
    }
    //1.创建会话
    _arSession = [[ARSession alloc] init];
    //2返回会话
    return _arSession;
}

//创建AR视图
- (ARSCNView *)arSCNView
{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    //1.创建AR视图
    _arSCNView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //2.设置视图会话
    _arSCNView.session = self.arSession;
    //3.自动刷新灯光（3D游戏用到，此处可忽略）
    _arSCNView.automaticallyUpdatesLighting = YES;
//    _arSCNView.allowsCameraControl = YES;
    return _arSCNView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
//    //2.开启AR会话（此时相机开始工作）
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
//
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    UIView *leftView = [[UIView alloc]initWithFrame:leftBtn.bounds];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftBtn];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIButton *addEarthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addEarthBtn addTarget:self action:@selector(addEarthNode:) forControlEvents:UIControlEventTouchUpInside];
    [addEarthBtn setTitle:@"放置地球" forState:UIControlStateNormal];
    [addEarthBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addEarthBtn setFrame:CGRectMake(0, self.view.bounds.size.height - 45, 100, 45)];
    [self.arSCNView addSubview:addEarthBtn];
    

}
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addEarthNode:(id)sender
{
    SCNScene *scene = [SCNScene scene];
    
    // set the scene to the view
    self.arSCNView.scene = scene;
    
    SCNNode *earthGroupNode = [SCNNode node];
    earthGroupNode.position = SCNVector3Make(0, 0, -10);

    // 创建节点，添加到scene的根节点上
    SCNNode *earthNode = [SCNNode node];
    earthNode.name = @"earth";
    // 创建一个球体几何绑定到节点上去
    SCNSphere *earthSphere = [SCNSphere sphereWithRadius:1];
    earthNode.geometry = earthSphere;
    earthNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/earth-diffuse-mini.jpg";
    earthNode.geometry.firstMaterial.emission.contents = @"art.scnassets/earth/earth-emissive-mini.jpg";
    earthNode.geometry.firstMaterial.specular.contents = @"art.scnassets/earth/earth-specular-mini.jpg";

//    earthNode.position = SCNVector3Make(0, -10, -10);//x/y/z/坐标相对于世界原点，也就是相机位置
    [earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [earthGroupNode addChildNode:earthNode];
    
    // 创建节点，添加到scene的根节点上
    SCNNode *moonNode = [SCNNode node];
    moonNode.name = @"moon";
    // 创建一个球体几何绑定到节点上去
    SCNSphere *moonSphere = [SCNSphere sphereWithRadius:0.5];
    moonNode.geometry = moonSphere;
    moonNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/moon.jpg";
    moonNode.position = SCNVector3Make(-5, 0, -5);
//    [moonNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];        //月球自转
    animation.duration = 1.5;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 2, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [moonNode addAnimation:animation forKey:@"moon rotation"];
    [earthGroupNode addChildNode:moonNode];

    [scene.rootNode addChildNode:earthGroupNode];
    
    // Moon-rotation (center of rotation of the Moon around the Earth)
    SCNNode *moonRotationNode = [SCNNode node];
    
    [moonRotationNode addChildNode:moonNode];
    
    // Rotate the moon around the Earth
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    moonRotationAnimation.duration = 5.0;
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    moonRotationAnimation.repeatCount = FLT_MAX;
    [moonRotationNode addAnimation:animation forKey:@"moon rotation around earth"];
    
    [earthGroupNode addChildNode:moonRotationNode];
  
    
}


@end
