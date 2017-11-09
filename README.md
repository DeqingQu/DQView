# DQView
DQView are reusable view components for iOS development which I used in Rising project.

Including:
* DQTabbarViewController - a tab container which can fold and unfold tab button. 
* DQNaviDropdownView – a dropdown menu view which can be integrated in navigation bar.

## DQTabbarViewController
DQTabbarViewController is tab container that you can add arbitrary view controller to it. When the center button is clicked, hidden buttons will display with animation and a transparent musk layer will also appear in the background. 
<h3 align="center">
  <img src="https://github.com/DeqingQu/DQView/blob/master/Screens/Tabbar_Demo1.PNG" alt="Example Chart 1" width="260"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/Tabbar_Demo2.PNG" alt="Example Chart 2" width="260"/>
</h3>

## DQNaviDropdownView
DQNaviDropdownView is a dropdown menu view. When the navigation bar is clicked, the menu will expand or collapse with animation.
<h3 align="center">
<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/NaviDrop_Demo1.PNG" alt="Example Chart 1" width="260"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/NaviDrop_Demo2.PNG" alt="Example Chart 2" width="260"/>
</h3>

## Usage and Customization
**DQView** is designed to be created in one initialization line of code. For **DQTabbarViewController**, you must set it as the rootViewController of self.window to keep it working correctly. For **DQNaviDropdownView**, you must set it as the titleView of self.navigationItem and don't forget to implement DQNaviDropdownViewDelegate which responses for click action of dropdown menu.

### Simple example for DQTabbarViewController:
```objective-c

NSArray *viewControllers = @[navVC1, navVC2, navVC3, navVC4];
NSArray *tabbarImages = @[@"DQ_Tabbar_circle", @"DQ_Tabbar_circle_pressed", @"DQ_Tabbar_relation",
    @"DQ_Tabbar_relation_pressed", @"DQ_Tabbar_message", @"DQ_Tabbar_message_pressed",
    @"DQ_Tabbar_personal", @"DQ_Tabbar_personal_pressed"];

NSArray *popupViewControllers = @[navVC5, navVC6, navVC7];
NSArray *popupImages = @[@"DQ_Tabbar_Popup_subscribe", @"DQ_Tabbar_Popup_subscribe_pressed",
    @"DQ_Tabbar_Popup_rank", @"DQ_Tabbar_Popup_rank_pressed", @"DQ_Tabbar_Popup_manager",
    @"DQ_Tabbar_Popup_manager_pressed"];

self.window.rootViewController = [[DQTabbarViewController alloc] initWithViewControllers:viewControllers
    withTabbarImages:tabbarImages
    withCenterImage:@"DQ_Tabbar_center"
    withPopupViewControllers:popupViewControllers
    withPopupImages:popupImages];

```

### Simple example for DQNaviDropdownView:
```objective-c

//  data init
_titleArray = [[NSMutableArray alloc] initWithCapacity:0];
[_titleArray addObject:@"All Groups"];
[_titleArray addObject:@"My Groups"];
[_titleArray addObject:@"Friends' Groups"];

//  customize nav bar
_naviView = [[DQNaviDropdownView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.bounds.size.height)
    withDropdownArray:_titleArray];

_naviView.delegate = self;
self.navigationItem.titleView = _naviView;

//  implement DQNaviDropdownViewDelegate
- (void)didClickedDropdownViewAtIndex:(NSInteger)index {

}
```

## Author
DQView is open-sourced by [Deqing Qu](http://people.oregonstate.edu/~qud/).

## More information about Rising project
Rising is a social app for students in university. Students can join different kinds of groups in Rising.
The group can be a class group, like CS321 class group, or can be a club group, like tennis club group. Students also can create their own groups by inviting other students who have the same interests.

In Rising, a student can chat with his friend or chat in his groups. He can post pictures to record his life and specify who can follow these posts, a friend or group members. The coolest thing in Rising is that one group can join with another group and group members can chat with each other temporarily. It offers an opportunity to contact with a group of students who have the same interests.

Another attractive reason for students is there are so many activities in Rising. The Rising offers different kinds of activities for students, like basketball games, hiking, and karaoke competition. The club group also offers interesting activities to attract more students to join them. If you join in an activity, you can post a story with pictures to the special activity and other students who want but can’t participate in the activity can watch the stories.

<h3 align="center">
  <img src="https://github.com/DeqingQu/DQView/blob/master/Screens/mainpage.png" alt="Example Chart 1" width="260"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/mypage.png" alt="Example Chart 2" width="260"/></h3>
  
<h3 align="center">
<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/chatting.png" alt="Example Chart 3" width="260"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://github.com/DeqingQu/DQView/blob/master/Screens/relation.png" alt="Example Chart 4" width="260"/>
</h3>
