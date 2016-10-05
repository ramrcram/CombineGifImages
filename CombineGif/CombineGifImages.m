//
//  CombineGifImages.m
//  CombineGif
//
//  Created by Ramesh on 05/10/16.
//  Copyright © 2016 Trellisys. All rights reserved.
//

#import "CombineGifImages.h"

@implementation CombineGifImages
{
    NSTimeInterval total_d;
    NSMutableArray* ns_Images;
    
    NSMutableArray* dirty_Images;
    NSMutableArray* combined_Images;
    NSTimeInterval combined_duration;
}

#pragma mark Public Methods
-(BOOL)isStartTimeMeetCombineTime:(NSArray*)gifCollections
{
    BOOL isMeet = NO;
    for (NSDictionary* dictCollecction in gifCollections) {
        NSTimeInterval startTime = [[dictCollecction objectForKey:@"StartTime"] doubleValue];
        if ( combined_duration >= startTime && startTime > 0) {
            isMeet = YES;
            break;
        }
    }
    return isMeet;
}
- (UIImage*)doImageCombine:(NSArray*)gifCollections{
    
    ns_Images = [[NSMutableArray alloc] init];
    combined_Images = [[NSMutableArray alloc] init];
    dirty_Images = [[NSMutableArray alloc] init];
    
    NSMutableArray* arrayList = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dictCollecction in gifCollections) {
        NSData* dictData = [dictCollecction objectForKey:@"GifData"];
        [self animatedGIFWithDuration:dictData OutArray:&arrayList];
    }
    
    int index =0;
    for (NSDictionary* dictCollecction in gifCollections) {
        //NSTimeInterval startTime = [[dictCollecction objectForKey:@"StartTime"] doubleValue];
        NSArray* arrayCollecction = arrayList[index];
        index = index+1;
        BOOL dirtyFlag = NO;
        for (NSMutableDictionary* dict in arrayCollecction) {
            combined_duration  += [[dict objectForKey:@"duration"] doubleValue];
            
            if (dirty_Images && [dirty_Images count] > 0 && dirtyFlag == NO) {
                UIImage* img_Dirty = [dirty_Images firstObject];
                if (img_Dirty) {
                    //                    UIImage* img_Dirty = [dict_dirty objectForKey:@"images"];
                    UIImage* img_Combine = [dict objectForKey:@"images"];
                    UIImage* img = [self combineImages:img_Dirty Image2:img_Combine];
                    [combined_Images addObject:img];
                }
                [dirty_Images removeObjectAtIndex:0];
            }else if ([self isStartTimeMeetCombineTime:gifCollections]) {
                [dirty_Images addObject:[dict objectForKey:@"images"]];
                dirtyFlag = YES;
            }else{
                [combined_Images addObject:[dict objectForKey:@"images"]];
            }            
        }
    }
    
    return [UIImage animatedImageWithImages:combined_Images duration:total_d];
}

#pragma mark Private Methods

//-(UIImage*)combineImages:(UIImage*)img_1 Image2:(UIImage*)img_2{
//    
//    CGSize newSize = CGSizeMake(MAX(img_1.size.width,img_2.size.width) * 2, MAX(img_1.size.height,img_2.size.height)* 2);
//    
//    UIView* viewObj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
//    viewObj.backgroundColor = [UIColor clearColor];
//
//    UIImageView* imgView = [[UIImageView alloc] initWithImage:img_1];
//    imgView.frame = viewObj.frame;
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [viewObj addSubview:imgView];
//    
//    imgView.image = img_2;
//    
//    [viewObj addSubview:imgView];
//    
//    UIGraphicsBeginImageContextWithOptions(viewObj.bounds.size, NO, 0.0);
//    [viewObj.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
////    UIGraphicsEndImageContext();
////    
////    
////    UIGraphicsBeginImageContext( newSize );
////    
////    if (img_1.size.width >= img_2.size.width ||
////        img_1.size.height >= img_2.size.height) {
////        // Use existing opacity as is
////        [img_1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
////        
////        // Apply supplied opacity if applicable
////        [img_2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
////        
////    }else{
////        [img_2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
////        
////        [img_1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
////    }
////    
////    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
////    
////    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

-(UIImage*)combineImages:(UIImage*)img_1 Image2:(UIImage*)img_2{
    
    CGSize newSize = CGSizeMake(MAX(img_1.size.width,img_2.size.width) * 2, MAX(img_1.size.height,img_2.size.height)* 2);
    UIGraphicsBeginImageContext( newSize );
    
    if (img_1.size.width >= img_2.size.width ||
        img_1.size.height >= img_2.size.height) {
        // Use existing opacity as is
        [img_1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        // Apply supplied opacity if applicable
        [img_2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
        
    }else{
        [img_2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        [img_1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSMutableArray*)animatedGIFWithDuration:(NSData *)data OutArray:(NSMutableArray**)outArray {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray *images = [NSMutableArray array];
    if (outArray == nil) {
        *outArray = [[NSMutableArray alloc] init];
    }
    
    float duration = 0.0f;
    
    for (size_t i = 0; i < count; i++) {
        
        NSMutableDictionary *imgDict = [[NSMutableDictionary alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        duration = [self frameDurationAtIndex:i source:source];
        total_d += duration;
        
        [imgDict setObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]
                    forKey:@"images"];
        [imgDict setObject:[NSString stringWithFormat:@"%f",duration] forKey:@"duration"];
        
        [ns_Images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
        
        CGImageRelease(image);
        
        [images addObject:imgDict];
        imgDict = nil;
    }
    
    [*outArray addObject:images];
    CFRelease(source);
    
    return images;
}

- (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
