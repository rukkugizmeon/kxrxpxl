//
//  DefineMainValues.h
//
//  Created by arjun on 23/07/14.
//  Copyright (c) 2014 Gizmeon Technologies. All rights reserved.
//


#define kApplicationWideCacheExpiry 2160000 // 25 Days

#define kDocViewCacheMemorySize 6*1024*1024 // 6MB

#define kDocViewCacheDiskUsageSize 120*1024*1024 // 120MB

#define kConnectionTimeOut 45

#define kConnectionTimeOutImageUpload 60

#define kEncryptionKey @"5B496CE1514C275A13A9E16687F2A"

#define kAuthenticationCompletionTag @"success"

#define kViewRoundedCornerVal 12.0f

#define kGoogleMapsAPIKey @"AIzaSyAwwaoXs4rZj8H1L2Z1riGZGSR31xtAml0"

#define kGoogleMapsZoomLevelDefault 10

#define kLocationCacheExpiryTime 5

#define kApplicationName @"CarPooling"

#define kErrorMessageLocationDataUnavailable @"Unable to determine your location."

#define kCitySelectionDataExpiry 400

#define kShopOwnerProfileProductsLimit 2

#define kImageUploadQuality 0.3f

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Login
//#define kServerLink_UserAuthenticationLink @"http://ridewit1.wwwss11.a2hosting.com/index.php?r=Api/login"

// Login
#define kServerLink_UserAuthenticationLink @"http://ridewithme.in/index.php?r=Api/login"

/// User Registration

#define kServerLink_Registration @"http://ridewithme.in/index.php?r=Api/Registration"


// Profile View

#define kServerLink_ProfileView @"http://ridewithme.in/index.php?r=Api/ViewProfile"


// Update Profile

#define kServerLink_UpdateProfile @"http://ridewithme.in/index.php?r=Api/UpdateProfile"

// Add Route

 #define kServerLink_AddRoute @"http://ridewithme.in/index.php?r=Api/addRoute"


// Journey List

#define kServerLink_JourneyList @"http://ridewithme.in/index.php?r=Api/JourneyList"


// Get Journey Points

#define kServerLink_JourneyPoints @"http://ridewithme.in/index.php?r=Api/GetRoute"


//Upadte Route

#define kServerLink_UpadteRoute @"http://ridewithme.in/index.php?r=Api/UpdateRoute"


//Delete My Routes

#define kServerLink_DeleteRoute @"http://ridewithme.in/index.php?r=api/deleteRoute"


//Edit Route

#define kServerLink_EditRoute @"http://ridewithme.in/index.php?r=api/updateRouteDetails"

//Get Earnings

#define kServerLink_GetEarnings @"http://ridewithme.in/index.php?r=Api/getEarnings"


//Search Route

#define kServerLink_SearchRoute @"http://ridewithme.in/index.php?r=Api/searchRoute"


//Taker/Giver Details

#define kServerLink_GTDetails @"http://ridewithme.in/index.php?r=api/FetchDriverDetails"


//Journey Request

#define kServerLink_journeyRequest @"http://ridewithme.in/index.php?r=api/createJourneyRequest"


//Journey Request Recieved

#define kServerLink_journeyRequestRecieved @"http://ridewithme.in/index.php?r=api/getJourneyRequests"


//Journey Request Sent

#define kServerLink_journeyRequestSent @"http://ridewithme.in/index.php?r=Api/getJourneyRequestsSent"

//Requested Passengers

#define kServerLink_journeyRequestPassengers @"http://ridewithme.in/index.php?r=Api/getRequestedPassengers" 
//userId,journeyId


//User Polyline

#define kServerLink_UserPolyline @"http://ridewithme.in/index.php?r=api/GetWaypointsByRouteId"


//Accept user request

#define kServerLink_AcceptRequest @"http://ridewithme.in/index.php?r=api/approveJourneyRequest"
 //requestId,userId


// Set Favourite

#define kServerLink_AddToFavourites @"http://ridewithme.in/index.php?r=api/setFavourite"
//* userId,fave_user_id


//Give Ratings

#define kServerLink_SaveRatings @"http://ridewithme.in/index.php?r=api/saveRatings"
//* params:userId,userIdRate


//Reject user request

#define kServerLink_RejectRequest @"http://ridewithme.in/index.php?r=api/cancelJourneyRequest"
//requestId,userId


//Get Coriders

#define kServerLink_GetCoriders @"http://ridewithme.in/index.php?r=Api/GetJourneyParticipants"


//GetCorriders Info

#define kServerLink_GetCoridersProfile @"http://ridewithme.in/index.php?r=Api/getCorriderProfile"

//Get each coriders profile

 #define kServerLink_GetCoridersProfileById @"http://ridewithme.in/index.php?r=Api/fetchPassengerProfileById"

