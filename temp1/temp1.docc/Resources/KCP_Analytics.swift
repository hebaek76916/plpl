//
//  KCPA_Analytics.swift
//  temp1
//
//  Created by 현은백 on 2023/08/23.
//

import Foundation

protocol KCPA_Datasource: AnyObject {
    func KCPA_GetPlaybackPosition() -> Int
    func KCPA_GetPlaybackBitrate() -> String
}

protocol KCPA_Delegate: AnyObject {
    
    func authentificationInfoDidReceived()
    
    func KCPA(
        apiName: String,
        didReceiveError errCode: Int,
        withMessage strErrMsg: String,
        error: Error?,
        reqParam dicParams: [String: Any]
    )
    
    func analyticsDebug(
        apiName: String,
        statusCode: Int,
        header: [String:Any]
    )
}

class KCP_Analytics {
    
    weak var dataSource: KCPA_Datasource?
    weak var delegate: KCPA_Delegate?
    var debugEnabled: Bool = false
    
    static let shared = KCP_Analytics()
    
    var strAccessSession: String = ""
    var strWatchSession: String = ""
    var strDownloadSession: String?
    
    var dicAuthInfo: [String: Any] = [:]//NSDictionary
    var dicConfiguration: [String: Any] = [:]//NSDictionary
    var dicAccessLogParams: [String: Any] = [:]
    var dicWatchContentInfo: [String: Any] = [:]
    var dicWatchLogParams: [String: Any] = [:]
    var dicDownloadContentInfo: [String: Any] = [:]
    var dicDownloadLogParams: [String: Any] = [:]
    var dicActivityLogParams: [String: Any] = [:]
    
    
    //TODO: enum으로 만들어도 되지 않을까?
    var arrPlayerStatus: [String] = [
        kActionBuffer,
        kActionPlay,
        kActionPause,
        kActionSeek,
        kActionStop,
        kActionExit
    ]
    
    var arrCastType: [String] = [
        kCastNone,
        kCastAirPlay
    ]

    
    private init() {}
    
    //Q. 해당 enum들의 Int값이 필요한가?
    enum KCPA_ServerType: Int {
        case KCPA_PlatformiOS = 0
        case KCPA_PlatformtvOS
    }
    
    enum KCPA_SessionActionType: Int {
        case KCPA_Session_SignIn = 0
        case KCPA_Session_SignOut
        case KCPA_Session_SignExit
    }
    
    enum KCPA_PlayerStatus: Int {
        case KCPA_PlayerBuffer = 0
        case KCPA_PlayerPlay
        case KCPA_PlayerPause
        case KCPA_PlayerSeek
        case KCPA_PlayerStop
        case KCPA_PlayerExit
    }
    
    enum KCPA_CastType: Int {
        case KCPA_CastPlayer = 0
        case KCPA_CastAirPlay
        case KCPA_CastGoogle
    }
    
    
    //🥎
    func request(
        apiType: KCPA_APIType,
        didReceiveError errCode: Int,
        withMessage strErrMsg: String,
        reqParams dicParams: [String: Any]
    ) {
        let dicReqParam = (dicParams["kParam"] as? [String: Any]) ?? [:]
        
        if debugEnabled
        {
            if apiType == .KCPA_API_Activity
            {
                //KCPA_Log(@"[ERR][%ld] Timestamp: %@", (long)apiType, dicReqParam[kTimeStamp]);
            }
            else
            {
                //KCPA_Log(@"[ERR][%ld] %@ : %@", (long)apiType, [dicReqParam objectForKey:kActionType], dicReqParam[kTimeStamp]);
            }
            //KCPA_Log(@"[ERR][%ld] Message: %@", (long)apiType, strErrMsg);
        }
        
        delegate?.KCPA(
            apiName: apiType.name,
            didReceiveError: errCode,
            withMessage: strErrMsg,
            error: nil,
            reqParam: dicReqParam
        )
        
        switch apiType {
        case .KCPA_API_Authenticate:
            ()
            //retryAuthReq
            
        case .KCPA_API_Session_Start,
             .KCPA_API_Session_SignIn:
            ()
            //retrySessionReq(NUM(apiType))
            
        case .KCPA_API_Session_SignOut,
             .KCPA_API_Session_Exit:
            break;
            
        case .KCPA_API_Session_Error,
             .KCPA_API_Watch_Start,
             .KCPA_API_Watch_Error:
            break
            
        case .KCPA_API_Watch_Update:
            if let statusRawVal = dicReqParam[kPlayerStatus] as? Int,
               statusRawVal == KCPA_PlayerStatus.KCPA_PlayerExit.rawValue
            {
                //_startWatchSession = nil
            }
            
        case .KCPA_API_Download_Complete,
             .KCPA_API_Download_Error:
            strDownloadSession = nil
//        case .KCPA_API_Download_Delete:
//            <#code#>
//        case .KCPA_API_Activity:
//            <#code#>
        default:
            ()
        }
    }
    
    
    
}
