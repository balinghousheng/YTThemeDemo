//
//  UIImage+YTExtension.m
//
//  Copyright (c) 2015年 xx公司. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UIImage+YTExtension.h"

@implementation UIImage (YTExtension)

#pragma mark - 填充
/**
 *  同比填充
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size {
    return [self aspectFill:size offset:0];
}

/**
 *  同比填充
 *
 *  @param size   <#size description#>
 *  @param offset <#offset description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size offset:(CGFloat)offset {
    int W = size.width;
    int H = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;

    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);

    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4 * W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight) {
        W = size.height;
        H = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }

    double ratio = MAX(W / (double)W0, H / (double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;

    int dW = abs((W0 - W) / 2);
    int dH = abs((H0 - H) / 2);

    if (dW == 0) {
        dH += offset;
    }

    if (dH == 0) {
        dW += offset;
    }

    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored) {
        CGContextRotateCTM(bitmap, M_PI / 2);
        CGContextTranslateCTM(bitmap, 0, -H);
    } else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored) {
        CGContextRotateCTM(bitmap, -M_PI / 2);
        CGContextTranslateCTM(bitmap, -W, 0);
    } else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored) {
        // Nothing
    } else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored) {
        CGContextTranslateCTM(bitmap, W, H);
        CGContextRotateCTM(bitmap, -M_PI);
    }

    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:ref];

    CGContextRelease(bitmap);
    CGImageRelease(ref);

    return newImage;
}


#pragma mark - 缩放
/**
 *  等比例缩放
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)zoom:(CGSize)size {
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    if (width <= size.width && height <= size.height) {
        // no need to compress.
        return self;
    }

    if (width == 0 || height == 0) {
        // void zero exception
        return self;
    }

    UIImage *newImage = nil;
    CGFloat widthFactor = size.width / width;
    CGFloat heightFactor = size.height / height;
    CGFloat scaleFactor = 0.0;

    if (widthFactor > heightFactor) {
        scaleFactor = heightFactor; // scale to fit height
    } else {
        scaleFactor = widthFactor; // scale to fit width
    }

    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize newtargetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(newtargetSize); // this will crop

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    // pop the context to get back to the default
    UIGraphicsEndImageContext();

    return newImage;
}


#pragma mark - 压缩
/**
 *  压缩
 *
 *  @param compressionQuality 0.0 ≤ t ≤ 1.0
 *
 *  @return <#return value description#>
 */
- (NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0.0);
    return UIImageJPEGRepresentation(self, compressionQuality);
}

#pragma mark - 图片转正
/**
 *  图片转正
 *
 *  @return <#return value description#>
 */
- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
    default:
        break;
    }

    switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    default:
        break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
