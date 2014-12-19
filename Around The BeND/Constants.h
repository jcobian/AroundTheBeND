//
//  Constants.h
//  Around The BeND
//
//  Created by Jonathan Cobian on 3/4/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#ifndef Around_The_BeND_Constants_h
#define Around_The_BeND_Constants_h

//parse's object id
#define PARSE_OBJECT_ID @"objectId"
#define BACKGROUND_IMAGE @"blackishBackground.png"
#define TABLE_BACKGROUND_IMAGE @"blackBrushedMetal.png"
#define SPLASH_SCREEN @"launchimage.png"
#define LOGO @"aroundthebendlogo.png"
#define NAV_BAR @"blacknavbar.png"


#define NAV_BAR_TITLE_OFFSET = (10)

#define FACEBOOK_BUTTON_IMAGE @"login-button-small.png"
#define FACEBOOK_BUTTON_DOWN_IMAGE @"login-button-small-pressed.png"


#define EMPTY_STRING @""

#define BAR_TAG = (0)
#define RESTAURANT_TAG = (1)
#define SPORTS_TAG = (2)
#define OTHER_TAG = (3)
#define CAB_TAG = (4)

//Parse table names
#define COMPANY_TABLE_NAME @"Company"
#define BAR_SPECIAL_TABLE_NAME @"BarSpecial"
#define CAB_TABLE_NAME @"Cab"
#define IMAGE_TABLE_NAME @"Images"
#define RESTAURANT_SPECIAL_TABLE_NAME @"RestaurantSpecial"
#define EVENT_IMAGE_TABLE_NAME @"EventImages"
#define COMMENT_TABLE_NAME @"Comment"
#define SPORT_TABLE_NAME @"SportingEvent"
#define OTHER_TABLE_NAME @"OtherEvent"


#define GROUP_TYPE_BAR @"Bar"
#define GROUP_TYPE_RESTAURANT @"Restaurant"
#define GROUP_TYPE_SPORT @"Sport"
#define GROUP_TYPE_OTHER @"Other"


//company columns
#define COMPANY_IS_RESTAURANT @"isRestaurant"
#define COMPANY_IS_BAR @"isBar"
#define COMPANY_IS_SPORT @"isSport"
#define COMPANY_IS_OTHER @"isOther"
#define COMPANY_COLUMN_NAME @"name"
#define COMPANY_COLUMN_PHONE @"phoneNumber"
#define COMPANY_COLUMN_WEBSITE @"website"
#define COMPANY_COLUMN_ADDRESS @"address"
#define COMPANY_COLUMN_PRIORITY @"priority"
#define COMPANY_COLUMN_GEOPOINT @"geoPoint"
#define COMPANY_COLUMN_VIEWS @"numViews"

//sporting event columns
#define SPORT_COLUMN_SPORT @"sport"
#define SPORT_COLUMN_TEAM @"team"
#define SPORT_COLUMN_DATE @"date"
#define SPORT_COLUMN_DATE_STR @"dateStr"

#define SPORT_COLUMN_START_TIME @"startTime"
#define SPORT_COLUMN_LOCATION @"location"
#define SPORT_COLUMN_DESCRIPTION @"description"
#define SPORT_COLUMN_GEOPOINT @"geopoint"
#define SPORT_COLUMN_WEBSITE @"website"


//other event columns
#define OTHER_COLUMN_NAME @"name"
#define OTHER_COLUMN_DATE @"date"
#define OTHER_COLUMN_DATE_STR @"dateStr"
#define OTHER_COLUMN_START_TIME @"startTime"
#define OTHER_COLUMN_LOCATION @"location"
#define OTHER_COLUMN_DESCRIPTION @"description"
#define OTHER_COLUMN_GEOPOINT @"geopoint"
#define OTHER_COLUMN_WEBSITE @"website"



//Bar Special columns
#define BAR_SPECIAL_COLUMN_BAR_POINTER @"barPointer"
#define BAR_SPECIAL_COLUMN_BAR_POINTER_STRING @"barPointerStr"
#define BAR_SPECIAL_COLUMN_DAY_OF_WEEK @"dayOfWeek"
#define BAR_SPECIAL_COLUMN_DESCRIPTION @"description"
#define BAR_SPECIAL_COLUMN_NUM_PPL_GOING @"numPplGoing"
#define BAR_SPECIAL_COLUMN_VIEWS @"numViews"
#define BAR_SPECIAL_COLUMN_HAS_COUPON @"hasCoupon"
#define BAR_SPECIAL_COLUMN_COUPON_MESSAGE @"couponMessage"


//Cab columns
#define CAB_COLUMN_NAME @"name"
#define CAB_COLUMN_PHONE @"phoneNumber"
#define CAB_COLUMN_PRIORITY @"priority"
#define CAB_COLUMN_NUM_CALLS @"numCalls"

//Images columns
#define IMAGE_COLUMN_IMAGE @"image"
#define IMAGE_COLUMN_OBJID @"objIdStr"


//Restaurant Special columns
#define RESTAURANT_SPECIAL_COLUMN_RESTAURANT_POINTER @"restaurantPointer"
#define RESTAURANT_SPECIAL_COLUMN_RESTAURANT_POINTER_STRING @"restaurantPointerStr"
#define RESTAURANT_SPECIAL_COLUMN_DAY_OF_WEEK @"dayOfWeek"
#define RESTAURANT_SPECIAL_COLUMN_DESCRIPTION @"description"
#define RESTAURANT_SPECIAL_COLUMN_VIEWS @"numViews"
#define RESTAURANT_SPECIAL_COLUMN_HAS_COUPON @"hasCoupon"
#define RESTAURANT_SPECIAL_COLUMN_COUPON_MESSAGE @"couponMessage"


//Event Image columns
#define EVENT_IMAGE_COLUMN_EVENT_ID @"eventId"
#define EVENT_IMAGE_COLUMN_IMAGE @"image"
#define EVENT_IMAGE_UPLOAD_TIME @"createdAt"
#define EVENT_IMAGE_NUM_VIEWS @"numViews"
#define EVENT_IMAGE_CAPTION @"caption"


//COMMENT columns
#define COMMENT_COLUMN_TEXT @"text"
#define COMMENT_COLUMN_PICTURE_ID @"eventImageIdStr"
#define COMMENT_COLUMN_UPLOAD_TIME @"createdAt"





//days of week stored in parse
#define SUNDAY @"Sunday"
#define MONDAY @"Monday"
#define TUESDAY @"Tuesday"
#define WEDNESDAY @"Wednesday"
#define THURSDAY @"Thursday"
#define FRIDAY @"Friday"
#define SATURDAY @"Saturday"










#endif
