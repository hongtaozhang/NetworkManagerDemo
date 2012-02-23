#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ActivityIndicator.h"

typedef enum {
    kDeviceIPhone = 0,
    kDeviceIPad
} DeviceType;

//Getting device type
CG_INLINE DeviceType deviceType()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
		return kDeviceIPad;
	else
		return kDeviceIPhone;
#else
	return kDeviceIPhone;
#endif
}

CG_INLINE BOOL isPad()
{
	return (BOOL)(deviceType() == kDeviceIPad);
}

#ifdef DEBUG
#define AILOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define AILOG(xx, ...) ((void)0)
#endif

#define AI_RGBA(r,g,b,a)                    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define AI_RGBAF(r,g,b,a)                   [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:a]

#define AIROMO_URL                          @"https://api.airomo.net/0/"
#define AIROMO_REQUEST_TIMEOUT              20.0

//Loged USER 
#define LOGGED_USER_KEY                     @"loggeduserkey"
#define loggedUser()                        [[NSUserDefaults standardUserDefaults] objectForKey:@"loggeduserkey"]
#define DEVICE_TOKEN                        @"devicetoken"
#define deviceToken()                       [[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"]
#define TGT_TICKET                          @"tgtticket"
#define tgtTicket()                         [[NSUserDefaults standardUserDefaults] objectForKey:@"tgtticket"]
#define RESET_BEFORESYNC                    @"resetbeforesync"
#define resetBeforeSync()                   [[NSUserDefaults standardUserDefaults] objectForKey:@"resetbeforesync"]
#define AUTH_TOKEN                          @"authtoken"
#define getAuthToken()                      [[NSUserDefaults standardUserDefaults] objectForKey:@"authtoken"]

//global sharing settings
#define CS_SHARING_CUSTOM                   @"custom"
#define SS_SHARING_NONE                     @"none"
#define CS_SHARING_NONE                     @"none"
#define SS_SHARING_NOSETVALUE               @"cond_status_no_val"
#define CS_SHARING_MESSAGE                  @"message"
#define SS_SHARING_MESSAGE                  @"description"

#define SS_SHARING_SEX                      @"pivot_points_sex"
#define SS_SHARING_SEX_MALE                 @"male"
#define SS_SHARING_SEX_FEMALE               @"female"
#define SS_SHARING_SEX_DEFAULT              @"doesn't matter"

#define CS_SHARING_SEX                      @"Sex"
#define CS_SHARING_SEX_MALE                 @"male"
#define CS_SHARING_SEX_FEMALE               @"female"
#define CS_SHARING_SEX_DEFAULT              @"doesn't matter"

#define SS_SHARING_SEX_LIST                 SS_SHARING_SEX_MALE, SS_SHARING_SEX_FEMALE, SS_SHARING_SEX_DEFAULT
#define CS_SHARING_SEX_LIST                 CS_SHARING_SEX_MALE, CS_SHARING_SEX_FEMALE, CS_SHARING_SEX_DEFAULT

//
#define SS_SHARING_AUDIENCE                 @"airomo_network"
#define SS_SHARING_AUDIENCE_EVERYONE        @"everyone"
#define SS_SHARING_AUDIENCE_FRIENDS         @"friends"
#define SS_SHARING_AUDIENCE_FAMILY          @"family"
#define SS_SHARING_AUDIENCE_COWORKERS       @"co-workers"
#define SS_SHARING_AUDIENCE_DEFAULT         @"custom"

#define CS_SHARING_AUDIENCE                 @"Airomo Audience"
#define CS_SHARING_AUDIENCE_EVERYONE        @"everyone"
#define CS_SHARING_AUDIENCE_FRIENDS         @"friends"
#define CS_SHARING_AUDIENCE_FAMILY          @"family"
#define CS_SHARING_AUDIENCE_COWORKERS       @"co-workers"
#define CS_SHARING_AUDIENCE_DEFAULT         @"custom"

#define SS_SHARING_AUDIENCE_LIST            SS_SHARING_AUDIENCE_EVERYONE, SS_SHARING_AUDIENCE_FRIENDS, SS_SHARING_AUDIENCE_FAMILY, SS_SHARING_AUDIENCE_COWORKERS, SS_SHARING_AUDIENCE_DEFAULT
#define CS_SHARING_AUDIENCE_LIST            CS_SHARING_AUDIENCE_EVERYONE, CS_SHARING_AUDIENCE_FRIENDS, CS_SHARING_AUDIENCE_FAMILY, CS_SHARING_AUDIENCE_COWORKERS, CS_SHARING_AUDIENCE_DEFAULT
//
#define SS_SHARING_LOCATION                 @"pivot_points_location_city"
#define SS_SHARING_LOCATION_NOVALUE         @"doesn't matter"
#define SS_SHARING_LOCATION_SANFRANCISCO    @"San Francisco"
#define SS_SHARING_LOCATION_NY              @"New York"
#define SS_SHARING_LOCATION_CUSTOM          @"custom"

