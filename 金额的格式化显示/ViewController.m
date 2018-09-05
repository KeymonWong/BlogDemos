//
//  ViewController.m
//  金额的格式化显示
//
//  Created by 刘斌鹏 on 2018/9/5.
//  Copyright © 2018年 杭城小刘. All rights reserved.
//

#import "ViewController.h"
///金额格式化的2种方法：

@interface ViewController ()

@property (nonatomic, strong) UILabel *pricelabel;

@end

@implementation ViewController


#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pricelabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     在一些金融类的 App 中，对于表示金额类的字符串，通常需要进行格式化后再显示出来。例如：
     
     0 显示为：0.00
     123 显示为：123.00
     123.456 显示为：123.46
     102000 显示为：102,000.00
     10204500 显示为：10,204,500.00
     
     它的规则为：个位数起每隔三位数字添加一个逗号，同时保留两位小数，也称为“千分位格式”。
     
     我们一开始采取了一种比较笨拙的处理方式如下：
     
     首先根据小数点 `.` 将传入的字符串分割为两部分，整数部分和小数部分（如果没有小数点，则补 `.00`，如果有多个小数点则报金额格式错误）。对于小数部分，只取前两位；然后对整数部分字符串进行遍历，从右到左，每三位数前插入一个逗号 `,`，最后再把两部分拼接起来，代码大致如图 1 和图 2 所示。
     
     上述实现看起来非常繁琐。
     
     其实，苹果提供了 NSNumberFormatter 用来处理 NSString 和 NSNumber 之间的转化，可以满足基本的数字形式的格式化。我们通过设置 NSNumberFormatter 的 `numberStyle` 和 `positiveFormat` 属性，即可实现上述功能，非常简洁，代码如图 3 所示。
     
     关于 NSNumberFormatter 更详细的用法，
     参考资料： https://www.jianshu.com/p/817029422a72 
     */
    
//    [self method1];
    [self method2];
}



#pragma mark -- response metnod

- (void)method1{
    NSArray *temps = @[@"0",@"123",@"123.456",@"102000",@"10204500"];
    self.pricelabel.text = [self moneyFromat:temps[arc4random()%5]];
}

- (void)method2{
    NSArray *temps = @[@"0",@"123",@"123.456",@"102000",@"10204500"];
    self.pricelabel.text = [self formatDecimalNumber:temps[arc4random()%5]];
}

#pragma mark -- private method

- (NSString *)formatDecimalNumber:(NSString *)string{
    if (!string || string.length == 0) {
        return string;
    }
    NSNumber *number = @([string doubleValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,##0.00";
    formatter.positiveFormat = @"###,##0.00";
    NSString *amountString = [formatter stringFromNumber:number];
    return amountString;
}

- (NSString *)moneyFromat:(NSString *)money{
    if (!money || money.length == 0) {
        return money;
    }
    
    BOOL hasPoint = NO;
    if ([money rangeOfString:@"."].length > 0) {
        hasPoint = YES;
    }
    
    
    NSMutableString *pointMoney = [NSMutableString stringWithString:money];
    if (hasPoint == NO) {
        [pointMoney appendFormat:@".00"];
    }
    
    
    NSArray *moneys = [pointMoney componentsSeparatedByString:@"."];
    if (moneys.count > 2) {
        return pointMoney;
    }
    else if (moneys.count == 1) {
        return [NSString stringWithFormat:@"%@.00",moneys[0]];
    }
    else {
        //整数部分：每隔3位插入一个“,”
        NSString *frontMoney = [self stringFromToThreeBit:moneys[0]];
        if ([frontMoney isEqualToString:@""]) {
            frontMoney = @"0";
        }
        //拼接整数部分和消暑部分
        NSString *backMoney = moneys[1];
        if (backMoney.length == 1) {
            return [NSString stringWithFormat:@"%@.%@",frontMoney,backMoney];
        }
        else if (backMoney.length > 2) {
            return [NSString stringWithFormat:@"%@.%@",frontMoney,[backMoney substringToIndex:2]];
        }
        else {
            return [NSString stringWithFormat:@"%@.%@",frontMoney,backMoney];
        }
    }
}

- (NSString *)stringFromToThreeBit:(NSString *)string{
    NSString *tempString = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *mutableString = [NSMutableString stringWithString:tempString];
    NSInteger n = 2;
    if (mutableString.length  > 3) {
        for (NSUInteger i = mutableString.length - 3; i > 0; i--) {
            n++;
            
            if (n == 3) {
                [mutableString insertString:@"," atIndex:i];
                n = 0;
            }
            
        }
    }
    return mutableString;
}


#pragma mark -- lazy load

- (UILabel *)pricelabel{
    if (!_pricelabel) {
        _pricelabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _pricelabel.textAlignment = NSTextAlignmentCenter;
        _pricelabel.font = [UIFont boldSystemFontOfSize:20];
        _pricelabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    }
    return _pricelabel;
}

@end
