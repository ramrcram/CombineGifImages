//
//  UIImage+UIImage_resize.m
//  Papyrus
//
//  Created by Jeethu Rao on 1/4/12.
//  Copyright (c) 2012 Trellisys. All rights reserved.
//

#import "UIImage+resize.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CIImage.h>
#import "UIColor+colorWithHexString.h"
#import "UIImage+StackBlur.h"

#define ASPECT_RATIO(x) (x.height/x.width)

@implementation UIImage (UIImage_resize)

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size {
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
	float scaleFactor = rectAr > imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
	CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    float xpos = (size.width-scaledSize.width)/2;
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(xpos, 0, scaledSize.width, scaledSize.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    return scaledImage; 
}

+(UIImage *) imageFromColor: (NSString *)strColor{
    UIColor *color = [UIColor colorWithHexStr:strColor];
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size {
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
    
    //tried fixing this by changing the if condition
	float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);

    float ypos = (size.height-scaledSize.height)/2;
    float xpos = (size.width-scaledSize.width)/2;
    
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )]; 
 
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
   
    UIGraphicsEndImageContext(); 
    return scaledImage; 
}

+(UIImage *)AppBarScaletoFill:(UIImage *)image toSize:(CGSize)size {
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
    
    //tried fixing this by changing the if condition
	float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    float ypos = 0;
    float xpos = (size.width-scaledSize.width)/2;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);  
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
//    CGContextRelease(context);
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*)imageImmediateLoadWithContentsOfFile:(NSString*)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    CGImageRef imageRef = [image CGImage];
    CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       CGImageGetBitsPerComponent(imageRef),
                                                       CGImageGetBytesPerRow(imageRef),
                                                       CGImageGetColorSpace(imageRef),
                                                       CGImageGetBitmapInfo(imageRef)
                                                       );
    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    CGContextRelease(bitmapContext);
    [image release];
    return decompressedImage;
}

+(UIImage*) makeBlurImage:(UIImage*)theImage BlurValue:(CGFloat)blurValue{
    /*
    // create our blurred image
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
        
        // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:blurValue] forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        
        // CIGaussianBlur has a tendency to shrink the image a little,
        // this ensures it matches up exactly to the bounds of our original image
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        return [UIImage imageWithCGImage:cgImage];*/
    return [theImage stackBlur:blurValue];
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    //@autoreleasepool {
        CGImageRef cropped = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect);
        UIImage *retImage = [UIImage imageWithCGImage: cropped];
        CGImageRelease(cropped);
        return retImage;
    //}
}

+(UIImage*)imageViewWithOverlay:(UIImage*)theImage OverlyColor:(UIColor*)colorOverlay Alpha:(CGFloat)alpha {

    if(!theImage)
        return theImage;
    //@autoreleasepool {
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(theImage.size, NO, theImage.scale);
        
        // draw current image
        [theImage drawAtPoint:CGPointZero];
        
        // determine bounding box of current image
        CGRect rect = CGRectMake(0, 0, theImage.size.width, theImage.size.height);
        
        // get drawing context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // flip orientation
        CGContextTranslateCTM(context, 0.0, theImage.size.height);
        CGContextScaleCTM(context, 1.0,-1.0);
        
        // set overlay
    CGContextSetAlpha(context, alpha);//0.60);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextClipToMask(context, rect, theImage.CGImage);
        CGContextSetFillColorWithColor(context, colorOverlay.CGColor);
        CGContextFillRect(context, rect);
        context = nil;
    
        // save drawing-buffer
        UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // end drawing context
        UIGraphicsEndImageContext();
        
        return returnImage;
    //}
}
+(CGRect)imageBottomAlign :(CGSize)viewSize FrameSize:(CGSize)frameSize
{
    CGSize imageSize = viewSize;
    CGRect resultFrame = CGRectZero;
    BOOL imageSmallerThanFrame = (imageSize.width < frameSize.width) && (imageSize.height < frameSize.height);
    if (imageSmallerThanFrame == YES)
    {
        resultFrame.size = imageSize;
    }
    else
    {
        CGFloat widthRatio  = roundf(imageSize.width  / frameSize.width);
        CGFloat heightRatio = roundf(imageSize.height / frameSize.height);
        CGFloat maxRatio = MAX(widthRatio, heightRatio);
        
        resultFrame.size = (CGSize){ roundf(imageSize.width / maxRatio), roundf(imageSize.height / maxRatio) };
    }
    //resultFrame.size = viewSize;
    resultFrame.origin  = (CGPoint) {roundf(0), roundf(frameSize.height - resultFrame.size.height) };
    return resultFrame;
}
+(UIImage*)getRezisedImage:(CGSize)newSize filePath:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    UIImage* resizedImage = nil;
    NSString* retinaImageName =nil;
    
    UIImage* unresizedImage = [UIImage imageWithContentsOfFile:filePath];
    NSString* imgPathExtension = [filePath pathExtension];
    if ([filePath rangeOfString:@"@2x"].location == NSNotFound ){
        retinaImageName = [filePath stringByAppendingString:[NSString stringWithFormat:@"@2x.%@",imgPathExtension]];
    }else{
        retinaImageName = filePath;
    }
    if (![fileManager fileExistsAtPath:retinaImageName]) {
        // if file doesnt have 2x suffixed and no file exists with 2x
        resizedImage = [UIImage scale:unresizedImage toSize:newSize];
    }else  if ([filePath isEqualToString:retinaImageName]){
        BOOL retinaimgFileExists = [fileManager fileExistsAtPath:filePath];
        if (retinaimgFileExists) {
            resizedImage = [UIImage imageWithCGImage:unresizedImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
        }else{
            resizedImage = [UIImage scale:unresizedImage toSize:newSize];
        }
    }else if ([fileManager fileExistsAtPath:retinaImageName]) {
        if ([UIScreen mainScreen].scale==2) {
            resizedImage = [UIImage imageWithCGImage:unresizedImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
        }
        
    }else{
        resizedImage = [UIImage scale:unresizedImage toSize:newSize];
    }
    return resizedImage;
}
-(UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 640;
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > kMaxResolution || height > kMaxResolution)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width,
                                                         imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height,
                                                         imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:@"Invalid image orientation" format:@""];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width,
                                                                 height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
@end
