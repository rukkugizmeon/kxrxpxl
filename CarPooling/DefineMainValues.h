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

#define kGoogleMapsAPIKey @"AIzaSyCtxwsGBdMjvLV3Jz1mzZGO8oIzOr69jwQ"

#define kGooglePlacesAPIKey @"AIzaSyC1CHljfuBrSeTgXmm_NuJ1HZC6moNRRPE"

#define kGoogleMapsZoomLevelDefault 10

#define kLocationCacheExpiryTime 5

#define kApplicationName @"RideWithMe"

#define kErrorMessageLocationDataUnavailable @"Unable to determine your location."

#define kCitySelectionDataExpiry 400

#define kShopOwnerProfileProductsLimit 2

#define kImageUploadQuality 0.3f

#define UnableToProcess @"Unable to process the request"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kServerConnectionTimeOut 1000



#define kKeyChainCredStoreID @"XvVSs4KTArq94l74zHcitqSA3eyXGGlGq4atpF533UkjJ8U0"
//Device token
#define kServerLink_saveDevicetoken @"http://ridewithme.in/index.php?r=api/SaveIOSId"

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

//Update Payments

#define kServerLink_setPayment @"http://ridewithme.in/index.php?r=Api/setPayment"


//Search Route

#define kServerLink_SearchRoute @"http://ridewithme.in/index.php?r=Api/searchRouteNew"


//Taker/Giver Details

#define kServerLink_GTDetails @"http://ridewithme.in/index.php?r=api/FetchDriverDetails"


//Journey Request

#define kServerLink_journeyRequest @"http://ridewithme.in/index.php?r=api/createJourneyRequest"


//Block User

#define kServerLink_BlockUser @"http://ridewithme.in/index.php?r=api/BlockUsers"



//Journey Request Recieved

#define kServerLink_journeyRequestRecieved @"http://ridewithme.in/index.php?r=api/getJourneyRequests"


//Journey Request Sent

#define kServerLink_journeyRequestSent @"http://ridewithme.in/index.php?r=Api/getJourneyRequestsSent"

//Requested Passengers

#define kServerLink_journeyRequestPassengers @"http://ridewithme.in/index.php?r=Api/getRequestedPassengers"


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


//Get RidePoints

#define kServerLink_GetRidepoints @"http://ridewithme.in/index.php?r=api/RidePointDetails"



//Reject user request

#define kServerLink_RejectRequest @"http://ridewithme.in/index.php?r=api/cancelJourneyRequest"
//requestId,userId


//Get Coriders

#define kServerLink_GetCoriders @"http://ridewithme.in/index.php?r=Api/getJourneyParticipants"//GetJourneyParticipants"


//GetCorriders Info

#define kServerLink_GetCoridersProfile @"http://ridewithme.in/index.php?r=Api/getCorriderProfile"

//Get each coriders profile

 #define kServerLink_GetCoridersProfileById @"http://ridewithme.in/index.php?r=Api/fetchPassengerProfileById"

//Get journey Details
#define kServerLink_GetJourneyDetaails @"http://ridewithme.in/index.php?r=api/GetJourneyDetails"

//Start | end journey
#define kServerLink_StartStopJourney @"http://ridewithme.in/index.php?r=Profile/startJourney"


// get journey complete list

#define kServerLink_GetNotifications @"http://ridewithme.in/index.php?r=JourneyComplete/GetReviewItems"

//confirm journey complete
#define kServerLink_ReviewJourneyCompleteConfirmation @"http://ridewithme.in/index.php?r=JourneyComplete/reviewJourneyComplete"

// send feedback

#define kServerLink_ReviewJourneyCompleteConfirmationFeedback @"http://ridewithme.in/index.php?r=JourneyComplete/postComments"

#define kServerLink_SetPayment @"http://ridewithme.in/index.php?r=Api/SetPayment"