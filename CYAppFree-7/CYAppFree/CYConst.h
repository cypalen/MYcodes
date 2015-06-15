//
//  CYConst.h
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef CYAppFree_CYConst_h
#define CYAppFree_CYConst_h

#define kCYZERO 0
#define kCYWINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define kCYWINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kCYNAVBAR_HEIGHT 64
#define kCYTABBAR_HEIGHT 49

#define kCYCELL_ID @"cell"
#define kCYLIMIT_CELL @"CYLimitCell"
#define kCYSUBJECT_CELL @"CYSubjectCell"

typedef enum {
    LEFT_ITEM,
    RIGHT_ITEM
}ITEM_TYPE;


#import "CYHttpRequest.h"
#import "CYAppModel.h"
#import "CYLimitCell.h"
#import "CYSubjectCell.h"
#import "UIImageView+WebCache.h"
#import "CYSubjectModel.h"
#import "CYSubView.h"
#import "CYDataBase.h"
#import "CYDetailViewController.h"


//限免URL
#define LIMIT_URL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1"

//专题接口
#define SUBJECT_URL @"http://iappfree.candou.com:8080/free/special?page=1&limit=5"

//降价接口
#define REDUCE_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=1"

//免费接口
#define FREE_URL @"http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=1"

//详情接口
#define DEATIL_URL @"http://iappfree.candou.com:8080/free/applications/%@?currency=rmb"

//附近应用接口
#define NEAR_URL @"http://iappfree.candou.com:8080/free/applications/recommend?longitude=116.344539&latitude=40.034346"



#endif
