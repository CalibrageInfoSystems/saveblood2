library APIConstants;

const String SUCCESS_MESSAGE = " You will be contacted by us very soon.";
//var baseUrl =    "http://saveblood.org/api/"; //Direct Domain
//var baseUrl =    "http://103.27.86.198/savebloodtestapi/";  //Demo
//var baseUrl =    "http://103.27.86.198/savebloodapi/";  // Live
//var baseUrl = "http://183.82.111.111/SaveBloodAPILatest/";      // Test
//var baseUrl = "http://183.82.111.111/SaveBloodAPIUSA/";

// var baseUrl = "http://183.82.111.111/savebloodapi/"; http://183.82.111.111/SaveBlood/API/swagger/index.html

// var baseUrl = 'http://183.82.111.111/savebloodtest/';

var baseUrl = 'http://183.82.111.111/SaveBlood/API/';

//  var baseUrl ="http://api.saveblood.org/";     // Live

var loginComponentUrl = "api/Account/Login";

var recoverPasswordComponentUrl = "api/Account/public/recoverpassword";

var signUpComponentUrl = "api/Account/public/mobileUsers";

var getProfileComponentUrl = "api/Account/users/userinfoById?userId=";

var getUserInfoByIdComponentUrl = "api/Account/users/userinfoById";

var getbloodgroupsUrl = "api/BloodInventory/BloodTypes";

var getClassTypeComponentUrl = "/api/Master/ClassType";

var getTypeCdDmtByClassTypeIdComponentUrl = "api/Master/TypeCdDmtByClassTypeId";

var getCountryComponentUrl = "api/Country";

var getStatesByCountryComponentUrl = "api/State/GetStatesByCountry/";

var getDistrictsByStateComponentUrl = "api/District/GetDistrictsByState/";

var getMandalsByDistrictComponentUrl = "api/Mandal/GetMandalsByDistrict/";

var getVillagesByMandalComponentUrl = "api/Village/GetVillagesByMandal/";

var updateProfileComponentUrl = "api/Account/UserInfo";

var getAllNotificationsUrl = "api/Notification/AllMobileNotifications";

var getlocalBloodbanksBylatlong = "api/GeoLocation/GetNearByBloodBanks";

var eventsbybloddbankid = "api/Event/Get/";

var bloodInventoryURL = "api/BloodInventory/BloodInventoryByEntityId/";

var doAcceptNotificationComponentUrl =
    "api/Notification/AcceptOrRejectNotificationForMobile";

var doRejectNotificationComponentUrl =
    "api/Notification/AcceptOrRejectNotificationForMobile";

var updateGeoLocationComponentUrl = "api/GeoLocation";

var updateDeviceTokenComponentUrl = "api/UserInfo";

var refreshtokenCoponentURL = 'api/Account/RefreshToken';

var getCertificatesofDonar = 'api/Stock/GetDonorCertificate/';

var getGeolocationsGeoPlaces = 'api/GeoLocation/GetPlaces/';

var getGeolocationslatlong = 'api/GeoLocation/GetLatLngByPlaceId/';

var shareInfo = "check out my website https://saveblood.com";

var markAllReadNotificationsURl = "api/Notification/ReadAllNotifications/";

var donateRequestComponentURL = 'api/Request/DonorRequest';
