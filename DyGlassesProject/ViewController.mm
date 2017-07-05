//
//  ViewController.m
//  DYTEST
//
//  Created by Jeavil on 16/1/15.
//  Copyright © 2016年 topplusvision. All rights reserved.
//
#define DOCUMENT_PATH   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import <DyGlassesFramework/DyGlassesFramework.h>
#import "DyMultipleViewController.h"
@interface ViewController ()<UIPickerViewDelegate>{
    
    DySDKHandle *handle;
    CGFloat glassHigh;
    UIImageView *_imageView;
    double     verticalAngle;
    double     featherDistance;
    
    double     modelScale;
    double originY;
    double originX;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSMutableArray *modelNames;
@end

static BOOL isStart = NO;
static BOOL isMediate = YES;
static BOOL isBoth = YES;
@implementation ViewController

- (NSMutableArray *)modelNames{
    
    if (!_modelNames) {
        _modelNames = [NSMutableArray array];
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"glasses" ofType:@"bundle"];
        NSBundle *glassBundle = [NSBundle bundleWithPath:bundlePath];
        NSString *filePath = [glassBundle pathForResource:@"" ofType:@"gst"];
        NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
        NSString* fileFrontPath = [filePath substringToIndex:range.location];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error = nil;
        NSArray* fileList = [[NSArray alloc] init];
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [fileManager contentsOfDirectoryAtPath:fileFrontPath error:&error];
        for (int i =0 ;i<fileList.count;i++){
            NSString* fileFullName =[fileFrontPath stringByAppendingFormat:@"%@%@",@"/",fileList[i]];
            NSString* fileNameExt = [fileFullName pathExtension];
            if([fileNameExt isEqual: @"gst"])
            {
                [_modelNames addObject:fileFullName];
            }
        }
        NSString *strPlay = NSLocalizedString(@"Change Glasses",@"");
        [_modelNames insertObject:strPlay atIndex:0];
    }
    return _modelNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Move your face into screen";
    [self allNumbers];
    
    //初始化DySDKHandle创建一个对象
    handle = [DySDKHandle shareHandle];
    //初始化引擎
    [handle EngineInit];
   
    //添加动态试戴窗口
    //[handle AddEngineToView:_imageView andSuperView:self.view];
    [handle AddEngineToView:self.view withFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 3 * 4)];
    //加载眼镜模型
    //[handle LoadGlassModel:self.modelNames[5] ToViewByIndex:0];
#ifdef RELEASE
    NSLog(@"RELEASE");
    [handle saveLogToFile:nil];
    
#endif
    //启动引擎
    [handle start];
 
    //调整镜架高度
    [handle Engine_UpdateNosePadPos:glassHigh ToViewByIndex:0];
    
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    [self.view bringSubviewToFront:_picker];
    [self creatMultipleBtn];

}

- (void)creatMultipleBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"黑色多窗"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(multipleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)multipleClick:(UIButton *)sender{
    self.title = @"Back";
    isStart = YES;
    DyMultipleViewController *dy = [[DyMultipleViewController alloc]init];
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:self.modelNames];
    [muArray removeObjectAtIndex:0];
    dy.modelNames = muArray;
    dy.glassesHeight = glassHigh;
    dy.glassesScale = modelScale;
    [self.navigationController pushViewController:dy animated:YES];
}
- (void)allNumbers{
    glassHigh = 0.2;
    modelScale = 0.5;
}

#pragma mark picker的回调方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.modelNames.count > 0)
        return self.modelNames.count;
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[self.modelNames[row] lastPathComponent] stringByDeletingPathExtension];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
//    if (row == 1) {
//      
//    [handle loadGlassesModelWithFlag:@"k01-02" ToViewByIndex:0];
//    }else{
    [handle LoadGlassModel:self.modelNames[row] ToViewByIndex:0];
//    }
}

#pragma  touch手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSArray *fingerArray = [[event allTouches] allObjects];
    if (fingerArray.count > 1) {
        UITouch *touch= fingerArray[0];
        UITouch *touch1 = fingerArray[1];
        CGPoint point = [touch locationInView:self.view];
        CGPoint point1 = [touch1 locationInView:self.view];
        originY = fabs(point.y - point1.y);
        originX = fabs(point.x - point1.x);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint lpoint = [touch previousLocationInView:self.view];
    float moveX = point.x - lpoint.x;
    float moveY = point.y - lpoint.y;
    if (touches.count == 1) {
        if (fabs(moveY)/fabs(moveX)>1) {
            if ((lpoint.y - point.y) < 0) {
                glassHigh = glassHigh + 0.05;
                if (glassHigh > 1) {
                    glassHigh = 1;
                }
            }else{
                glassHigh = glassHigh - 0.05;
                if (glassHigh < 0) {
                    glassHigh = 0;
                }
        }
            [handle Engine_UpdateNosePadPos:glassHigh ToViewByIndex:0];
        }else{
            
    }
}
    if(touches.count == 2)
    {
        NSArray *arr = [touches allObjects];
        UITouch *touch1 = (UITouch *)arr[0];
        UITouch *touch2 = (UITouch *)arr[1];
        
        CGPoint current1=[touch1 locationInView:self.view];
      
        CGPoint previous1=[touch1 previousLocationInView:self.view];
        //****************捏合手势
        CGPoint current2=[touch2 locationInView:self.view];
        CGPoint previous2=[touch2 previousLocationInView:self.view];
        CGFloat cc = (current2.x - current1.x) * (current2.x - current1.x) + (current2.y - current1.y) * (current2.y - current1.y);
        CGFloat cc1 = (previous2.x - previous1.x) * (previous2.x - previous1.x) + (previous2.y - previous1.y) * (previous2.y - previous1.y);
       CGFloat occ = originX * originX + originY * originY;
        if (isMediate) {
            if (occ > 1000) {
                if (cc > cc1) {
                    isBoth = NO;
                    modelScale = modelScale + 0.05;
                    if (modelScale > 1) {
                        modelScale = 1;
                    }
                }else{
                    isBoth = NO;
                    modelScale = modelScale - 0.05;
                    if (modelScale < 0) {
                        modelScale = 0;
                    }
                }
                [handle Engine_UpdateGlassModelScale:modelScale ToViewByIndex:0];
            }
        }
        if (isBoth) {
            if (fabs(moveX)/fabs(moveY)>1) {
              //  isMediate = NO;
                if(moveX > 0) {
                    featherDistance = featherDistance +0.1;
                    if (featherDistance > 1.0) {
                        featherDistance = 1.0;
                    }
                } else  if(moveX < 0){
                    featherDistance = featherDistance -0.1;
                    if (featherDistance < 0.0) {
                        featherDistance = 0.0;
                    }
                }
            } else if(fabs(moveY)/fabs(moveX)>1){
               // isMediate = NO;
                if(moveY < 0) {
                    verticalAngle = verticalAngle +0.05;
                    if (verticalAngle > 1.0) {
                        verticalAngle = 1.0;
                    }
                } else  if(moveY > 0){
                    verticalAngle = verticalAngle -0.05;
                    if (verticalAngle < 0.0) {
                        verticalAngle = 0.0;
                    }
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   NSArray *arr = [touches allObjects];
    if (arr.count != 1 || arr.count != 2) {
        isBoth = YES;
        isMediate = YES;
    }
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [handle stop];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"Move your face into screen";
    if (isStart) {
        [handle start];
    }
}

@end
