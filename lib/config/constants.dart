import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/const/api_path.dart';

List<double> weights = [1, 1.5, 2, 2.5, 3];

List<Map<String, dynamic>> cakes = [
  {
    "title": "BLACKFOREST",
    "image": "",
    "description": "",
    "ingredient": "",
  },
  {
    "title": "PINEAPPLE",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "VANILLA",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "MANGO",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "CHOCOLATE CREAM",
    "ingredient": "",
    "image": "",
    "description": ""
  },
  {
    "title": "MANGO",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "CHOCOLATE CREAM",
    "ingredient": "",
    "image": "",
    "description": ""
  },
  {
    "title": "RASMALAI",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "PISTA",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "BUTTER SCOTCH",
    "ingredient": "",
    "image": "",
    "description": "",
  },
  {
    "title": "CHOCOLATE TRUFFLE",
    "ingredient": "",
    "image": "",
    "description": ""
  },
  {
    "title": "CUP CAKES",
    "ingredient": "",
    "image": "",
    "description": "",
  },
];

Map<String, dynamic> priceWeight = {
  "1": "45",
  "1.5": "67",
  "2": "90",
  "2.5": "112",
  "3": "135"
};

enum RestAPIRequestMethods { get, put, post, delete, patch }

enum InputFieldError { empty, invalid, notmatch }

enum LibraryType { Main, Drafts }

enum PostType { CreatePost, CreateLibraryPost, UpdatePost, UpdateLibraryPost }

enum ShareType { Reel, Group, Story, Feed }

enum ColorType { TextColor, ButtonColor, TextImageColor }

/// Media Type
enum MediaType { Image, Video, Gif, Pdf }

enum BlogPost {
  Wix,
  Weebly,
  Squarespace,
}

enum JournalPostType { Draft, Scheduled, Published }

enum SocialMedia {
  Instagram,
  Facebook,
  Snapchat,
  Twitter,
  Tiktok,
  AlexaDevice,
  LinkedIn,
  GoogleMB,
  WhatsApp,
  Wix,
  Wordpress,
  Medium,
  Hootsuite,
  FireTVApp,
  Mailchimp,
  Shopify,
}

const itemsPerPage = 15;

abstract class AppSecureStoragePreferencesKeys {
  static const String _email = "USERNAME";
  static const String _authToken = "AUTH_TOKEN";
  static const String _password = "USER_PASSWORD";
  static const String _refreshToken = "REFRESH_TOKEN";
  static const String _fcmToken = "FCM_TOKEN";

  static String get email => _email;
  static String get authToken => _authToken;
  static String get userPassword => _password;
  static String get refreshToken => _refreshToken;
  static String get fcmToken => _fcmToken;
}

abstract class AppLocalStoragePreferencesKeys {
  static const String _loggedIn = "LOGGEDIN";
  static const String _calendarId = "CALENDERID";
  static const String _calenderName = "CALENDERNAME";
  static const String _categoryId = 'CATEGORYID';
  static const String _categoryName = 'CATEGORYNAME';
  static const String _folderId = "FOLDERID";
  static const String _folderName = "FOLDERNAME";
  static const String _checkSubscriptionPurchased =
      "CHECKSUBSCRIPTIONPURCHASED";
  static const String _checkPostMuted = "CHECKPOSTMUTED";

  static String get loggedIn => _loggedIn;
  static String get calendarId => _calendarId;
  static String get calenderName => _calenderName;
  static String get categoryId => _categoryId;
  static String get categoryName => _categoryName;
  static String get folderId => _folderId;
  static String get folderName => _folderName;
  static String get checkSubscriptionPurchased => _checkSubscriptionPurchased;
  static String get postMuted => _checkPostMuted;
}

abstract class AppTimezonePreferencesKeys {
  static const String _timezone = "TIMEZONE";

  static String get email => _timezone;
}

