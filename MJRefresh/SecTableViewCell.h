//
//  SecTableViewCell.h
//  FMLCN
//
//  Created by mac on 6/5/15.
//  Copyright (c) 2015 cypalen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *floor;


@end
