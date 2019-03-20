class Bmob {
  //Bmob REST API 地址
  static String bmobHost = "https://api2.bmob.cn";

  //Bmob 应用ID
  static String bmobAppId = "";

  //Bmob REST API 密钥
  static String bmobRestApiKey = "";

  //Bmob REST API 管理密钥
  static String bmobMasterKey = "";

  static const String BMOB_PROPERTY_OBJECT_ID = "objectId";
  static const String BMOB_PROPERTY_CREATED_AT = "createdAt";
  static const String BMOB_PROPERTY_UPDATED_AT = "updatedAt";
  static const String BMOB_PROPERTY_SESSION_TOKEN = "sessionToken";

  static const String BMOB_KEY_TYPE = "__type";
  static const String BMOB_KEY_CLASS_NAME = "className";
  static const String BMOB_KEY_RESULTS = "results";

  static const String BMOB_API_VERSION = "/1";
  static const String BMOB_API_CLASSES = BMOB_API_VERSION + "/classes/";
  static const String BMOB_API_USERS = BMOB_API_VERSION + "/users";
  static const String BMOB_API_LOGIN = BMOB_API_VERSION + "/login";
  static const String BMOB_API_SLASH = "/";
  static const String BMOB_API_SEND_SMS_CODE = BMOB_API_VERSION + "/requestSmsCode";

  static const String BMOB_API_VERIFY_SMS_CODE = BMOB_API_VERSION + "/verifySmsCode/";

  static const String BMOB_TYPE_POINTER = "Pointer";

  static const String BMOB_CLASS_BMOB_USER = "BmobUser";

  static const String BMOB_CLASS_BMOB_INSTALLATION = "BmobInstallation";

  static const String BMOB_TABLE_USER = "_User";

  static const String BMOB_TABLE_INSTALLATION = "_Installation";

  static const String BMOB_ERROR_OBJECT_ID = "ObjectId is null or empty.";

  static const int BMOB_ERROR_CODE_LOCAL = 1001;

  //SDK初始化
  static void init(appId, apiKey) {
    bmobAppId = appId;
    bmobRestApiKey = apiKey;
  }

  //SDK初始化，包含master key，允许操作其他用户
  static void initMasterKey(appId, apiKey, masterKey) {
    init(appId, apiKey);
    bmobMasterKey = masterKey;
  }
}