/// Social Media Image Path
const String facebookImage = "assets/images/facebook_logo.png";
const String instagramImage = "assets/images/ic_instagram_logo.png";
const String pintrestImage = "assets/images/ic_pinterest_logo.png";
const String alexaImage = "assets/images/ic_alexa_small.png";
const String snapchatImage = "assets/images/snap_chat.jpeg";
const String tiktokImage = "assets/images/tiktok.jpeg";
const String googleMyBusiness = "assets/images/google_bussiness.svg";
const String linkedImage = "assets/images/linked_image.svg";
const String twitterImage = "assets/images/twitter_image.svg";
const String mediumImage = "assets/images/medium.png";
const String hootsuiteImage = "assets/images/medium.png";
const String wordpressImage = "assets/images/wordpress.png";
const String libraryImage = "assets/images/library.jpeg";
const String hootSuiteImage = "assets/images/hoot-suite.svg";
const String woofyImage = "assets/images/logo_outlines.png";
const String whatsAppImage = "assets/images/whatsapp.png";
const String alexaFireTVApp = "assets/images/fireTVApp.png";
const String mailchimp = "assets/images/Mailchimp.jpg";
const String weeblyImage = "assets/images/weebly.svg";
const String wixImage = "assets/images/wix.svg";
const String squareSpaceImage = "assets/images/square_space.png";
const String shopifyImage = "assets/images/shopify.svg";
const String youtubeImage = "assets/images/youtube.svg";
const String sharePostIcon = "assets/images/send.png";

/// Images to show when sharing to whatsapp
const String whatsAppShareAndroid =
    "assets/images/whatsapp_share/whatsappShareAndroid.jpeg";
const String whatsAppShareIOS1 =
    "assets/images/whatsapp_share/whatsappShareIOS1.png";
const String whatsAppShareIOS2 =
    "assets/images/whatsapp_share/whatsappShareIOS2.png";

/// Create Post action type
const List<Map<String, String>> actionType = [
  {
    "title": "Learn More",
    "value": "LEARN_MORE",
  },
  {
    "title": "Book",
    "value": "BOOK",
  },
  {
    "title": "Order",
    "value": "ORDER",
  },
  {
    "title": "Shop",
    "value": "SHOP",
  },
  {
    "title": "Sign Up",
    "value": "SIGN_UP",
  },
  {
    "title": "Call Us",
    "value": "CALL",
  },
  {
    "title": "Offer",
    "value": "OFFER",
  }
];

const List<String> fontsList = [
  'auto',
  'Glyphicons Halflings',
  'cursive',
  'emoji',
  'fangsong',
  'fantasy',
  'inherit',
  'initial',
  'math',
  'monospace',
  'none',
  'revert',
  'sans-serif',
  'serif',
  'system-ui',
  'ui-monospace',
  'ui-rounded',
  'ui-sans-serif',
  'ui-serif',
  'unset',
  '-webkit-body',
];

const List<String> gmbOffersUnit = [
  "days",
  "hours",
  "weeks",
];

const String PEG = "peg";
const String JPG = "jpg";
const String GIF = "gif";
const String PNG = "png";
const String MP4 = "mp4";
const String MKV = "mkv";

const List<String> hashtags = ["Trending Hashtags", "My First Hashtags"];

const String alreadyPostedError =
    "Oops, looks like you already scheduled something before (in the last or next 30 days) or have a post in your library that’s 100% similar to this post.";

const noReminderBasedPostMessage =
    "Hey, looks like there is no reminder selected for this post, if you want a reminder for this post you can edit it or create a new reminder based post, Thanks";

const socialMediaReminders = {
  "instagram": [
    'storyReminder',
    'feedReminder',
    'reelReminder',
    'carouselReminder'
  ],
  "instagram_business": [
    'feedReminderIGB',
    'carouselReminderIGB',
    'reelReminderIGB',
  ],
  "facebook": [
    'storyReminder',
    'personalTimelineReminder',
    'nonAdminGroupsReminder'
  ],
  "tikTok": ['storyReminder', 'feedReminder'],
};

const smReminderTexts = {
  "feedReminder": 'Feed Reminder to Mobile App',
  "reelReminder": 'Reel Reminder to Mobile App',
  "carouselReminder": 'Carousel Reminder to Mobile App',
  "storyReminder": 'Story Reminder to Mobile App',
  "personalTimelineReminder": 'Feed (Personal Timeline) Reminder to Mobile App',
  "nonAdminGroupsReminder": 'Non-Admin Groups Reminder to Mobile App',
  'autoFeed': "Auto posting to Feed",
  'autoReel': "Auto posting to Reel",
  'autoCarousel': "Auto posting to Carousel",
};

