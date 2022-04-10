//
//  LayerLabel.m
//  火柴人
//
//  Created by 盘书焱 on 2022/3/27.
//  Copyright © 2022 tz. All rights reserved.
//

#import "LayerLabel.h"

// 这样写比UILabel的性能要高一点
@implementation LayerLabel

// 重写这个方法是因为，底层会根据这个方法返回的类型创建contents
+ (Class)layerClass
{
    return [CATextLayer class];
}
- (CATextLayer *)textlayer
{
    return (CATextLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    [self textlayer].alignmentMode = kCAAlignmentJustified;
    
    [self textlayer].wrapped = YES;
    [self.layer display]; // force redisplay
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // suported creat by nib
    [self setup];
}

- (void)setText:(NSString *)text
{
    super.text = text;
    
    [self textlayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    super.textColor = textColor;
    [self textlayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textlayer].font = fontRef;
    [self textlayer].fontSize = font.pointSize;
    CGFontRelease(fontRef);
}

@end
