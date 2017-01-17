//
//  UIImage+resize.h
//  Papyrus
//
//  Created by Jeethu Rao on 1/4/12.
//  Copyright (c) 2012 Trellisys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_resize)
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)AppBarScaletoFill:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;
+ (UIImage*)imageImmediateLoadWithContentsOfFile:(NSString*)path;
+(UIImage*) makeBlurImage:(UIImage*)theImage BlurValue:(CGFloat)blurValue;
+(UIImage*)imageViewWithOverlay:(UIImage*)theImage OverlyColor:(UIColor*)colorOverlay Alpha:(CGFloat)alpha;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+(CGRect)imageBottomAlign :(CGSize)viewSize FrameSize:(CGSize)frameSize;
+(UIImage *) imageFromColor: (NSString *)strColor;
+(UIImage*)getRezisedImage:(CGSize)newSize filePath:(NSString*)filePath;
-(UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
