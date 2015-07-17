//
//  CC98PageOperatingViewController.m
//  CC98Lite
//
//  Created by S on 15/6/11.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98PageOperatingViewController.h"
#import "UIButton+CC98Style.h"
#import "NSString+CC98Style.h"
#import "NSError+CC98Style.h"
#import "UIViewController+KNSemiModal.h"

@interface CC98PageOperatingViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *headPageButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextField *pageNumber;
@property (weak, nonatomic) IBOutlet UIPickerView *pageNumberPicker;

@end


@implementation CC98PageOperatingViewController

- (IBAction)gotoHeadPage:(UIButton *)sender {
    [self dismissSemiModalView];
    if (self.delegate) { [self.delegate turnPageToNumber:1]; }
}

- (IBAction)confirm:(UIButton *)sender {
    @try {
        if ([self.pageNumber.text isIntegerValue]) {
            NSInteger selectedPageNum = self.pageNumber.text.integerValue;
            if (selectedPageNum > self.numberOfPages || selectedPageNum <= 0) {
                NSException *exception = [NSException exceptionWithName:@"无效页码" reason:nil userInfo:nil];
                [exception raise];
            } else {
                [self dismissSemiModalView];
                if (self.delegate) { [self.delegate turnPageToNumber:selectedPageNum]; }
            }
        } else {
            NSException *exception = [NSException exceptionWithName:@"无效页码" reason:nil userInfo:nil];
            [exception raise];
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"无效页码，请重新输入"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pageNumber setText:[NSString stringWithFormat:@"%ld", (long)(self.currentPageNum)]];
    [self.pageNumberPicker selectRow:self.currentPageNum-1 inComponent:0 animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.headPageButton configCC98Style];
    [self.confirmButton configCC98Style];
    
    self.pageNumberPicker.delegate = self;
    self.pageNumberPicker.dataSource = self;
    
    [self.pageNumber setText:@"1"];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.4);
}

- (NSInteger)pageNumberForRow:(NSInteger)row {
    return row+1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.numberOfPages;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"第%ld页", (long)[self pageNumberForRow:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.pageNumber setText:[NSString stringWithFormat:@"%ld", (long)[self pageNumberForRow:row]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
