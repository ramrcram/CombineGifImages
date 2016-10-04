//
//  ViewController.m
//  CombineGif
//
//  Created by Ramesh on 02/10/16.
//  Copyright © 2016 Trellisys. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LinkedListStack.h"

@interface ViewController ()
{
    NSTimeInterval total_d;
    NSMutableArray* ns_Images;
    
    NSMutableArray* dirty_Images;
    NSMutableArray* combined_Images;
    NSTimeInterval combined_duration;
}
@property (weak, nonatomic) IBOutlet UIImageView *animatedImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnStartClick:(id)sender {
    
    ns_Images = [[NSMutableArray alloc] init];
    combined_Images = [[NSMutableArray alloc] init];
    dirty_Images = [[NSMutableArray alloc] init];

    /*Gif image - 1  */
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Thermo" ofType:@"gif"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSMutableArray* arrayList_1 = [self animatedGIFWithDuration:data];
    
    /*Gif image - 2  */
    path=[[NSBundle mainBundle] pathForResource:@"drillAnimation" ofType:@"gif"];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSMutableArray* arrayList_2 = [self animatedGIFWithDuration:data];
    
    /*Gif image - 3  */
    path=[[NSBundle mainBundle] pathForResource:@"Spiral" ofType:@"gif"];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSMutableArray* arrayList_3 = [self animatedGIFWithDuration:data];
    
//    /*Gif image - 1  */
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"Thermo" ofType:@"gif"];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
//    LinkedListStack* arrayList_1 = [self animatedGIFWithDuration:data];
//    
//    /*Gif image - 2  */
//    path=[[NSBundle mainBundle] pathForResource:@"drillAnimation" ofType:@"gif"];
//    data = [[NSFileManager defaultManager] contentsAtPath:path];
//    LinkedListStack* arrayList_2 = [self animatedGIFWithDuration:data];
//    
//    /*Gif image - 3  */
//    path=[[NSBundle mainBundle] pathForResource:@"Spiral" ofType:@"gif"];
//    data = [[NSFileManager defaultManager] contentsAtPath:path];
//    LinkedListStack* arrayList_3 = [self animatedGIFWithDuration:data];
    
    float timeLap_2 = 5.0;
    combined_duration = 0.0;
    
    NSNumberFormatter * nFormatter = [[NSNumberFormatter alloc] init];
    [nFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    /*NSDictionary* dictObj = nil;
    while ([arrayList_1 popFront:&dictObj] != INVALID_NODE_CONTENT)
    {
        combined_duration  += [[dictObj objectForKey:@"duration"] doubleValue];
        if ( combined_duration >= timeLap_2 ) {
            [dirty_Images addObject:[dictObj objectForKey:@"images"]];
        }else{
            [combined_Images addObject:[dictObj objectForKey:@"images"]];
        }
    }
    
    while ([arrayList_2 popFront:&dictObj] != INVALID_NODE_CONTENT)
    {
        combined_duration  += [[dictObj objectForKey:@"duration"] doubleValue];
        if ( combined_duration >= timeLap_2 ) {
            [dirty_Images addObject:[dictObj objectForKey:@"images"]];
        }else{
            if (dirty_Images && [dirty_Images count] > 0) {
                UIImage* img_Dirty = [dirty_Images firstObject];
                if (img_Dirty) {
                    //                    UIImage* img_Dirty = [dict_dirty objectForKey:@"images"];
                    UIImage* img_Combine = [dictObj objectForKey:@"images"];
                    UIImage* img = [self combineImages:img_Dirty Image2:img_Combine];
                    [combined_Images addObject:img];
                }
                [dirty_Images removeObjectAtIndex:0];
            }else{
                [combined_Images addObject:[dictObj objectForKey:@"images"]];
            }
        }
    }
    
    while ([arrayList_3 popFront:&dictObj] != INVALID_NODE_CONTENT)
    {
        if (dirty_Images && [dirty_Images count] > 0) {
            UIImage* img_Dirty = [dirty_Images firstObject];
            if (img_Dirty) {
                //UIImage* img_Dirty = [dict_dirty objectForKey:@"images"];
                UIImage* img_Combine = [dictObj objectForKey:@"images"];
                UIImage* img = [self combineImages:img_Dirty Image2:img_Combine];
                [combined_Images addObject:img];
            }
            [dirty_Images removeObjectAtIndex:0];
        }else{
            [combined_Images addObject:[dictObj objectForKey:@"images"]];
        }
    }
    self.animatedImage.image = [UIImage animatedImageWithImages:combined_Images duration:total_d];
    */
    
    for (NSMutableDictionary* dict in arrayList_1) {
        combined_duration  += [[dict objectForKey:@"duration"] doubleValue];
        if ( combined_duration >= timeLap_2 ) {
            [dirty_Images addObject:[dict objectForKey:@"images"]];
        }else{
            [combined_Images addObject:[dict objectForKey:@"images"]];
        }
    }
    
    for (NSMutableDictionary* dict in arrayList_2) {
        combined_duration  += [[dict objectForKey:@"duration"] doubleValue];
        if ( combined_duration >= timeLap_2 ) {
            [dirty_Images addObject:[dict objectForKey:@"images"]];
        }else{
            if (dirty_Images && [dirty_Images count] > 0) {
                UIImage* img_Dirty = [dirty_Images firstObject];
                if (img_Dirty) {
                    //                    UIImage* img_Dirty = [dict_dirty objectForKey:@"images"];
                    UIImage* img_Combine = [dict objectForKey:@"images"];
                    UIImage* img = [self combineImages:img_Dirty Image2:img_Combine];
                    [combined_Images addObject:img];
                }
                [dirty_Images removeObjectAtIndex:0];
            }else{
                [combined_Images addObject:[dict objectForKey:@"images"]];
            }
        }
    }
    for (NSMutableDictionary* dict in arrayList_3) {
        if (dirty_Images && [dirty_Images count] > 0) {
            UIImage* img_Dirty = [dirty_Images firstObject];
            if (img_Dirty) {
                //UIImage* img_Dirty = [dict_dirty objectForKey:@"images"];
                UIImage* img_Combine = [dict objectForKey:@"images"];
                UIImage* img = [self combineImages:img_Dirty Image2:img_Combine];
                [combined_Images addObject:img];
            }
            [dirty_Images removeObjectAtIndex:0];
        }else{
            [combined_Images addObject:[dict objectForKey:@"images"]];
        }
    }
    
    self.animatedImage.image = [UIImage animatedImageWithImages:combined_Images duration:total_d];
}

-(UIImage*)combineImages:(UIImage*)img_1 Image2:(UIImage*)img_2{
    
    CGSize newSize = CGSizeMake(MAX(img_1.size.width,img_2.size.width), MAX(img_1.size.height,img_2.size.height));
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

- (NSMutableArray*)animatedGIFWithDuration:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray *images = [NSMutableArray array];
    
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
    
    CFRelease(source);
    
    return images;
}

/*- (LinkedListStack*)animatedGIFWithDuration:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
//    NSMutableArray *images = [NSMutableArray array];
    LinkedListStack *points = [[LinkedListStack alloc] initWithCapacity:500 incrementSize:500 andMultiplier:500];
    
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
        
        [points pushFrontX:imgDict];
        imgDict = nil;
        
//        [images addObject:imgDict];
    }
    
    CFRelease(source);
    
    return points;
}*/

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
