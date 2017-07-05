//
//  DySDKHandle.h
//
//  Copyright © 2016年 topplusvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TGlassesSDK;
@class TShowEngine;

typedef  void(^finishDownGstBlock)(NSString *path);
@interface DySDKHandle : NSObject
/**创建SDKHandle*/
+ (DySDKHandle *)shareHandle;

/**初始化引擎*/
- (void)EngineInit;

/**启动引擎*/
- (void)start;

/**添加动态试戴窗口，boardView：展示动态试戴的窗口，superView：装载boardView的主窗口，动态试戴窗口的index是根据创建的先后顺序按（0，1，2，3...）来赋值的*/
- (void)AddEngineToView:(UIView *)boardView withFrame:(CGRect)frame;

/**关闭引擎*/
- (void)stop;

/**从本地加载眼镜模型到指定窗口。filePath：本地眼镜模型的路径，index：动态试戴窗口的index*/
- (void)LoadGlassModel:(NSString *)filePath ToViewByIndex:(NSInteger)index;

/**从网络加载眼镜模型到指定窗口。modelFlag：眼镜模型标志，index：动态试戴窗口的index*/
- (void)loadGlassesModelWithFlag:(NSString *)modelFlag ToViewByIndex:(NSInteger)index;

/**设置鼻托在鼻梁上的位置，value：参数范围是0-1，设置为0鼻托在最顶部，设置为1鼻托在最底部，推荐初始值设置为0.2，index：动态试戴窗口的index*/
- (void)Engine_UpdateNosePadPos:(float)value ToViewByIndex:(NSInteger)index;

/**设置眼镜的俯仰角度，value：参数范围是0-1，设置为0为向下转5度，设置为1是向上转5度，index：动态试戴窗口的index*/
- (void)Engine_UpdateVerticalAngle:(float)value ToViewByIndex:(NSInteger)index;

/**设置镜腿虚化的程度，value：参数范围是0-1，设置为0是显示部分镜腿，设置为1是显示完整镜腿，index：动态试戴窗口的index*/
- (void)Engine_UpdateFeatherDistance:(float)value ToViewByIndex:(NSInteger)index;

/**调整眼镜大小，value：参数范围是0-1，设置为0时最小，设置为1时最大，推荐初始值设置为0.5，index：动态试戴窗口的index*/
- (void)Engine_UpdateGlassModelScale:(float)value ToViewByIndex:(NSInteger)index;

- (void)setLicense:(NSString *)Client_id andSecret:(NSString *)Clicent_secret;

- (void)downGstForFlag:(NSString *)modelFlag ToSavePath:(NSString *)savePath :(finishDownGstBlock)finishDown;

- (void)releaseEngineToIndex:(int)index;

/**
 *  @brief 保存日志，参数为空默认保存至 NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject/topglasses.log
 *
 *  filePath： 保存日志的路径
 */
- (void)saveLogToFile:(NSString *)filePath;

/**返回当前的渲染图片*/
- (UIImage *)snapshotImage;

- (void)inputFrameData:(GLubyte *)gluint;
@end
