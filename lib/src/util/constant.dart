class Constant {
  //Dev
  static String clientSecret = "06ce2154-ed4b-464e-89fe-07f1aa17d409";
  // static String backendEndpoint = "http://10.0.2.2:8083/api";
  static String backendEndpoint = "http://ec2-52-66-151-124.ap-south-1.compute.amazonaws.com:8081/api";
  static String contentEndpoint = "http://ec2-52-66-151-124.ap-south-1.compute.amazonaws.com:1337";
  static String keycloakEndpoint = "http://ec2-52-66-151-124.ap-south-1.compute.amazonaws.com:8080";

  //Prod
  // static String clientSecret = "5c5450dc-6f10-4e47-a52a-3c9dcc4e776f";
  // static String backendEndpoint = "https://api.foodie-apps.com/api";
  // static String keycloakEndpoint = "https://auth.foodie-apps.com";
  // static String contentEndpoint = "https://content.foodie-apps.com";


  static String deliveryEndpoint = "http://youcab-apps.com/vconnect/ext/api";
  static String deliveryAPIUserName = "mithra";
  static String deliveryAPIPassword = "mithra@875w65";

  static String merchantRole = "merchant";

  static String cartLocalStoragePostFix = "CART_ITEMS";
  static String clientCredentialKey ="CLIENT_CREDENTIAL";

  static String orderPrefix = "YCF0";

  //Dev
  static String androidAppVersion = "1.0.0";
  static String iosAppVersion = "1.0.0";

  //Prod
  // static String androidAppVersion = "1.2.8";
  // static String iosAppVersion = "1.2.8";

  static String filePath = backendEndpoint + "/file/download/";

  static String androidAppID = "com.youcab.foodie_merchant";
  static String iosAppID = "1536776141";
}
