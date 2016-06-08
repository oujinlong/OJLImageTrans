//
//  OJLProgressAnimationImageView.m
//  ImageChange
//
//  Created by oujinlong on 16/6/8.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "OJLProgressAnimationImageView.h"
typedef enum {
    OJLProgressAnimationImageViewTypeGray = 0, //黑白
    OJLProgressAnimationImageViewTypeOrigion = 1 //原色
}OJLProgressAnimationImageViewType;
@interface OJLProgressAnimationImageView ()
@property (nonatomic, strong) UIImage* origionImage;
@end
@implementation OJLProgressAnimationImageView



-(instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.origionImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        self.origionImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
    }
    return self;
}

-(void)startAnimationWithProgress:(CGFloat)progress{
    self.image = [self grayscale:self.origionImage type:OJLProgressAnimationImageViewTypeGray progress:progress];
}


- (UIImage*)grayscale:(UIImage*)anImage type:(OJLProgressAnimationImageViewType)type progress:(CGFloat)progress{
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height - progress * height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case OJLProgressAnimationImageViewTypeGray:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
