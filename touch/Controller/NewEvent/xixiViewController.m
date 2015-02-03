//
//  xixiViewController.m
//  touch
//
//  Created by Ariel Xin on 2/2/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

//
//  CampaignViewController.m
//  touch
//
//  Created by zhu on 1/26/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

/*
#import "CampaignViewController.h"
#import "SZTextView.h"
#import "ActivityTypeViewController.h"
#import "Event.h"
#import "EventManager.h"
#import "UIButton+Button.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PPiFlatSegmentedControl.h"
#import "IHKeyboardAvoiding.h"
#import "ProgressHUD.h"
#import "ActionSheetDatePicker.h"
#import "RMDateSelectionViewController.h"

#define INPUT_TEXT_SIZE         14.0
#define LEFT_MARGIN             15.0
#define SCREENWIDTH         CGRectGetWidth([UIScreen mainScreen].bounds)

@interface CampaignViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
RMDateSelectionViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *typeControl;

@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UITextField *placeTextField;
@property (strong, nonatomic) UITextView *descTextView;

@property (strong, nonatomic) UIView *typeContainerView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *placeLabel;

@property (nonatomic) NSInteger selectedType;
@property (strong, nonatomic) NSArray *typeNormalImages;
@property (strong, nonatomic) NSArray *typeTitles;

// backgroud image
@property (strong, nonatomic) UIImage *backgroundImage;
// choosen event time
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) NSMutableArray *eventImages;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) CGFloat offsetY;
@end

@implementation CampaignViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.typeNormalImages = @[@"type_studyGroup.png", @"type_reviewSession.png", @"type_partnerRecruiting.png", @"type_infoSession.png", @"type_other.png"];
    self.typeTitles = @[@"Study Group", @"Review Session", @"Partner Rectruiting", @"Info Session", @"Other"];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureNavigationBar];
    
    [self configureTableHeaderView];
    [self configureTableFooterView];
    
    self.eventDate = [NSDate date];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYYyearMMmonthDDday"];
    NSLog(@"View loaded");
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [_tableView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)configureNavigationBar {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDidClick:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)cancelButtonDidClick:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)configureViews {
    
}

- (void)configureTableHeaderView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 150.0)];
    imageView.image = [UIImage imageNamed:@"studyGroup"];
    _tableView.tableHeaderView = imageView;
    self.headerImageView = imageView;
}

- (void)configureTableFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 70.0)];
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 10.0, 10.0, SCREENWIDTH / 2 - 20.0, 50.0)];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"btn_yellow.png"] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [sureButton addTarget:self action:@selector(createNewEvent) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:RGBCOLOR(184.0, 150.0, 101.0) forState:UIControlStateNormal];
    [sureButton setTitle:@"confirm" forState:UIControlStateNormal];
    [view addSubview:sureButton];
    _tableView.tableFooterView = view;
}

- (void)setLeftPaddingForTextField:(UITextField *)textField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [textField setLeftView:paddingView];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setTintColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// create event
#pragma mark -- Create New Event
- (void)createNewEvent {
    if ([_titleTextField.text isEqualToString:@""] || [_descTextView.text isEqualToString:@""]) {
        return;
    }
    
    Event *event = [[Event alloc] init];
    event.title = _titleTextField.text;
    event.eventDescription = _descTextView.text;
    event.locationName = _placeTextField.text;
    event.eventTime = _eventDate;
    event.background = _backgroundImage;
    switch (_selectedType) {
        case 0:
            event.subjectType = studyGroup;
            break;
        case 1:
            event.subjectType = reviewSession;
            break;
        case 2:
            event.subjectType = partnerRecruiting;
            break;
        case 3:
            event.subjectType = infoSession;
            break;
        case 4:
            event.subjectType = other;
            break;
        default:
            break;
    }
    
    switch (_typeControl.selectedSegmentIndex) {
        case 0:
            event.type = rsvp;
            break;
        case 1:
            event.type = toPublic;
            break;
        default:
            break;
    }
    
    [ProgressHUD show:nil];
    [[EventManager sharedManager] createEvent:event InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"create event succeeded");
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            NSLog(@"create event failed");
        }
        [ProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateNewEvent" object:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"theme";
            [cell.contentView addSubview:label];
            UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 30.0, SCREENWIDTH - 20.0, 42.0)];
            titleField.font = [UIFont systemFontOfSize:INPUT_TEXT_SIZE];
            titleField.background = [UIImage imageNamed:@"input_border.png"];
            titleField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, LEFT_MARGIN, 1.0)];
            titleField.leftViewMode = UITextFieldViewModeAlways;
            self.titleTextField = titleField;
            [cell.contentView addSubview:titleField];
        }
        return cell;
    } else if (row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubjectCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"theme type";
            [cell.contentView addSubview:label];
            CGFloat buttonWidth = 90.0;
            CGFloat buttonHeight = 80.0;
            CGFloat viewLeftMargin = 10.0;
            if (SCREENWIDTH == 320) {
                viewLeftMargin = 2.5;
                buttonWidth = 77.5;
            } else if (SCREENWIDTH == 375) {
                viewLeftMargin = 7.5;
                buttonWidth = 90.0;
            } else {
                
            }
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, 25.0, SCREENWIDTH - viewLeftMargin * 2, 160.0)];
            for (NSInteger i = 0; i < 8; i++) {
                CGFloat originY = 0.0;
                if (i >= 4) {
                    originY = buttonHeight;
                }
                UIButton *button = [UIButton eventTypeButtonWithFramg:CGRectMake(buttonWidth * (i % 4), originY, buttonWidth, buttonHeight)
                                                          normalImage:[UIImage imageNamed:_typeNormalImages[i]]
                                                       highlightImage:[UIImage imageNamed:_typeNormalImages[i]]
                                                                 text:_typeTitles[i]];
                button.tag = i;
                [button addTarget:self action:@selector(typeButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            [cell.contentView addSubview:view];
            self.typeContainerView = view;
            [self selectTypeButtonAtIndex:_selectedType];
        }
        return cell;
    }
    else if (row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TypeCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"event type";
            [cell.contentView addSubview:label];
            NSArray *items = @[@"rsvp", @"public"];
            CGRect frame = CGRectMake(LEFT_MARGIN, 35.0, SCREENWIDTH - LEFT_MARGIN * 2, 38.0);
            //            PPiFlatSegmentedControl *segment = [self segmentedControlWithFrame:frame items:items];
            UISegmentedControl *control = [self segmentControlWithFrame:frame items:items];
            control.selectedSegmentIndex = 0;
            self.typeControl = control;
            //            self.typeControl = segment;
            [cell.contentView addSubview:control];
        }
        return cell;
    } else if (row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"Time";
            [cell.contentView addSubview:label];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 30.0, SCREENWIDTH, 40.0)];
            [cell.contentView addSubview:view];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
            imageView.image = [UIImage imageNamed:@"input_border.png"];
            [view addSubview:imageView];
            label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 1.0, SCREENWIDTH - LEFT_MARGIN * 2, 38.0)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:17.0];
            label.textColor = RGBACOLOR(136.0, 157.0, 181.0, 61.0);
            if (_eventDate) {
                label.text = [_dateFormatter stringFromDate:_eventDate];
            } else {
                label.text = @"current time";
                
            }
            self.timeLabel = label;
            [view addSubview:label];
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 33.0, 11.0, 13.0, 18.0)];
            imageView.image = [UIImage imageNamed:@"discloser.png"];
            [view addSubview:imageView];
            UIButton *button = [[UIButton alloc] initWithFrame:label.frame];
            [button addTarget:self action:@selector(timeViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
        return cell;
    } else if (row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"place";
            [cell.contentView addSubview:label];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 30.0, SCREENWIDTH, 40.0)];
            textField.font = [UIFont systemFontOfSize:INPUT_TEXT_SIZE];
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 15.0, 1.0)];
            textField.leftViewMode = UITextFieldViewModeAlways;
            [IHKeyboardAvoiding setAvoidingView:self.view withTriggerView:textField];
            self.placeTextField = textField;
            textField.background = [UIImage imageNamed:@"input_border.png"];
            //            [cell.contentView addSubview:textField];
            label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 30.0, SCREENWIDTH - LEFT_MARGIN * 2, 40.0)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:17.0];
            label.textColor = RGBACOLOR(136.0, 157.0, 181.0, 61.0);
            label.text = @"current place";
            [cell.contentView addSubview:label];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 30.0, SCREENWIDTH, 40.0)];
            imageView.image = [UIImage imageNamed:@"input_border.png"];
            [cell.contentView addSubview:imageView];
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 33.0, 41.0, 13.0, 18.0)];
            imageView.image = [UIImage imageNamed:@"discloser.png"];
            [cell.contentView addSubview:imageView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 30.0, SCREENWIDTH, 40.0)];
            [button addTarget:self action:@selector(placeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        return cell;
    }else if (row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescCell"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 10.0, SCREENWIDTH - LEFT_MARGIN * 2, 14.0)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = RGBCOLOR(54.0, 63.0, 72.0);
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = @"introduction";
            [cell.contentView addSubview:label];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 30.0, SCREENWIDTH, 100.0)];
            [cell.contentView addSubview:view];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
            imageView.image = [UIImage imageNamed:@"input_border.png"];
            [view addSubview:imageView];
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 1.0, CGRectGetWidth(view.bounds) - LEFT_MARGIN * 2, CGRectGetHeight(view.bounds) - 2)];
            textView.font = [UIFont systemFontOfSize:INPUT_TEXT_SIZE];
            textView.contentInset = UIEdgeInsetsZero;
            [IHKeyboardAvoiding setAvoidingView:self.view withTriggerView:textView];
            self.descTextView = textView;
            [view addSubview:textView];
        }
        return cell;
    }
    return nil;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        // theme
        return 80.0;
    } else if (row == 1) {
        // type
        return 200.0;
    } else if (row == 2) {
        // permission
        return 75.0;
    } else if (row == 3) {
        // time
        return 75.0;
    } else if (row == 4) {
        // place
        return 75.0;
    }else if (row == 5) {
        // event description
        return 150.0;
    }
    return 0.0;
}




- (PPiFlatSegmentedControl *)segmentedControlWithFrame:(CGRect)frame items:(NSArray *)items {
    NSMutableArray *segmentItems = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString *item in items) {
        PPiFlatSegmentItem *segmentItem = [[PPiFlatSegmentItem alloc] initWithTitle:item andIcon:nil];
        [segmentItems addObject:segmentItem];
    }
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(15.0, 30.0, SCREENWIDTH - 30.0, 38.0)
                                                                                items:segmentItems
                                                                         iconPosition:IconPositionLeft
                                                                    andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                        NSLog(@"control select : %ld", (long)segmentIndex);
                                                                    }
                                                                       iconSeparation:0.0];
    segment.borderWidth = 1.5;
    segment.borderColor = RGBCOLOR(136.0, 157.0, 181.0);
    segment.selectedColor = RGBCOLOR(235.0, 74.0, 56.0);
    segment.color = [UIColor whiteColor];
    segment.textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                               NSForegroundColorAttributeName: RGBCOLOR(136.0, 157.0, 181.0)};
    segment.selectedTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                       NSForegroundColorAttributeName: [UIColor whiteColor]};
    return segment;
}

- (UISegmentedControl *)segmentControlWithFrame:(CGRect)frame items:(NSArray *)items {
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
    control.frame = frame;
    control.tintColor = RGBCOLOR(235.0, 74.0, 56.0);
    [control setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBCOLOR(136.0, 157.0, 181.0)}
                           forState:UIControlStateNormal];
    [control setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                           forState:UIControlStateSelected];
    return control;
}


- (void)placeButtonDidClick:(UIButton *)button {
    
}

- (IBAction)timeViewDidClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [ActionSheetDatePicker showPickerWithTitle:@""
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:self.eventDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                      self.eventDate = selectedDate;
                                      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                      [formatter setDateFormat:@"YYYYyearMMmonthDDday"];
                                      _timeLabel.text = [formatter stringFromDate:selectedDate];
                                  } cancelBlock:^(ActionSheetDatePicker *picker) {
                                      
                                  }
                                        origin:sender];
}
- (IBAction)typeButtonDidClick:(UIButton *)sender {
    ActivityTypeViewController *typeController = [[ActivityTypeViewController alloc] init];
    [self.navigationController pushViewController:typeController animated:YES];
}

- (void)typeButtonDidSelect:(UIButton *)button {
    [self selectTypeButtonAtIndex:button.tag];
}

- (void)selectTypeButtonAtIndex:(NSInteger)index {
    for (UIView *view in _typeContainerView.subviews) {
        [(UIButton *)view setSelected:NO];
        if (view.tag == index) {
            [(UIButton *)view setSelected:YES];
        }
    }
    self.selectedType = index;
    [self changeHeaderImage:index];
}

// change the image according to the type of event
- (void)changeHeaderImage:(NSInteger)tag {
    switch (tag) {
        case 0:
            self.backgroundImage = [UIImage imageNamed:@"studyGroup"];
            break;
        case 1:
            self.backgroundImage = [UIImage imageNamed:@"reviewSession"];
            break;
        case 2:
            self.backgroundImage = [UIImage imageNamed:@"partnerRecruiting"];
            break;
        case 3:
            self.backgroundImage = [UIImage imageNamed:@"infoSession"];
            break;
        case 4:
            self.backgroundImage = [UIImage imageNamed:@"other"];
            break;
        default:
            break;
    }
    _headerImageView.image = _backgroundImage;
}

- (UISegmentedControl *)customedSegmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.tintColor = RGBCOLOR(235.0, 74.0, 56.0);
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBCOLOR(235.0, 74.0, 56.0)} forState:UIControlStateNormal];
    segment.selectedSegmentIndex = 0;
    return segment;
}


#pragma mark - RMDateSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    //Do something
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYyearMMmonthDDday"];
    _timeLabel.text = [formatter stringFromDate:aDate];
    self.eventDate = aDate;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    //Do something else
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}





@end*/
