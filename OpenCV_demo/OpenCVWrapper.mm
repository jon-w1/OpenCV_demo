//
//  OpenCVWrapper.mm
//  OpenCV_demo
//

#import <OpenCV/opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper

/*
 "Public" method available to outside callers
 */
+ (UIImage *)grayscaleFromImage:(UIImage*)image{
	cv::Mat matrix = [self cvMatFromUIImage:image];
	
	cv::Mat resultMatrix;
	
	/*
	 * Add OpenCV method calls for processing/filtering
	 */
	cv::cvtColor(matrix, resultMatrix, CV_BGR2GRAY, 4);
	
	
	// convert modified matrix back to UIImage
	return [self UIImageFromCVMat:resultMatrix];
}

/*
 Get the cvMatrix from an image
 */
+ (cv::Mat)cvMatFromUIImage:(UIImage*)image{
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
	CGFloat cols = image.size.width;
	CGFloat rows = image.size.height;
	
	cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
	CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,     // Pointer to data
													cols,           // Width of bitmap
													rows,           // Height of bitmap
													8,              // Bits per component
													cvMat.step[0],  // Bytes per row
													colorSpace,     // Color space
													kCGImageAlphaNoneSkipLast
													| kCGBitmapByteOrderDefault); // Bitmap info flags
	
	CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
	CGContextRelease(contextRef);
	return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat{
	NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
	
	CGColorSpaceRef colorspace;
	
	if (cvMat.elemSize() == 1) {
		colorspace = CGColorSpaceCreateDeviceGray();
	}else{
		colorspace = CGColorSpaceCreateDeviceRGB();
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	
	// Create CGImage from cv::Mat
	CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorspace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
	
	// get uiimage from cgimage
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorspace);
	return finalImage;
}

@end