#define CS_SHARING_LOCATION                 @"Target Location"
#define CS_SHARING_LOCATION_NOVALUE         @"doesn't matter"
#define CS_SHARING_LOCATION_SANFRANCISCO    @"San Francisco"
#define CS_SHARING_LOCATION_NY              @"New York"
#define CS_SHARING_LOCATION_CUSTOM          @"custom"

#define SS_SHARING_LOCATION_LIST SS_SHARING_LOCATION_NOVALUE, SS_SHARING_LOCATION_SANFRANCISCO, SS_SHARING_LOCATION_NY, SS_SHARING_LOCATION_CUSTOM
#define CS_SHARING_LOCATION_LIST CS_SHARING_LOCATION_NOVALUE, CS_SHARING_LOCATION_SANFRANCISCO, CS_SHARING_LOCATION_NY, CS_SHARING_LOCATION_CUSTOM
//
#define SS_SHARING_RATING                   @"like_string"
#define SS_SHARING_RATING_LIKE              @"i.like"
#define SS_SHARING_RATING_LOVE              @"i.love"
#define SS_SHARING_RATING_HATE              @"i.hate"
#define SS_SHARING_RATING_COOL              @"cool!"
#define SS_SHARING_RATING_SUCK              @"suck!"

#define CS_SHARING_RATING                   @"Expected Raiting"
#define CS_SHARING_RATING_LIKE              @"i.like"
#define CS_SHARING_RATING_LOVE              @"i.love"
#define CS_SHARING_RATING_HATE              @"i.hate"
#define CS_SHARING_RATING_COOL              @"cool!"
#define CS_SHARING_RATING_SUCK              @"suck!"

#define SS_SHARING_RATING_LIST              SS_SHARING_RATING_LIKE, SS_SHARING_RATING_LOVE, SS_SHARING_RATING_HATE, SS_SHARING_RATING_COOL, SS_SHARING_RATING_SUCK
#define CS_SHARING_RATING_LIST              CS_SHARING_RATING_LIKE, CS_SHARING_RATING_LOVE, CS_SHARING_RATING_HATE, CS_SHARING_RATING_COOL, CS_SHARING_RATING_SUCK

#define SS_SHARING_CROSSPOST                @"anonymous_status"
#define SS_SHARING_CROSSPOST_FACEBOOK       @"Facebook"
#define SS_SHARING_CROSSPOST_TWITTER        @"Twitter"
#define SS_SHARING_CROSSPOST_LINKEDIN       @"Linkedin"

#define CS_SHARING_CROSSPOST                @"Cross-post"
#define CS_SHARING_CROSSPOST_FACEBOOK       @"Facebook"
#define CS_SHARING_CROSSPOST_TWITTER        @"Twitter"
#define CS_SHARING_CROSSPOST_LINKEDIN       @"Linkedin"

#define SS_SHARING_CROSSPOST_LIST           SS_SHARING_CROSPOST_FACEBOOK, SS_SHARING_CROSSPOST_TWITTER, SS_SHARING_CROSSPOST_LINKEDIN
#define CS_SHARING_CROSSPOST_LIST           CS_SHARING_CROSSPOST_FACEBOOK, CS_SHARING_CROSSPOST_TWITTER, CS_SHARING_CROSSPOST_LINKEDIN

//sharing settigns list
#define SS_SAHRING_SETTINGS_LIST            SS_SHARING_SEX, SS_SHARING_AUDIENCE, SS_SHARING_LOCATION, SS_SHARING_RATING, SS_SHARING_CROSSPOST
#define CS_SAHRING_SETTINGS_LIST            CS_SHARING_SEX, CS_SHARING_AUDIENCE, CS_SHARING_LOCATION, CS_SHARING_RATING, CS_SHARING_CROSSPOST
//tmp list of cities
#define CITY_LIST @"Los Angeles, CA, USA", @"Los Gatos, CA, USA", @"Lviv, LV, UA", @"Odesa, OD, UA", @"Kyiv, KY, UA", \
                    @"Warshava, WA, PL", @"Yavoriv, LV, UA", @"NY, LV, UA"

#define GENERAL_LIST                        @"Community", @"Co-workers", @"Neighbors", @"College Mates"
#define FRIENDS_LIST                        @"John Doe", @"Hugh Wilson", @"Ted Jameson", @"Vovchyk Kolomyiko"

