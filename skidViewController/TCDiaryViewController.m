//
//  TCDiaryViewController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-15.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCDiaryViewController.h"
#import "TCAddDiaryViewController.h"
#import "TCDiary.h"
//#import "TCDatePickerView.h"
#import "TCEditDiaryView.h"
#import "TCDiaryTableViewCell.h"
#import <Social/Social.h>
#import <EventKit/EventKit.h>
#import "NSDate+FSExtension.h"

#define  TCCoror(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]


@interface TCDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>

//主表格
@property (nonatomic, weak) UITableView * diaryTable;

//全部数据库条数
@property (nonatomic, strong) NSMutableArray * diaryLists;

//一条TCDiary数据
@property (nonatomic, strong) TCDiary * diaryNote;

//增加按钮
@property (nonatomic, weak) UIButton * addBtn;


@end

@implementation TCDiaryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView * dairyTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
//    dairyTab.separatorColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    dairyTab.rowHeight = 60;
    dairyTab.delegate = self;
    dairyTab.dataSource = self;
    dairyTab.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.diaryTable = dairyTab;
    [self.view addSubview:dairyTab];
    [self.diaryTable registerNib:[UINib nibWithNibName:@"TCDiaryTableViewCell" bundle:nil] forCellReuseIdentifier:@"TCDiaryTableViewCell"];

    
    UIButton * add = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, self.view.frame.size.height - 120,  48, 48)];
    [add setImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addNew:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = add;
    [self.view insertSubview:_addBtn aboveSubview:_diaryTable];
    [self.view addSubview:add];

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.addBtn addGestureRecognizer:pan];
    
    self.diaryLists = [self.diaryNote queryWithNote];
    
}


//懒加载
-(TCDiary *)diaryNote
{
    if (_diaryNote == nil)
    {
        _diaryNote = [[TCDiary alloc]init];
    }
    
    return _diaryNote;
}


//保存新建的简记后，重新刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //必须重新查询数据库更新数据
    self.diaryLists = [self.diaryNote queryWithNote];
    [self.diaryTable reloadData];
}

- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    //    switch (pan.state) {
    //        case UIGestureRecognizerStateBegan: // 开始触发手势
    //
    //            break;
    //
    //        case UIGestureRecognizerStateEnded: // 手势结束
    //
    //            break;
    //
    //        default:
    //            break;
    //    }
    
    // 1.在view上面挪动的距离
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    
    // 2.清空移动的距离
    [pan setTranslation:CGPointZero inView:pan.view];
}


//点击增加按钮，进入添加简记
-(void)addNew:(UIImageView* )add
{
    [UIImageView animateWithDuration:0.3 animations:^{
        
        add.layer.transform = CATransform3DMakeScale(2, 2, 0);
        add.alpha = 0;
    }
    completion:^(BOOL finished)
     {
         TCAddDiaryViewController *toAddController = [[TCAddDiaryViewController alloc]init];
         
         [self presentViewController:toAddController animated:YES completion:^{
             
             add.layer.transform = CATransform3DIdentity;
             add.alpha = 1;

             
         }];
         
     }];
    
}


//列表数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.diaryLists count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123.0;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * diaryID = @"TCDiaryTableViewCell";
    TCDiaryTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:diaryID];

    if (cell == nil)
    {
        cell =[[TCDiaryTableViewCell alloc] init];
    }
    
    //cell被选中的颜色
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TCCoror(51, 149, 253);
    //当前分区的数据
    self.diaryNote = self.diaryLists[[indexPath row]];
    cell.titleLab.text  = self.diaryNote.title;
    cell.titleLab.font = [UIFont boldSystemFontOfSize:17];
    cell.conentLab.text = self.diaryNote.content;
    
    //判断时间，如果是今年，那么只显示月日; 如果不是，显示年份
    NSString * times = [self.diaryNote.time substringToIndex:4];
    NSString * detailContent;
