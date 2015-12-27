//
//  TimMulColumTextView.m
//  MulColumTextDemo
//
//  Created by 李佳 on 15/12/27.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#define HoriMargin 8.0
#define VecMargin 15.0

#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTFramesetter.h>
#import "TimMulColumTextView.h"

static  NSString* showText = @"冯小刚导演出演男一号的电影《老炮儿》未映先红。拿了个金马奖，拿他自己的话说，这奖给的让他没有了进步空间，其实空间还是有的，奥斯卡男演员与金马奖男演员中间怎么也能挤出一点儿空间，这点儿空间足够用来进步。老炮儿一词跟着红了，红得有点儿歪。原因是老炮儿最初的含义是老泡儿，指在某一行业或领域天天泡着，日久成精，有点当不上大哥也是个二哥的意思。与此匹配的词汇最贴近的是“泡妞儿”，过去搞女朋友比现在麻烦多了，那时多流氓的女流氓也比今天随便上床的网友纯真，所以要泡，需要时间，好女怕烂缠，烂缠就是泡，没钱也没关系，只要豁得出时间和精力，什么女人都能到手。那时女流氓的纯真按当时最损的话叫“装紧”，王朔的小说里写过，看不懂这话要自己慢慢琢磨。四五十年前的女流氓的作为搁今天真算不上什么流氓，顶多算小资。未婚跟男人上了床五十年前跟犯了命案差不多，今天的年轻人怎么也不能理解。老泡儿用工夫和脸皮将美女揽入怀中，睡上一觉就准出来吹嘘，那年月的人精神特空虚，也没毛片看，把和女友上床的事说出来供大家一同精神享受。这时，每个男人都把自己说成力拔山兮，金枪不倒，且炮声隆隆，久而久之，泡讹误为炮，“老炮儿”遂生成，加之黑话“打炮”风行，“老泡儿”反而没人知了。北京至少60岁以上的人才能对当年风行的“老泡儿”一词有极深的了解，这种了解必须设身处地，道听途说肯定不行，这些天好多旧友打电话和我聊，当年那些“老泡儿”今天至少也得七八十岁了，刀枪入库，马放南山，有炮也没有炮弹了。。";


@implementation TimMulColumTextView

- (NSArray*)getMulColumTextDrawRects: (NSUInteger)columCount
{
    CGRect* rects = malloc(sizeof(CGRect) * columCount);
    rects[0] = self.bounds;
    
    CGFloat columWidth = CGRectGetWidth(self.bounds) / columCount;
    int columIndex = 0;
    for (columIndex = 0; columIndex <  columCount - 1; columIndex++)
    {
        CGRectDivide(rects[columIndex], &rects[columIndex],
                     &rects[columIndex + 1], columWidth, CGRectMinXEdge);
    }
    for (columIndex = 0; columIndex < columCount; columIndex++)
    {
        rects[columIndex] = CGRectInset(rects[columIndex], HoriMargin, VecMargin);
    }
    
    NSMutableArray* paths = [[NSMutableArray alloc] init];
    for (columIndex = 0; columIndex < columCount; columIndex++)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rects[columIndex]);
        [paths addObject:(__bridge id)path];
        CFRelease(path);
    }
    
    return (NSArray*)paths;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFAttributedStringRef attrStr = CFAttributedStringCreate(kCFAllocatorDefault, (CFStringRef)showText, nil);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
    NSArray* columnPaths = [self getMulColumTextDrawRects:2];
    
    CFIndex pathCount = columnPaths.count;
    CFIndex startIndex = 0;
    int columIndex = 0;
    
    for (columIndex = 0; columIndex < pathCount; columIndex++)
    {
        CGPathRef path = (__bridge CGPathRef)columnPaths[columIndex];
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
        
    }
    CFRelease(attrStr);
    CFRelease(framesetter);
}
@end
