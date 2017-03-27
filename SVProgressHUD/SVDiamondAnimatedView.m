//
//  SVDiamondAnimatedView.m
//  SVProgressHUD
//
//  Created by Dwi Aprianto on 3/27/17.
//
//

#import "SVDiamondAnimatedView.h"
#import "SVProgressHUD.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface SVDiamondAnimatedView()

@property (nonatomic, strong)CAShapeLayer *ringAnimatedLayer;
@property (strong, nonatomic)FLAnimatedImageView *imageView;
@property (strong, nonatomic)FLAnimatedImage *diamondGif;
@end

@implementation SVDiamondAnimatedView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self layoutDiamondGif];
    } else {
        [_imageView removeFromSuperview];
        _diamondGif = nil;
        _ringAnimatedLayer = nil;
    }
}

- (void)layoutDiamondGif{
    CALayer *layer = self.ringAnimatedLayer;
    if(!_imageView){
        self.imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
        self.imageView.animatedImage = self.diamondGif;
    }
    self.imageView.frame = layer.frame;
    if(self.imageView.superview == nil){
        [self addSubview:self.imageView];
    }
}

- (NSData *)diamondGif{
    if(!_diamondGif){
        NSBundle *bundle = [NSBundle bundleForClass:[SVProgressHUD class]];
        NSURL *url = [bundle URLForResource:@"SVProgressHUD" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        NSData * animationData = [NSData dataWithContentsOfFile:[imageBundle pathForResource:@"diamond" ofType:@"gif"]];
        _diamondGif = [FLAnimatedImage animatedImageWithGIFData:animationData];
    }
    return _diamondGif;
}

- (CAShapeLayer*)ringAnimatedLayer {
    if(!_ringAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.radius, self.radius);
        _ringAnimatedLayer = [CAShapeLayer layer];
        _ringAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _ringAnimatedLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
    }
    return _ringAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        
        if(self.superview) {
            [self layoutDiamondGif];
        }
    }
    
}

- (void)setRadius:(CGFloat)radius {
    if(radius != _radius) {
        _radius = radius;
        
        [_ringAnimatedLayer removeFromSuperlayer];
        _ringAnimatedLayer = nil;
        
        if(self.superview) {
            [self layoutDiamondGif];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius)*2, (self.radius)*2);
}



@end
