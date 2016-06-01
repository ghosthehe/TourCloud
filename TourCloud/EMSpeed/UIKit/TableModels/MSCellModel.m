//
//  MSCellModel.m
//  EMSpeed
//
//  Created by ryan on 15/7/31.
//
//

#import "MSCellModel.h"
#import <UIKit/UIKit.h>

@implementation MSCellModel

@synthesize Class;
@synthesize reuseIdentify;
@synthesize height;
@synthesize isRegisterByClass;

- (instancetype)init {
    if (self = [super init]) {
        self.Class             = [UITableViewCell class];
        self.height            = 44;
        self.isRegisterByClass = YES;
    }
    return self;
}

@end
