//
//  Constants.swift
//  temp1
//
//  Created by 현은백 on 2023/08/23.
//

import Foundation


//MARK: - ERROR code
let ERR_RESPONSE =                          400000
let ERR_SEND_FAILURE =                      777000
let ERR_RESULT_DOES_NOT_EXIST =             777001
let ERR_UNKNOWN_RESULT =                    777002
let ERR_UNKNOWN_EXCEPTION =                 999999

//MARK: Common keys //<= struct 만들어서 감싸는게 낫지 않을가? -> No. ObjectiveC 때문에 안됨.
let kAPIType =                               "apiType"
let kPlayerStatus =                          "playerStatus"
let kRequestURL =                            "requestURL"
let kParam =                                 "param"
let kAccessLogURL =                          "access_log_url"
let kWatchLogURL =                           "watch_log_url"
let kDownloadLogURL =                        "download_log_url"
let kActivityLogURL =                        "activity_log_url"
let kCheckInterval =                         "check_interval_sec"
let kAuthToken =                             "auth_token"
let kAccessSession =                         "access_session"
let kWatchSession =                          "watch_session"
let kDownloadSession =                       "download_session"
let kErrorCode =                             "error_code"
let kErrorLog =                              "error_log"
let kSessionStartTimeStamp =                 "session_start_timestamp"
let kTimeStamp =                             "timestamp"

//Init SDK
let kPNServiceID =                           "userID"
let kPNServicePassword =                     "userPassword"
let kPNServiceName =                         "serviceName"
// Access
let kPNAppVersion =                          "appVersion"
let kPNUserID =                              "userID"
let kPNEmail =                               "email"
let kPNUserType =                            "userType"
let kPNGender =                              "gender"
let kPNBirthday =                            "birthday"
let kPNHouseholdID =                         "householdID"
// Watch
let kPNAssetID =                             "assetID"
let kPNServerName =                          "serverName"
let kPNCP =                                  "cp"
let kPNCategory =                            "category"
let kPNSeriesName =                          "seriesName"
let kPNSeasonName =                          "seasonName"
let kPNEpisodeName =                         "episodeName"
let kPNCollectionName =                      "collectionName"
let kPNServiceType =                         "serviceType"
let kPNAudioLang =                           "audioLang"
let kPNSubtitleLang =                        "subtitleLang"
let kPNPlaybackSpeed =                       "playbackSpeed"
let kPNBitrate =                             "Bitrate"
// Download
let kPNValidUntil =                          "validUntil"
// Error
let kPNErrCode =                             "errCode"
let kPNErrMsg =                              "errMs"


// Request param keys
let kServerType =                             "serverType"
let kService =                                "service"
let kPlatform =                               "platform"
let kPlatformiOS =                            "IOS"
let kPlatformtvOS =                           "APPLETV"
let kAdminID =                                "admin_id"
let kAdminPass =                              "admin_password"
let kActionType =                             "action_type"
let kHouseholdID =                            "household_id"
let kUserID =                                 "user_id"
let kEmail =                                  "email"
let kUserType =                               "user_type"
let kAppVersion =                             "app_ver"
let kOS =                                     "os"
let kOSVersion =                              "os_ver"
let kSDKVersion =                             "sdk_ver"
let kDeviceID =                               "device_id"
let kDeviceVendor =                           "device_vendor"
let kDeviceModel =                            "device_model"
let kBrowserName =                            "browser_name"
let kBrowserVersion =                         "browser_ver"
let kCountry =                                "country"
let kRegion =                                 "region"
let kCity =                                   "city"
let kGender =                                 "gender"
let kBirthDate =                              "birth_date"
let kIP =                                     "ip"
let kISP =                                    "isp"
let kCP =                                     "cp"
let kCategory =                               "category"
let kSeriesName =                             "series_name"
let kSeasonName =                             "season_name"
let kEpisodeName =                            "episode_name"
let kEpisodeNum =                             "episode_num"
let kContentDuration =                        "duration"
let kAssetID =                                "asset_id"
let kParentID =                               "parent_id"
let kCollectionName =                         "collection_name"
let kServiceType =                            "service_type"
let kPlaybackPosition =                       "playback_position"
let kIsFinish =                               "is_finish"
let kPlaybackSpeed =                          "playback_speed"
let kSubtitleLang =                           "subtitle_lang"
let kAudioLang =                              "audio_lang"
let kCastType =                               "cast_type"
let kServerName =                             "server_name"
let kBitrate =                                "bitrate"
let kValidUntil =                             "valid_until"
let kUICode =                                 "ui_code"
let kParameter =                              "parameter"




