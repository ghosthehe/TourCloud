//
//  CellEventHandle.h
//  GhostSpeed
//
//  Created by ghost on 16/4/22.
//  Copyright © 2016年 ghost. All rights reserved.
//

#ifndef CellEventHandle_h
#define CellEventHandle_h

#define EMCellEventType @"eventtype"

typedef void (^TableViewCellEventHandler)(UITableViewCell *cell,id cellmodel,id sender, NSIndexPath *indexPath,id userInfo);


@protocol TableViewCellEventHandler <NSObject>

@property (nonatomic, copy)TableViewCellEventHandler eventHandler;

@end

#endif /* CellEventHandle_h */
