//
//  ViewController.m
//  UIPickerDemo
//
//  Created by liushuai on 2017/8/6.
//  Copyright © 2017年 liushuai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *label;

//数组用于保存三个Component的数据
@property (nonatomic,strong) NSArray *provinceArray;//省份
@property (nonatomic,strong) NSArray *cityArray;    //城市
@property (nonatomic,strong) NSArray *townArray;    //县镇

//用于记录当前PickerView选中的row
@property (assign) NSInteger provinceIndex;
@property (assign) NSInteger cityIndex;
@property (assign) NSInteger townIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    _provinceIndex = 0;
    _cityIndex = 0;
    _townIndex = 0;
    
    _provinceArray = @[@"河北",@"河南",@"广州"];
    _cityArray = @[@[@"沧州",@"石家庄",@"唐山"],@[@"平顶山",@"新乡",@"郑州"],@[@"广州",@"肇庆"]];
    _townArray = @[@[@"沧县",@"青县"],
                 @[@"石家庄1",@"石家庄2",@"石家庄3"],
                 @[@"唐山1",@"唐山2"],
                 @[@"平顶山1",@"平顶山2"],
                 @[@"新乡1",@"新乡2"],
                 @[@"郑州1",@"郑州2",@"郑州3"],
                 @[@"广州1",@"广州2",@"广州3"],
                 @[@"肇庆1",@"肇庆2",@"肇庆3"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - pickerViewDelegate 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
        
    } else if (component == 1) {
        NSArray *currentCities = _cityArray[_provinceIndex];
        return currentCities.count;
        
    } else {
        NSInteger currentTownIndex = 0;
        
        //获取前面省份的城市数量
        for (int i=0; i<_provinceIndex; i++) {
            NSArray *arr = _cityArray[i];
            currentTownIndex += arr.count;
        }
        
        //加上当前省份城市序号
        currentTownIndex += _cityIndex;
        
        NSArray *currentTowns = _townArray[currentTownIndex];
        return currentTowns.count;
    }
}

#pragma mark - pickerViewDataSorce 

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == 0) {
//        return _provinceArray[row];
//        
//    } else if (component == 1) {
//        NSArray *currentCities = _cityArray[_provinceIndex];
//        return currentCities[row];
//    } else {
//        NSInteger currentTownIndex = 0;
//        
//        //获取前面省份的城市数量
//        for (int i=0; i<_provinceIndex; i++) {
//            NSArray *arr = _cityArray[i];
//            currentTownIndex += arr.count;
//        }
//        
//        //加上当前省份城市序号
//        currentTownIndex += _cityIndex;
//        
//        NSArray *currentTowns = _townArray[currentTownIndex];
//        return currentTowns[row];
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //第一级选中变动，我们需要更新后面两列的内容
        _provinceIndex = row; //更新省份序号
        
        _cityIndex = 0; //重设为0，否则当前城市序号在其他省份可能溢出
        _townIndex = 0; //同上
        
        [pickerView reloadComponent:1];//刷新城市列表
        [pickerView reloadComponent:2];
        
    } else if (component == 1) {
        //第二级选中变动，需要更新后面一列内容
        _cityIndex = row;
        
        _townIndex = 0;
        [pickerView reloadComponent:2];
    } else {
        //最后一列，不需要更新列表
        _townIndex = row;
    }
    
    NSString *provienceStr = _provinceArray[_provinceIndex];
    
    NSArray *currentCities = _cityArray[_provinceIndex];
    NSString * cityStr = currentCities[_cityIndex];
    
    NSInteger currentTownIndex = 0;
    
    //获取前面省份的城市数量
    for (int i=0; i<_provinceIndex; i++) {
        NSArray *arr = _cityArray[i];
        currentTownIndex += arr.count;
    }
    
    //加上当前省份城市序号
    currentTownIndex += _cityIndex;
    
    NSArray *currentTowns = _townArray[currentTownIndex];
    NSString *townStr = currentTowns[_townIndex];
    
    _label.text = [NSString stringWithFormat:@"%@-%@-%@",provienceStr,cityStr,townStr];
    
}


- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *titleStr = nil;
    if (component == 0) {
        titleStr = _provinceArray[row];
        
    } else if (component == 1) {
        NSArray *currentCities = _cityArray[_provinceIndex];
        titleStr = currentCities[row];
    } else {
        NSInteger currentTownIndex = 0;
        
        //获取前面省份的城市数量
        for (int i=0; i<_provinceIndex; i++) {
            NSArray *arr = _cityArray[i];
            currentTownIndex += arr.count;
        }
        
        //加上当前省份城市序号
        currentTownIndex += _cityIndex;
        
        NSArray *currentTowns = _townArray[currentTownIndex];
        titleStr = currentTowns[row];
    }
    NSAttributedString *title = [[NSAttributedString alloc]initWithString:titleStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return title;
}




@end
