//
//  LockVC.h
//  TXIMDemo
//
//  Created by stoicer on 2022/9/8.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface Item : NSObject

@property (nonatomic, strong) NSString *name;

- (void)showDataiItem:(Item *)item;

@end

@interface LockVC : UIViewController

@end

NS_ASSUME_NONNULL_END
