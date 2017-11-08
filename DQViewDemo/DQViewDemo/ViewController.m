//
//  ViewController.m
//  DQViewDemo
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ViewController.h"
#import "DQNaviDropdownView.h"

#define WAVE_BLUE   [UIColor colorWithRed:133.0f/255.0f green:191.0f/255.0f blue:242.0f/255.0f alpha:1.0f]


@interface ViewController () <DQNaviDropdownViewDelegate>

@property (nonatomic, strong) DQNaviDropdownView *naviView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //  Model Init
    _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_titleArray addObject:@"All Groups"];
    [_titleArray addObject:@"My Groups"];
    [_titleArray addObject:@"Friends' Groups"];
    
    //  View Init
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:WAVE_BLUE];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:WAVE_BLUE forKey:NSForegroundColorAttributeName]];
    
    //  customize nav bar
    _naviView = [[DQNaviDropdownView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.bounds.size.height)withDropdownArray:_titleArray];
    _naviView.delegate = self;
    self.navigationItem.titleView = _naviView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark DQNaviDropdownViewDelegate

- (void)didClickedDropdownViewAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        case 1:
            self.view.backgroundColor = [UIColor lightGrayColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor darkGrayColor];
            break;
        default:
            break;
    }
}
@end

