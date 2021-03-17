//
//  ARRecViewController.m
//  ARTest
//
//  Created by 马腾 on 2019/2/26.
//  Copyright © 2019 beiwaionline. All rights reserved.
//

#import "ARRecViewController.h"
//ARKit框架
#import <ARKit/ARKit.h>

@interface ARRecViewController ()<ARSCNViewDelegate>

//AR视图：展示3D界面
@property(nonatomic,strong)ARSCNView *arSCNView;

//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;

//会话追踪配置：负责追踪相机的运动
@property(nonatomic,strong)ARConfiguration *arSessionConfiguration;
@end

@implementation ARRecViewController

- (ARSCNView *)arSCNView
{
    if (!_arSCNView) {
        //1.创建AR视图
        _arSCNView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //2.设置视图会话
        _arSCNView.session = self.arSession;
        
        _arSCNView.delegate = self;
        
        //3.自动刷新灯光（3D游戏用到，此处可忽略）
        _arSCNView.automaticallyUpdatesLighting = YES;
        //    _arSCNView.allowsCameraControl = YES;
    }
    return _arSCNView;
}
- (ARConfiguration *)arSessionConfiguration
{
    if (!_arSessionConfiguration) {
        //1.创建世界追踪会话配置（使用ARWorldTrackingConfiguration效果更加好），需要A9芯片支持
        ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
        //2.设置追踪方向（追踪平面，后面会用到）
        configuration.planeDetection = ARPlaneDetectionHorizontal;
        
        if (@available(iOS 11.3, *)) {
            configuration.autoFocusEnabled = YES;
             configuration.detectionImages = [ARReferenceImage referenceImagesInGroupNamed:@"AR Resources" bundle:nil];
        } else {
            // Fallback on earlier versions
        }
        _arSessionConfiguration = configuration;
        //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
        _arSessionConfiguration.lightEstimationEnabled = YES;
        

    }
    return _arSessionConfiguration;
}
- (ARSession *)arSession
{
    if (!_arSession) {
        //1.创建会话
        _arSession = [[ARSession alloc] init];
    }
    return _arSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.将AR视图添加到当前视图
    [self.view addSubview:self.arSCNView];
    //    //2.开启AR会话（此时相机开始工作）
    [self.arSession runWithConfiguration:self.arSessionConfiguration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    
    
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
}
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-
#pragma mark - ARSCNViewDelegate
/**
 当新的节点映射到指定锚点时调用
 
 @param renderer 渲染画面的渲染器
 @param node 新添加的节点
 @param anchor 节点映射到的锚点
 */
- (void)renderer:(id)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    ARImageAnchor * imageAnchor = (ARImageAnchor *)anchor;
    //获取参考图片对象
    ARReferenceImage * referenceImage = imageAnchor.referenceImage;
    if ([referenceImage.name isEqual:@"fu"]) {
       
        NSLog(@"发现福字");
    }
    
}
/**
 Called when a node will be updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that will be updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}

/**
 Called when a node has been updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}
/**
 Called when a mapped node has been removed from the scene graph for the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was removed.
 @param anchor The anchor that was removed.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}
@end
