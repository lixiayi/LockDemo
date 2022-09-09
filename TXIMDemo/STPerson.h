//
//  STPerson.h
//  TXIMDemo
//
//  Created by stoicer on 2022/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@interface STPerson : NSObject<NSCoding>
{

//    NSString *_address;
//    NSString *_isAddress;
//    NSString *address;
//    NSString *isAddress;
}


@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int  age;


- (void)eat;
+ (void)sleep;
@end

NS_ASSUME_NONNULL_END
