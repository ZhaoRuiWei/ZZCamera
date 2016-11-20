//
//  ViewController.m
//  ZZCamera
//
//  Created by 赵瑞玮 on 16/11/20.
//  Copyright © 2016年 zhaoruiwei. All rights reserved.
//

#import "ViewController.h"
#import "UIView+RMAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)makePhotoBtnClick:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera andCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
}

- (IBAction)toPhotoBtnClick:(id)sender {
    
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary andCameraCaptureMode:0];
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType andCameraCaptureMode:(UIImagePickerControllerCameraCaptureMode)mode{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //这是 VC 的各种 modal 形式
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerController.sourceType = sourceType;
    //支持的摄制类型,拍照或摄影,此处将本设备支持的所有类型全部获取,并且同时赋值给imagePickerController的话,则可左右切换摄制模式
    imagePickerController.delegate = self;
    //允许拍照后编辑
    imagePickerController.allowsEditing = YES;

    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        //设置模式-->拍照/摄像
        imagePickerController.cameraCaptureMode = mode;
        //开启默认摄像头-->前置/后置
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //设置默认的闪光灯模式-->开/关/自动
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        NSLog(@"image...");
        
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self saveImage:edit];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//取消屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark save

- (void)saveImage:(UIImage *)img
{
    [[[ALAssetsLibrary alloc]init] writeImageToSavedPhotosAlbum:[img CGImage] orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Save image fail：%@",error);
        }else{
            NSLog(@"Save image succeed.");
        }
    }];
    
}

@end