//    if ([times isEqualToString:[TCDatePickerView getNowDateFormat:@"yyyy"]])
//    {
//         detailContent = [NSString stringWithFormat:@"%@", [self.diaryNote.time substringFromIndex:5]];
//    }else{
//        detailContent = [NSString stringWithFormat:@"%@",self.diaryNote.time];
//    }
    
    cell.roundLab.layer.cornerRadius=5.0;
    cell.roundLab.clipsToBounds=YES;
    cell.roundLab.layer.borderColor=TCCoror(204, 204, 204).CGColor;
    cell.roundLab.layer.borderWidth=1.0;
    cell.timeLab.text = detailContent;
    cell.timeLab.font = [UIFont systemFontOfSize:15];
    cell.typeLab.text= [NSString stringWithFormat:@"%@ %@", self.diaryNote.weather, self.diaryNote.mood];
    cell.shareBtn.tag=indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.canclerBtn.tag=indexPath.row+1000;
    [cell.canclerBtn addTarget:self action:@selector(canclerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)canclerBtnClick:(UIButton *)btn{
    
    self.diaryNote = self.diaryLists[btn.tag-1000];
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    // display error message here
                }else if (!granted){
                    //被用户拒绝，不允许访问日历
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"nil" message:@"Please set up access calendar" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }else{
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    //06.07 元素
                    //title(标题 NSString),
                    //location(位置NSString),
                    //startDate(开始时间 2016/06/07 11:14AM),
                    //endDate(结束时间 2016/06/07 11:14AM),
                    //addAlarm(提醒时间 2016/06/07 11:14AM),
                    //notes(备注类容NSString)
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     =  self.diaryNote.title;;
                    event.location  = @"";
                    
                    //                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    //                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    //06.07 时间格式
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                    //                    [dateFormatter setAMSymbol:@"AM"];
                    //                    [dateFormatter setPMSymbol:@"PM"];
                    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
                    NSDate *date = [NSDate date];
                    NSString * s = [dateFormatter stringFromDate:date];
                    NSLog(@"%@",s);
                    
                    NSString *dateStr=[NSString stringWithFormat:@"%@.%@",@"2017", self.diaryNote.time];
                    NSString *timeStr2=[dateStr stringByReplacingOccurrencesOfString:@"月" withString:@"."];
                    NSString *timeStr3 =[timeStr2 stringByReplacingOccurrencesOfString:@"日" withString:@""];
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm"];
                    NSDate *startDate =[dateFormat dateFromString:timeStr3];
                    
                    if(date.fs_year==startDate.fs_year && date.fs_month==startDate.fs_month && date.fs_day==startDate.fs_day && date.fs_hour==startDate.fs_hour && date.fs_minute==startDate.fs_minute){
                        
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please choose some time in the future" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                        
                        return ;
                    }
                    
                    //开始时间(必须传)
                    event.startDate = startDate;
                    //结束时间(必须传)
                    event.endDate   = [startDate dateByAddingTimeInterval:60 * 5];
                    //                    event.allDay = YES;//全天
                    
                    //添加提醒
                    //第一次提醒  (几分钟后)
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -1.0f]];
                    //第二次提醒  ()
                    //                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -10.0f * 24]];
                    
                    event.notes =  self.diaryNote.content;
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    NSLog(@"err=%@",err);
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Add event to calendar Success！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    NSLog(@"%@保存成功%@",startDate,event.endDate);
                    
                }
            });
        }];
    }
    
    
}


-(void)shareBtnClick:(UIButton *)sender{
    
    self.diaryNote = self.diaryLists[sender.tag];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[self.diaryNote.title, self.diaryNote.content] applicationActivities:nil];
    //不显示哪些分享平台
    //        avc.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList];
    
    [self presentViewController:avc animated:YES completion:nil];
    //分享结果回调方法
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"%d %@",completed,type);
    };
    avc.completionHandler = myblock;
    
}


//编辑状态
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.diaryNote = [self.diaryLists objectAtIndex:[indexPath row]];
        
        [self.diaryNote deleteNote:self.diaryNote.ids];
        
        [self.diaryLists removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}



//选择的列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     TCEditDiaryView * editController = [[TCEditDiaryView alloc]init];
    
     self.diaryNote = self.diaryLists[[indexPath row]];
    
     editController.ids = self.diaryNote.ids;

    
    self.hidesBottomBarWhenPushed = YES;
    
     [self.navigationController pushViewController:editController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.addBtn.hidden = YES;
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.addBtn.hidden = NO;
    
    return YES;
}


@end
