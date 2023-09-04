//
//  KCPA_Analytics.swift
//  temp1
//
//  Created by 현은백 on 2023/08/23.
//

import Alamofire
import Foundation

public class KCP_Analytics {
    
    weak var dataSource: KCPA_Datasource?
    weak var delegate: KCPA_Delegate?
    
    static let shared = KCP_Analytics()
    
    var platform = KCPA_AplePlatform.KCPA_PlatformiOS
    var client = KCPA_HttpAPIClient()
    
    //Session IDs
    var strAccessSession: String?
    var strWatchSession: String?
    var strDownloadSession: String?
    
    var dicAuthInfo: [String: Any] = [:]//NSDictionary
    var dicConfiguration: [String: Any] = [:]//NSDictionary
    var dicAccessLogParams: [String: Any] = [:]
    var dicWatchContentInfo: [String: Any] = [:]
    var dicWatchLogParams: [String: Any] = [:]
    var dicDownloadContentInfo: [String: Any] = [:]
    var dicDownloadLogParams: [String: Any] = [:]
    var dicActivityLogParams: [String: Any] = [:]
    
//    var arrPlayerStatus: [Any] = []//TODO: type 알아내야함
//    var arrCastType: [Any] = []//TODO: type 알아내야함
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
    var prevWatchLogAPIType: Int = -1
    var prevWatchLogAction: String = ""
    var prevPlayerStatus: Int = -1
    var dicSessionRetryCount: [String: Any] = [:]//TODO: 무얼 저장하는지 알아내야함
    var nReqAuthRetryCount: Int = -1
    var nContentDuration: Int = -1
    
    var timerUpdate = Timer()
    
    var debugEnabled = false
    var showNetworkLog = false
    var sessionErrorReported = false
    
    private init() {}
    
    //Q. 해당 enum들의 Int값이 필요한가?
    public enum KCPA_ServerType: Int {
        case KCPA_PlatformiOS = 0
        case KCPA_PlatformtvOS
    }
    
    public enum KCPA_SessionActionType: Int {
        case KCPA_Session_SignIn = 0
        case KCPA_Session_SignOut
        case KCPA_Session_SignExit
    }
    
    public enum KCPA_PlayerStatus: Int {
        case KCPA_PlayerBuffer = 0
        case KCPA_PlayerPlay
        case KCPA_PlayerPause
        case KCPA_PlayerSeek
        case KCPA_PlayerStop
        case KCPA_PlayerExit
    }
    
    public enum KCPA_CastType: Int {
        case KCPA_CastPlayer = 0
        case KCPA_CastAirPlay
        case KCPA_CastGoogle
    }
    
    public enum KCPA_AplePlatform: Int {
        case KCPA_PlatformiOS = 0
        case KCPA_PlatformtvOS
    }
    
    //🥎
    public func request(
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
            ()
//            strDownloadSession = nil
//        case .KCPA_API_Download_Delete:
//            <#code#>
//        case .KCPA_API_Activity:
//            <#code#>
        default:
            ()
        }
    }
    
    func errorReport(
        funcName: String,
        errCode: Int,
        errMsg strErrMsg: String?
    ) {
        delegate?
            .KCPA(
                apiName: funcName,
                didReceiveError: errCode,
                withMessage: strErrMsg,
                error: nil,
                reqParam: [:]
            )
    }
    
    
    
}

//🤡
//MARK: Watch log methods
extension KCP_Analytics {
    
    func getWatchLogInfo() -> [String: Any]{
        let strWatchLogReqURL = dicConfiguration[kWatchLogURL]
        let strReqMethod = dicConfiguration[kRequestMethod]
        let nCheckInterval = dicConfiguration[kCheckInterval]
        let strAuthToken = dicConfiguration[kAuthToken]
        
        return [
            kWatchLogURL: strWatchLogReqURL ?? "",
            kRequestMethod: strReqMethod ?? "",
            kCheckInterval: nCheckInterval ?? 30,
            kAuthToken: strAuthToken ?? "",
            kAccessSession: strAccessSession,
            kWatchSession: strWatchSession
        ] as [String: Any]
    }
}

extension KCP_Analytics {
    