const subscriptionType = {
  'monthly_pro': 'Monthly Pro',
  'annual_pro': 'Annual Pro',
  'monthly_smb': 'Monthly Smb',
  'annual_smb': 'Annual Smb',
  'monthly_agency': 'Monthly Agency',
  'annual_agency': 'Yearly Agency',
  'monthly_single': 'Monthly Single',
  'annual_single': 'Yearly Single',
  'monthly_agencyplus': 'Monthly Agency Plus',
  'annual_agencyplus': 'Yearly Agency Plus',
  'monthly_enterprise': 'Monthly Enterprise',
  'annual_enterprise': 'Yearly Enterprise',
  'premium': 'premium',
};

List<String> agencyPlan = [
  subscriptionType['annual_agency']!,
  subscriptionType['monthly_agency']!
];
List<String> smbPlan = [
  subscriptionType['monthly_smb']!,
  subscriptionType['annual_smb']!,
];
List<String> proPlan = [
  subscriptionType['monthly_pro']!,
  subscriptionType['annual_pro']!
];
List<String> singlePlan = [
  subscriptionType['monthly_single']!,
  subscriptionType['annual_single']!
];
List<String> agencyPlusPlan = [
  subscriptionType['monthly_agencyplus']!,
  subscriptionType['annual_agencyplus']!
];
List<String> enterprisePlan = [
  subscriptionType['monthly_enterprise']!,
  subscriptionType['annual_enterprise']!
];

List<Map<String, dynamic>> socialAccounts = [
  {
    "image_path": twitterImage,
    "account_name": "Add Twitter account",
    "account_add_url": "${Application.restService!.appAPIBaseUrl}" +
        "/api/twitter/login" +
        "?calendarId=${Application.localStorageService!.calendarId}" +
        "userToken=${AppUser.authToken}",
  },
  {
    "image_path": facebookImage,
    "account_name": "Add Facebook account",
    "account_add_url": Application.restService!.appAPIBaseUrl +
        ApiRestEndPoints.facebookLogin +
        "?calendarId=${Application.localStorageService!.calendarId}" +
        "userToken=${AppUser.authToken}",
  },
  {
    "image_path": linkedImage,
    "account_name": "Add LinkedIn account",
    "account_add_url": Application.restService!.appAPIBaseUrl +
        ApiRestEndPoints.linkedLogin +
        "?calendarId=${Application.localStorageService!.calendarId}" +
        "userToken=${AppUser.authToken}",
  },
  {
    "image_path": instagramImage,
    "account_name": "Add Instagram account",
    "account_add_url": "",
    "child": [
      {
        "image_path": instagramImage,
        "account_name": "Add Personal Account",
        "account_add_url": Application.restService!.appAPIBaseUrl +
            ApiRestEndPoints.instagramLogin +
            "?calendarId=${Application.localStorageService!.calendarId}" +
            "userToken=${AppUser.authToken}",
      },
      {
        "image_path": instagramImage,
        "account_name": "Add Business Account",
        "account_add_url": Application.restService!.appAPIBaseUrl +
            ApiRestEndPoints.instagramBusinessLogin +
            "?calendarId=${Application.localStorageService!.calendarId}" +
            "userToken=${AppUser.authToken}",
      }
    ]
  },
  {
    "image_path": tiktokImage,
    "account_name": "Add TikTok account",
    "account_add_url": "",
  },
  {
    "image_path": googleMyBusiness,
    "account_name": "Add Google MB account",
    "account_add_url": Application.restService!.appAPIBaseUrl +
        "/api/googleMB/login" +
        "?calendarId=${Application.localStorageService!.calendarId}" +
        "userToken=${AppUser.authToken}",
  },
  {
    "image_path": pintrestImage,
    "account_name": "Add Pinterest account",
    "account_add_url": Application.restService!.appAPIBaseUrl +
        ApiRestEndPoints.pinterestLogin +
        "?calendarId=${Application.localStorageService!.calendarId}" +
        "userToken=${AppUser.authToken}",
  },
  {
    "image_path": snapchatImage,
    "account_name": "Add Snapchat account",
    "account_add_url": "",
  },
];

const List<Map<String, String>> bloggingAccounts = [
  {
    "image_path": mediumImage,
    "account_name": "Add Medium account",
    "account_add_url": "",
  },
  {
    "image_path": wordpressImage,
    "account_name": "Add Worpress account",
    "account_add_url": "",
  },
];

const List<Map<String, String>> entertainmentAccounts = [
  {
    "image_path": alexaImage,
    "account_name": "Add Alexa account",
    "account_add_url": "",
  },
];
