//
//  ViewController.m
//  火柴人
//
//  Created by Dean on 2018/7/28.
//  Copyright © 2018年 tz. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()<CAAnimationDelegate, CALayerDelegate>
{
    CALayer *_layer;
}
/** 点赞按钮 */
@property (strong, nonatomic) UIButton *likeBtn;
/** 粒子图层 */
@property (strong, nonatomic) CAEmitterLayer *emitterLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CFAbsoluteTime time1 =  CFAbsoluteTimeGetCurrent();
    CALayer *layer = [CALayer layer];
    
    layer.frame = CGRectMake(200, 500, 100, 100);
    UIImage *image = [UIImage imageNamed:@"default"];
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    layer.shadowOpacity = 0.5;
    
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsScale = 0.8;//image.scale;//[UIScreen mainScreen].scale;
    
    //CGRectMake(0, 0, 0.5, 0.5);CGRectMake(0.5, 0, 0.5, 0.5);CGRectMake(0, 0.5, 0.5, 0.5);CGRectMake(0.5, 0.5, 0.5, 0.5);
    // 默认全部显示
    // 可以提高载入性能，单张大图比多张小图载入更快
    layer.contentsRect = CGRectMake(0, 0, 1, 1);
    layer.masksToBounds = YES;
    //layer.delegate = self;
    layer.maskedCorners = 20;
    [self.view.layer addSublayer:layer];
    NSLog(@"1 === %f ===", CFAbsoluteTimeGetCurrent() - time1);
    //[layer display]; // 强制layer重绘，一般不用，而是通过继承UIView，重写-drawInRect:方法
    NSLog(@"2 === %f ===", CFAbsoluteTimeGetCurrent() - time1);
    //layer.anchorPoint // 锚点
    //layer.positon
    _layer = layer;
    
    // 2D二维空间旋转
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(M_PI); // 旋转180度
    transfrom = CGAffineTransformScale(transfrom, 0.5, 0.5); // 缩小50%
    transfrom = CGAffineTransformTranslate(transfrom, 110, 0); // 向右移110个像素，向左移是负的-100，向下移负的-100，向上移100
    // 混合两个变换
    //CGAffineTransform transfrom3 = CGAffineTransformConcat(transfrom, transfrom1);
//    [layer setAffineTransform: transfrom];
    
    // 3D三维空间旋转
    CATransform3D tf3d = CATransform3DIdentity;
    tf3d.m34 = -1.0/500.0;
    // 参数1，旋转角度，x, y, z   （0，0，1）表示沿着z轴旋转
    tf3d = CATransform3DRotate(tf3d,M_PI_4, 0, 1, 0);
    //tf3d = CATransform3DScale(tf3d,0.5, 1, 1);
    
    layer.transform = tf3d;
    
    [self cubeLayer];
    
    [self textLayer];
    [self firePeople];
    [self likeBtnCreat];
}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    // create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    CGFloat red = rand()/(double)INT_MAX;
    CGFloat green = rand()/(double)INT_MAX;
    CGFloat blue = rand()/(double)INT_MAX;
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    face.transform = transform;
    
    return face;
}
- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    CATransformLayer *cube = [CATransformLayer layer];
    
    //add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];

    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];

    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];

    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];

    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];

    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];

    //center the cube layer within the container
    CGSize containerSize = self.view.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);

    //apply the transform and return
    cube.transform = transform;
    
    return cube;
}
- (void)cubeLayer
{
    //set up the perspective transform
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = pt;

    //set up the transform for cube 1 and add it
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];

    //set up the transform for cube 2 and add it
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cube2];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    // 方法1
//    point = [self.view.layer convertPoint:point toLayer:_layer];
//    NSLog(@"%@ ==== %@", NSStringFromCGPoint(point), [_layer containsPoint:point]?@"包含":@"不包含");
    
    // 方法2
    CALayer *layer = [_layer hitTest:point];
    NSLog(@"++++++ ==== %@", layer == _layer?@"包含":@"不包含");
    
}


#pragma mark - CALayerDelegate
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)likeBtnCreat
{
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake(250, 250, 50, 50);
    [self.likeBtn setImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.likeBtn];
    
    [self explosion];
}
/**
 点赞动画拆解：
 1、图片改变了
 2、图片大小变了
 3、爆炸粒子效果
 */

- (void)likeClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 大小变了
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.removedOnCompletion = YES;
    anim.delegate = self;
    if (sender.selected) {
        anim.values = @[@1.5, @0.8, @1.0, @1.2, @1];
        anim.duration = 0.6;
        [self addExplosionAnim];
    }else{
        anim.values = @[@0.8, @1];
        anim.duration = 0.4;
    }
    [self.likeBtn.layer addAnimation:anim forKey:@"likeAnim"];
}

- (void)addExplosionAnim
{
    self.emitterLayer.beginTime = CACurrentMediaTime();
    self.emitterLayer.birthRate = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emitterLayer.birthRate = 0;
    });
}
// 粒子
- (void)explosion
{
    self.emitterLayer = [CAEmitterLayer layer];
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.name = @"explosionCell";
    cell.lifetime = 0.6f;
    cell.birthRate = 500; //
    cell.velocity = 50; // 初速度
    cell.velocityRange = 15; // 速度范围
    cell.scale = 0.1;
    cell.scaleRange = 0.05;
    cell.contents = (__bridge id)[UIImage imageNamed:@"sparkle"].CGImage;
    
    self.emitterLayer.name = @"explosionLayer";
    self.emitterLayer.emitterShape = kCAEmitterLayerCircle; // 发射圆形
    self.emitterLayer.emitterMode = kCAEmitterLayerOutline;
    self.emitterLayer.emitterSize = CGSizeMake(25, 0);
    self.emitterLayer.emitterCells = @[cell];
    self.emitterLayer.renderMode = kCAEmitterLayerOldestLast;
    self.emitterLayer.masksToBounds = NO;
    self.emitterLayer.birthRate = 0;
    self.emitterLayer.zPosition = 0;
    self.emitterLayer.position = CGPointMake(CGRectGetWidth(self.likeBtn.bounds)/2, CGRectGetHeight(self.likeBtn.frame)/2);
    
    [self.likeBtn.layer addSublayer:self.emitterLayer];
}


#pragma mark - CAAnimationDelegate
//- (void)animationDidStart:(CAAnimation *)anim
//{
//
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if ([anim valueForKey:@"likeAnim"]) {
//
//    }
//}


- (void)textLayer{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(200, 75, 150, 25);
    textLayer.backgroundColor = [UIColor orangeColor].CGColor;
//    textLayer.string = @"hello world";
    textLayer.alignmentMode = kCAAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:36];
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //textLayer.wrapped = YES;
//    textLayer.fontSize = [UIFont systemFontOfSize:36.0].pointSize;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:textLayer];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"hello world"];
    NSDictionary *attribs = @{(id)kCTForegroundColorAttributeName: (id)[UIColor redColor].CGColor};
    [str setAttributes:attribs range:NSMakeRange(0, 5)];
    textLayer.string = str;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
}

- (void)shapeLayer{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.fillColor = nil;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    [self.view.layer addSublayer:shapeLayer];
    
}

- (void)firePeople
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(100, 250)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(200, 250)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 10;
    shapeLayer.fillColor = nil;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    [self.view.layer addSublayer:shapeLayer];
    shapeLayer.shadowOpacity = 1;
    shapeLayer.shadowRadius = 10;
    shapeLayer.shadowOffset = CGSizeMake(0, 5);
    
    
}

@end
