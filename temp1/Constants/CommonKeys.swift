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


//MARK: Common keys //<= struct 만들어서 감싸는게 낫지 않을가?
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
