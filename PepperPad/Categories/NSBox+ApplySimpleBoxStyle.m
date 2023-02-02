//
//  NSBox+ApplySimpleBoxStyle.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "NSBox+ApplySimpleBoxStyle.h"

@implementation NSBox (ApplySimpleBoxStyle)

- (void)applySimpleBoxStyle {
    self.boxType = NSBoxCustom;
    self.borderWidth = 0.f;
    self.cornerRadius = 0.f;
    self.titlePosition = NSNoTitle;
}

@end
