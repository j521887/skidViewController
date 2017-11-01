//
//  TCDiaryTableViewCell.h
//  SecurityNote
//
//  Created by Des on 2017/9/5.
//  Copyright © 2017年 JoonSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCDiaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel  *titleLab;
@property (weak, nonatomic) IBOutlet UILabel  *conentLab;
@property (weak, nonatomic) IBOutlet UILabel  *timeLab;
@property (weak, nonatomic) IBOutlet UILabel  *typeLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *canclerBtn;
@property (weak, nonatomic) IBOutlet UILabel *roundLab;

@end
