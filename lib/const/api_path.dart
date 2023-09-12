/// class for having API Endpoints used in the application
abstract class ApiRestEndPoints {
  /// API end points for the user service
  static const String user = '/api/user';
  static const String userDetail = '/users/:id';
  static const String cakes = '/api/cakes';
  static const String cart = '/api/cart';
  static const String order = '/api/order';

  static const String addOns = '/api/addOns';

  static const String login = '/api/auth/sign-in';
  static const String signup = '/api/auth/sign-up';
  static const String logout = '/api/auth/logout';

  static const String deleteAccount = '/api/user?allData=true';

  static const String userProfile = "/api/users/me";

  static const String register = '/api/session/register';
  static const String recoverPassword = '/api/users/forgot-password';
  static const String changePassword = '/users/changePassword';
  static const String refreshToken = "/api/session/refresh-tokekn";
  static const String post = "/api/posts";
  static const String postId = "/api/posts/{id}";
  static const String uploadImage = '/api/upload/image';
  static const String uploadVideo = '/api/upload-video';
  static const String accounts = '/api/accounts';
  static const String deleteAccountId = '/api/accounts/{id}';
  static const String campaings = '/api/campaigns/{id}';
  static const String calendars = '/api/calendars';
  static const String folders = '/api/journal/folders';

  static const String journal = '/api/journal/posts';

  static const String mobileTokens = '/api/mobile-tokens';
  static const String libraryPosts = '/api/library/posts';
  static const String postById = '/api/post/{id}';
  static const String deleteLibraryPostById = '/api/library/posts';
  static const String createLibraryPost = '/api/library/posts';
  static const String updateLibraryPost = '/api/library/posts/{id}';
  static const String categories = '/api/library/categories';
  static const String libraryPostStatistics =
      '/api/compliance-engine/library-post';
  static const String imagesByUrl = '/api/get-images-by-url';
  static const String textFromImageUrl =
      '/api/google-service/get-text-from-image-url';
  static const String detectAnnotationFromImageURL =
      '/api/google-service/detect-annotation-from-image-url';

  static const String getPredectiveResult = '/api/predictive';
  static const String articleQuotes = '/api/content-engines/article-quotes';
  static const String analyzeURL = '/api/analyze-url';
  static const String emojihashtags = '/api/predictive/emoji-hashtags';
  static const String hashtagsGroup = '/api/hashtag-groups';
  static const String hashtags = '/api/hashtags';
  static const String trendingHashtags =
      '/api/content-engines/trending-hashtags';
  static const String createSignedURL = '/api/files/generate-signed-url';
  static const String getHashtagsFromImages =
      '/api/content-engines/analyze-image';
  static const String mobileToken = '/api/mobile-tokens';

  static const String facebookLogin = '/api/facebook/login';
  static const String instagramBusinessLogin = '/api/instagram-business/login';
  static const String instagramLogin = '/api/instagram/login';
  static const String linkedLogin = '/api/linkedin/login';
  static const String hootsuiteLogin = '/api/hootsuite/login';
  static const String googleLogin = '/api/googleMB/login';
  static const String pinterestLogin = '/api/pinterest/login';

  static const String fetchTextFromImages =
      '/api/google-service/get-text-from-image-url';
  static const String markPostAsPosted = '/api/posts/posted-manually/{id}';
  static const String getImagesFromURL = "/api/get-images-by-url";
  static const String getImagesFromSuggestion = "/api/image-suggestions";
  static const String deleteFiles = "/api/files/delete-files";

  static const String appleReceipt = '/api/payment/apple/receipts';
}
