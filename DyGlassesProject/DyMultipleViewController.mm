//
//  DyMultipleViewController.m
//  three_topplusvisionDemo
//
//  Created by Jeavil on 16/2/18.
//  Copyright © 2016年 topplusvision. All rights reserved.
//

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define WIDTH_ITEM  [UIScreen mainScreen].bounds.size.width
#define HEIGHT_ITEM  [UIScreen mainScreen].bounds.size.width * 4 / 3
#define Heard_HEIGHT self.navigationController.navigationBar.bounds.size.height
#define Heard_Y     self.navigationController.navigationBar.bounds.origin.y
#import "DyMultipleViewController.h"
#import <DyGlassesFramework/DyGlassesFramework.h>
#import "SVProgressHUD/SVProgressHUD.h"
@interface DyMultipleViewController (){
    
    DySDKHandle *handle;
    UIImageView *_imageView;
    UIImageView *testView;
    
}

@end

@implementation DyMultipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在初始化，请稍候。。。"];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self initLayout];
    });

}
- (void)initLayout{
    //handle = [[DySDKHandle alloc]init];
    handle = [DySDKHandle shareHandle];
    //_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-WIDTH/4, -WIDTH / 4, WIDTH_ITEM, HEIGHT_ITEM)];
    //[handle EngineInit];
    //UIImageView *superview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, WIDTH / 2, WIDTH / 2 / 3 * 4)];
    //[self.view addSubview:superview];
    //superview.clipsToBounds = YES;
    //[superview addSubview:_imageView];
    //[handle AddEngineToView:_imageView andSuperView:superview];
    float y = Heard_HEIGHT + 20;
    float handleWidth = WIDTH / 2;
    float handleHeight = WIDTH / 3 * 2;
    [handle AddEngineToView:self.view withFrame:CGRectMake(0, y, handleWidth, handleHeight)];
    //testView = [[UIImageView alloc]initWithFrame:CGRectMake(-WIDTH/4, -WIDTH / 4, WIDTH_ITEM, HEIGHT_ITEM)];
    //UIImageView *superview0 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH / 2, 70, WIDTH / 2, WIDTH / 2 / 3 * 4)];
    //[self.view addSubview:superview0];
    //superview0.clipsToBounds = YES;
    //[superview0 addSubview:testView];
    //[handle AddEngineToView:testView andSuperView:superview0];
    [handle AddEngineToView:self.view withFrame:CGRectMake(handleWidth, y, handleWidth, handleHeight)];
    //UIImageView *testView1 = [[UIImageView alloc]initWithFrame:CGRectMake(-WIDTH/4, -WIDTH / 4, WIDTH_ITEM, HEIGHT_ITEM)];
    //UIImageView *superview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70 + WIDTH / 2 / 3 * 4, WIDTH / 2, WIDTH / 2 / 3 * 4)];
    //[self.view addSubview:superview1];
    //superview1.clipsToBounds = YES;
    //[superview1 addSubview:testView1];
    //[handle AddEngineToView:testView1 andSuperView:superview1];
    [handle AddEngineToView:self.view withFrame:CGRectMake(0, handleHeight + y, handleWidth, handleHeight)];
    
    
    //UIImageView *testView2 = [[UIImageView alloc]initWithFrame:CGRectMake(-WIDTH/4, -WIDTH / 4, WIDTH_ITEM, HEIGHT_ITEM)];
    //UIImageView *superview2 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH / 2, 70 + WIDTH / 2 / 3 * 4, WIDTH / 2, WIDTH / 2 / 3 * 4)];
    //[self.view addSubview:superview2];
    //superview2.clipsToBounds = YES;
    //[superview2 addSubview:testView2];
    //[handle AddEngineToView:testView2 andSuperView:superview2];
    [handle AddEngineToView:self.view withFrame:CGRectMake(handleWidth, handleHeight + y, handleWidth, handleHeight)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [handle LoadGlassModel:self.modelNames[1] ToViewByIndex:1];
    [handle Engine_UpdateGlassModelScale:self.glassesScale ToViewByIndex:1];
    [handle Engine_UpdateNosePadPos:self.glassesHeight ToViewByIndex:1];
    
    [handle LoadGlassModel:self.modelNames[2] ToViewByIndex:2];
    [handle Engine_UpdateGlassModelScale:self.glassesScale ToViewByIndex:2];
    [handle Engine_UpdateNosePadPos:self.glassesHeight ToViewByIndex:2];
    
    [handle LoadGlassModel:self.modelNames[3] ToViewByIndex:3];
    [handle Engine_UpdateGlassModelScale:self.glassesScale ToViewByIndex:3];
    [handle Engine_UpdateNosePadPos:self.glassesHeight ToViewByIndex:3];
    
    [handle LoadGlassModel:self.modelNames[4] ToViewByIndex:4];
    [handle Engine_UpdateGlassModelScale:self.glassesScale ToViewByIndex:4];
    [handle Engine_UpdateNosePadPos:self.glassesHeight ToViewByIndex:4];
    [SVProgressHUD dismiss];
    [handle start];
    
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [handle stop];
}
- (void)dealloc{
    [handle releaseEngineToIndex:4];
    [handle releaseEngineToIndex:3];
    [handle releaseEngineToIndex:2];
    [handle releaseEngineToIndex:1];
}
@end