//iOS version
#define SYSTEM_VERSION_LESS_THAN(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//applications
#define INSTALLED_APPS                      @"installedapps"
#define installedApps()                     [[NSUserDefaults standardUserDefaults] objectForKey:@"installedapps"]

//Photos dictionary keys
#define PHOTOS_GUID_KEY                     @"photosguid"
#define PHOTOS_TITLE_KEY                    @"photostitle"
#define PHOTOS_LIKED_KEY                    @"photosliked"
#define PHOTOS_SHARED_KEY                   @"photosshared"
#define PHOTOS_IMAGE_KEY                    @"photosimage"

//Musics album dictionary keys
#define MUSICS_GUID_KEY                     @"musicguid"
#define MUSICS_ALBOM_TITLE_KEY              @"musicalbomtitle"
#define MUSICS_ARTIST_TITLE_KEY             @"musicartisttitle"
#define MUSICS_LIKED_KEY                    @"musicliked"
#define MUSICS_SHARED_KEY                   @"musicshared"
#define MUSICS_IMAGE_KEY                    @"musicimage"

//Musics song dictionary keys
#define SONG_GUID_KEY                       @"songguid"
#define SONG_TITLE_KEY                      @"songtitle"
#define SONG_ARTIST_TITLE_KEY               @"songartisttitle"
#define SONG_LIKED_KEY                      @"songliked"
#define SONG_SHARED_KEY                     @"songshared"
#define SONG_IMAGE_KEY                      @"albumimage"
#define SONG_ALBUM_KEY                      @"songalbum"

//Video dictionary keys
#define VIDEO_GUID_KEY                      @"videoguid"
#define VIDEO_TITLE_KEY                     @"videotitle"
#define VIDEO_DURATION_KEY                  @"videoduration"
#define VIDEO_LIKED_KEY                     @"videoliked"
#define VIDEO_SHARED_KEY                    @"videoshared"
#define VIDEO_IMAGE_KEY                     @"videoimage"

//Document dictionary keys
#define DOCUMENT_GUID_KEY                   @"documentguid"
#define DOCUMENT_TITLE_KEY                  @"documenttitle"
#define DOCUMENT_LIKED_KEY                  @"documentliked"
#define DOCUMENT_SHARED_KEY                 @"documentshared"

//App dictionary keys
#define APPLICATION_GUID_KEY                @"applicationguid"
#define APPLICATION_TITLE_KEY               @"applicationtitle"
#define APPLICATION_LIKED_KEY               @"applicationliked"
#define APPLICATION_SHARED_KEY              @"applicationshared"
#define APPLICATION_VERSION_KEY             @"applicationversion"

//Photos notifications
#define MUSICS_REQUEST_FINISHED             @"musicrequestfinished"
#define VIDEOS_REQUEST_FINISHED             @"videorequestfinished"
#define PHOTOS_REQUEST_FINISHED             @"photorequestfinished"
#define BOOKS_REQUEST_FINISHED              @"bookrequestfinished"
#define DOCUMENT_REQUEST_FINISHED           @"documentsrequestfinished"
#define RINGTONS_REQUEST_FINISHED           @"ringtonrequestfinished"
#define APPLICATIONS_REQUEST_FINISHED       @"applicationrequestfinish"

// Local storage for processes
#define kAppKeyID                           @"id"
#define kAppKeyName                         @"procName"
#define kAppKeyAppName                      @"appName"
#define kAppKeyPID                          @"processId"
#define kAppKeyIconData                     @"iconData"
#define kAppKeyIconURL                      @"iconURL"
#define kAppKeyFinished                     @"guessFinished"
#define kAppKeySucceeded                    @"guessSucceeded"
#define kAppKeyLiked                        @"liked"
#define kAppKeyShared                       @"shared"
#define kAppKeyURIScheme                    @"URIscheme"

#define kMediaFileKeyID                     @"id"
#define kMediaFileKeyArtwork                @"artwork"
#define kMediaFileKeyArtist                 @"artist"
#define kMediaFileKeyTitle                  @"title"
#define kMediaFileKeyYear                   @"year"
#define kMediaFileKeyDuration               @"duration"
#define kMediaFileKeyLiked                  @"liked"
#define kMediaFileKeyShared                 @"shared"

// AppCurl requests
#define APPCURL_API_URL                     @"http://api.appcurl.com/"
#define METHOD_APPFIND_1                    @"mqs?q=%@&platform=1"
#define METHOD_APPFIND_2                    @"parsepn?platform=1&pn=%@"
#define USER_APP_FILE                       @"userapps.plist"
#define APPCURL_REQUEST_TIMEOUT             15.0

#define kApplicationName                    @"AiromoCloved"

//#define TheAppDelegate                    ((AppListAppDelegate *)[UIApplication sharedApplication].delegate)