    func checkNSStringParam(
        strParam: String?,
        withName strName: String
    ) -> Bool {
        
        var validate = false
        
        guard let strParam else {
            if debugEnabled {
                //KCPA_Log(@"[ERR] \"%@\" parameter does not allowed nil.", strName);
            }
            return false
        }

        if strParam.isEmpty
        {
            if strName == kPNUserType
            {
                if debugEnabled
                {
                    //KCPA_Log(@"[ERR] \"%@\" parameter does not allowed empty string.", strName);
                }
                return false
            }
            else
            {
                if debugEnabled
                {
                    //KCPA_Log(@"[WARNING] \"%@\" parameter is empty string.", strName);
                }
                return true
            }
        }
        else
        {
            return true
        }
    }
    
    func checkAuthSessionIsInitialized() -> Bool {
        if dicConfiguration.isEmpty
        {
            return true
        }
        else
        {
            //KCPA_Log(@"[ERR] KCP Analytics SDK already initialized");
            return false
        }
    }
    
    func checkAccessSessionIsStarted() -> Bool {
        let isWatchSession = strWatchSession != nil
        let isAccessLogParams = !(dicAccessLogParams.isEmpty)
        let isStart = kActionStart == (dicAccessLogParams[kActionType] as? String)
        let isSignIn = kActionSignIn == (dicAccessLogParams[kActionType] as? String)
        
        let isAlreadyExistAccessSession = isWatchSession && isAccessLogParams && (isStart || isSignIn)
        
        if isAlreadyExistAccessSession
        {
            //KCPA_Log(@"[ERR] Access session already exists. Please reset the access session by calling the KCPA_UpdateSession [KCPA_Session_SignOut, KCPA_Session_Exit].");
            //KCPA_Log(@"[ERR] Access session : %@", _strAccessSession);
            return false
        }
        else
        {
            return true
        }
    }
    
    func checkWatchContentInfo(
        strFuncName: String
    ) -> Bool {
        
        var result = true
        var strErrMsg: String?
        
        if dicWatchContentInfo.isEmpty
        {
            strErrMsg = "[ERR] Watch content information does not exist. Please set the watch content info by calling the KCPA_SetWatchContent."
            result = false
        }
        else
        {
            var isAssetID: Bool = {
                guard let assetID = dicWatchContentInfo[kAssetID] as? String else { return false }
                return !assetID.isEmpty
            }()

            var isEpisodeName: Bool = {
                guard let episodeName = dicWatchContentInfo[kEpisodeName] as? String else { return false }
                return !episodeName.isEmpty
            }()
            
            if !isAssetID || !isEpisodeName
            {
                strErrMsg = String(format:  "[ERR] The watch content information has an invalid required parameter. [%@ or %@]", kAssetID, kEpisodeName)
                result = false
            }
            
            
            var isUserType: Bool = {
                guard let userType = dicWatchContentInfo[kUserType] as? String else { return false }
                return !userType.isEmpty
            }()
            
            if !isUserType
            {
                strErrMsg = String(format: "[ERR] The watch content information has an invalid required parameter. [%@]", kUserType)
                result = false
            }
        }
        
        if false == result
        {
            errorReport(
                funcName: strFuncName,
                errCode: 50000,
                errMsg: strErrMsg
            )
        }
        
        return result
    }
}


public extension KCP_Analytics {
    
    func KCPA_InitSDK(
        serverType: KCPA_ServerType,
        platformType: KCPA_AplePlatform,
        userID: String,
        userPassword: String,
        serviceName: String,
        logEnabled: Bool
    ) {
        
        self.debugEnabled = logEnabled
        
        let a = checkAuthSessionIsInitialized()
        let b = checkNSStringParam(strParam: userID, withName: kPNServiceID)
        let c = checkNSStringParam(strParam: userPassword, withName: kPNServicePassword)
        let d = checkNSStringParam(strParam: serviceName, withName: kPNServiceName)
        
        do {
            nReqAuthRetryCount = 0
            platform = platformType
            
            var strVersion = SDK_VERSION
            
            dicAuthInfo
        }
        catch {
            
        }
    }
    
}
