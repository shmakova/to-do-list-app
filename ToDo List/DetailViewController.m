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
    
    if (self.isDetail) {
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.buttonSave.alpha = 0;
        [self performSelector:@selector(setDatePickerValueWithAnimation) withObject:nil afterDelay:0.5];
    } else {
    
    self.buttonSave.userInteractionEnabled = NO;
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.textField.delegate = self;
    UITapGestureRecognizer *handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:handleTap];
    }
}

- (void)setDatePickerValueWithAnimation {
    [self.datePicker setDate:self.eventDate animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleEndEditing {
    if ([self.textField.text length] != 0) {
        [self.view endEditing:YES];
        self.buttonSave.userInteractionEnabled = YES;
    } else {
        [self showAlertWithMessage:@"Для сохранения события введите значение в текстовое поле"];
    }
}

- (void) datePickerValueChanged {
    self.eventDate = self.datePicker.date;
    NSLog(@"self.eventDate %@", self.eventDate);
}

- (void)save {
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMessage:@"Для сохранения события измените значение даты на более позднее"];
        } else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            [self showAlertWithMessage:@"Дата будущего события не может быть ранее текущей даты"];
        } else {
            [self setNotification];
        }
    } else {
        [self showAlertWithMessage:@"Для сохранения события измените значение даты на более позднее"];
    }
    
}

- (void) setNotification {
    NSString *eventInfo = self.textField.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm dd.MMMM.yyyy";
    
    NSString *eventDate = [formatter stringFromDate:self.eventDate];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          eventInfo, @"eventInfo",
                          eventDate, @"eventDate", nil];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        if ([self.textField.text length] != 0) {
            [self.textField resignFirstResponder];
            self.buttonSave.userInteractionEnabled = YES;
            return YES;
        } else {
            [self showAlertWithMessage:@"Для сохранения события введите значение в текстовое поле"];
        }
    }
    
    return NO;
}

- (void) showAlertWithMessage : (NSString *) message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Внимание!" message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertController){}];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
