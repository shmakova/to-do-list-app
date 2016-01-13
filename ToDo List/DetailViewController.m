//
//  DetailViewController.m
//  ToDo List
//
//  Created by Anastasia Shmakova on 11.01.16.
//  Copyright © 2016 Shmakova Anastasia. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.textField.delegate = self;
    UITapGestureRecognizer *handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:handleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleEndEditing {
    [self.view endEditing:YES];
}

- (void) datePickerValueChanged {
    self.eventDate = self.datePicker.date;
    NSLog(@"self.eventDate %@", self.eventDate);
}

- (void)save {
    NSLog(@"save");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        [self.textField resignFirstResponder];
    }
    
    return YES;
}

@end
