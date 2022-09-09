//
//  STPerson.m
//  TXIMDemo
//
//  Created by stoicer on 2022/6/2.
//

#import "STPerson.h"

@implementation STPerson

+(void)load
{
    NSLog(@"STPerson + load");
}

+ (void)initialize
{
    NSLog(@"STPerson + initialize");
}
/**
 setKey _setKey setIsKey
 
 getKey key isKey _key
 */
//- (void)setAddress:(NSString *)addr
//{
//    address = addr;
//}


//- (void)_setAddress:(NSString *)addr
//{
//    address = addr;
//}

//- (void)setIsAddress:(NSString *)addr
//{
//    address = addr;
//}
//+ (BOOL)accessInstanceVariablesDirectly
//{
//    return YES;
//}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    NSLog(@"undefine key:%@",key);
//}

//- (NSString *)getAddress
//{
//    return address;
//}

//- (NSString *)address
//{
//    return address;
//}


//- (NSString *)isAddress
//{
//    return address;
//}

//- (NSString *)_address
//{
//    return address;
//}



- (void)eat
{
    NSLog(@"---eat---");
}

+ (void)sleep
{
    NSLog(@"---sleep---");
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInt:self.age forKey:@"age"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])
    {
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeIntForKey:@"age"];
    }
    
    return self;
}


@end
