//
//  ZJPopAnimationViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJPopAnimationViewController.h"


#define KAnimationTime 0.25
@interface ZJPopAnimationViewController ()

@property (nonatomic,strong)NSMutableArray *viewsArr;

@end

@implementation ZJPopAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewsArr = [NSMutableArray array];
    
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc]init];
        view.bounds = CGRectMake(0, 0, 200, 200);
        view.center = CGPointMake(ScreenWidth/2, 200+i*5);
        view.backgroundColor = [self getRandomColor];
        [self.view addSubview:view];
        [self.viewsArr addObject:view];
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panChange:)];
    [self.view addGestureRecognizer:pan];
    
}

-(void)panChange:(UIPanGestureRecognizer*)recongizer{
    
    UIView *view = self.viewsArr[self.viewsArr.count-1];
    CGPoint point = [recongizer translationInView:view];
    view.center = CGPointMake(view.center.x+point.x, view.center.y+point.y);
    //偏移的百分比
    CGFloat XOffPercent = (view.center.x-CGRectGetWidth(self.view.bounds)/2)/(CGRectGetWidth(self.view.bounds)/2);
    CGFloat rotationAngle = M_PI_2/4*XOffPercent;
    NSLog(@"输出的百分比----===%f",rotationAngle);
    CGFloat alpha = fabs(rotationAngle);
//    [self setViewAlpha:(1-alpha) view:view];
    [self setViewAlpha:(1-alpha) duration:0.001f view:view];
    [self setRotationWithAngle:rotationAngle duration:0.001f view:view];
    //重置刚才的那个point为零
    [recongizer setTranslation:CGPointZero inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded){
        if (view.center.x > 60 && view.center.x<CGRectGetWidth(self.view.bounds)-60) {
            //回到原来的位置
            [self setViewAlpha:1 duration:0.001f view:view];
            [self setRotationWithAngle:0 duration:0.001f view:view];
            CGPoint centerP = CGPointMake(CGRectGetWidth(self.view.frame)/2, 200+3*5);
            [self setCenter:centerP duration:0.15 view:view];
            
        }else{
            //删除view下一个view替换
            [view removeFromSuperview];
            [self.viewsArr removeLastObject];
            
        }
    }
    
}

#pragma mark -旋转动画
-(void)setRotationWithAngle:(CGFloat)angle duration:(CGFloat)duration view:(UIView*)cardView{
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.duration = duration;
    rotation.toValue = @(angle);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [cardView.layer pop_addAnimation:rotation forKey:@"rotation"];
}

-(void)setViewAlpha:(CGFloat)alpha duration:(CGFloat)duration view:(UIView*)view{
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(alpha);
    alphaAnim.duration = duration;
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view pop_addAnimation:alphaAnim forKey:@"alpha"];
    
}

-(void)setCenter:(CGPoint)center duration:(CGFloat)duration view:(UIView*)view{
    POPBasicAnimation *centerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnim.toValue = [NSValue valueWithCGPoint:center];
    centerAnim.duration = duration;
    [centerAnim setCompletionBlock:^(POPAnimation *animation, BOOL is) {
        view.hidden = NO;
    }];
    [view pop_addAnimation:centerAnim forKey:@"center"];
    
}

//获取随机颜色
-(UIColor*)getRandomColor{
    CGFloat red   = arc4random()%255;
    CGFloat blue  = arc4random()%255;
    CGFloat green = arc4random()%255;
    
    return KRGBA(red, blue, green, 1);
}

@end