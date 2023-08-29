//
//  KCPA_HttpAPIClient.swift
//  temp1
//
//  Created by 현은백 on 2023/08/22.
//

import Foundation
import Alamofire//TODO: Specification
import CFNetwork

enum KCPA_APIType: Int {
    case KCPA_API_Authenticate = 0
    case KCPA_API_Session_Start
    case KCPA_API_Session_SignIn
    case KCPA_API_Session_SignOut
    case KCPA_API_Session_Exit
    case KCPA_API_Session_Error
    case KCPA_API_Watch_Start
    case KCPA_API_Watch_Update
    case KCPA_API_Watch_Error
    case KCPA_API_Download_Complete
    case KCPA_API_Download_Delete
    case KCPA_API_Download_Error
    case KCPA_API_Activity
    
    var name: String {
        switch self {
        case .KCPA_API_Authenticate:            return "KCPA_API_Authenticate"
        case .KCPA_API_Session_Start:           return "KCPA_API_Session_Start"
        case .KCPA_API_Session_SignIn:          return "KCPA_API_Session_SignIn"
        case .KCPA_API_Session_SignOut:         return "KCPA_API_Session_SignOut"
        case .KCPA_API_Session_Exit:            return "KCPA_API_Session_Exit"
        case .KCPA_API_Session_Error:           return "KCPA_API_Session_Error"
        case .KCPA_API_Watch_Start:             return "KCPA_API_Watch_Start"
        case .KCPA_API_Watch_Update:            return "KCPA_API_Watch_Update"
        case .KCPA_API_Watch_Error:             return "KCPA_API_Watch_Error"
        case .KCPA_API_Download_Complete:       return "KCPA_API_Download_Complete"
        case .KCPA_API_Download_Delete:         return "KCPA_API_Download_Delete"
        case .KCPA_API_Download_Error:          return "KCPA_API_Download_Error"
//        case .KCPA_API_Activity:                return "KCPA_API_Activity"<= 이거 없음
        default:                                return ""
        }
    }
}

protocol KCPA_HttpAPIClientDelegate: NSObject {
    
    //MARK: required methods
    
    //TODO: [ ]reqParam to Decodable Struct(json)
    //- (void)request:(KCPA_APIType)apiType didReceiveResponse:(nullable id)responseObject reqParams:(NSDictionary *)dicParams;
    func request(
        apiType: KCPA_APIType,
        didReceiveError errCode: Int,
        withMessage strErrMsg: String?,
        reqParams dicParams: [String: Any]
    )
    
    //Q. statusCode enum으로 안나눠도 되나?..
    func request(
        apiType: KCPA_APIType,
        didReceiveResponse responseObject: [String: Any],//<= struct?
        withMessage strErrMsg: String?,
        reqParams: [String: Any]
    )
    
    //MARK: optional methods
    func networkStatusDidChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus)
    
    func analyticsDebug(
        apiType: KCPA_APIType,
        statusCode: Int,
        header dicHeader: [String: Any]
    )
}

extension KCPA_HttpAPIClientDelegate {
    func networkStatusDidChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus) {}
}

class KCPA_HttpAPIClient {
    
    weak var delegate: KCPA_HttpAPIClientDelegate?
    var showDebugLog: Bool = false
    private var interceptor = Interceptor()
    
    //TODO: init(with. delegate)
    init() {
        //TODO: Delegate 설정 해줘야함.
        //delegate = self
        
    }
    
    func setLogEnabled() {
        showDebugLog = true
        //setRetryPolicyLogMessagesEnabled(AFNetworking)
    }
    
    func sendPostRequest(
        apiType: KCPA_APIType,
        requestURL: String,//Q. URL로 해야할까?
        params: [String: Any]//Q. 구조체(or protocol type)으로 넘기고 함수 내부에서 dictionary화 해줄까?
    ) {
        
        guard !params.isEmpty else {
            //KCPA_Log(@"[ERROR] Exception occurred in %s", __PRETTY_FUNCTION__);
            //KCPA_Log(@"[ERROR] Exception name: %@", [exception name]);
            //KCPA_Log(@"[ERROR] Exception resson: %@", [exception reason]);
            return
        }
        
        let showDebug = showDebugLog
        
        if showDebug {
            KCPA_Log("[HTTPClient] ====================================> Send Request (%@)", "_delegate")//TODO: delegate
            KCPA_Log("[HTTPClient] API Type: %ld", apiType.rawValue)
            KCPA_Log("[HTTPClient] Request URL: %@", requestURL)
            KCPA_Log("[HTTPClient] Params: %@", params)
        }

        guard let url = URL(string: requestURL) else { return }
        
        let dicLogData: [String: Any] = [
            "kRequestURL": requestURL,
            "kParam": params
        ]
        
        AF
            .request(
                url,
                method: .post,
                parameters: params,
                //Q. encoding
                headers: nil,
                interceptor: self.interceptor
                //Q. interceptor
            )
            .response { res in
                guard nil == res.error else { return }
                switch res.result {
                case .success(let data):
                    if showDebug {
                        KCPA_Log("[HTTPClient] <==================================== Receive response (%@)", "self.delegate")//TODO: self.delegate 출력.
                        KCPA_Log("[HTTPClient] Response: %@", res.response ?? "")
                    }
                    
                    guard let data else {
                        self.request(
                            apiType: apiType,
                            didReceiveError: ERR_RESULT_DOES_NOT_EXIST,
                            message: "",
                            withException: nil,
                            withData: dicLogData
                        )
                        return
                    }
                    
                    //TODO: struct tight하게 설정? <= 이게 유동적이지 않나? dictionary로 받으나 struct로 구조체 만드나, 동장에 필요한 값이면 둘 다 수정해야함. -> 그럼 struct로 만드는게 나을수도!
                    let dictionary: [String: Any]?
                    do {
                        dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        guard let dictionary else {
                            self.request(
                                apiType: apiType,
                                didReceiveError: ERR_UNKNOWN_RESULT,
                                message: nil,
                                withException: nil,
                                withData: dicLogData
                            )
                            return
                        }
                    } catch {
                        if let statusCode = res.response?.statusCode {
                            let header = res.response?.headers
                            self.delegate?
                                .analyticsDebug(
                                    apiType: apiType,
                                    statusCode: statusCode,
                                    header: [:]//TODO: headers to dict
                                )
                        }
                        
                        self.request(
                            apiType: apiType,
                            didReceiveError: ERR_SEND_FAILURE,
                            message: nil,
                            withException: error,
                            withData: dicLogData
                        )
                        return
                    }
                    
                    guard let dictionary else { return }

                    if let result = dictionary[kResult] as? String
                    {
                        if kFailure == result
                        {
                            let strErrMsg = dictionary[kMessage] as? String
                            self.request(
                                apiType: apiType,
                                didReceiveError: ERR_RESPONSE,
                                message: strErrMsg,
                                withException: nil,
                                withData: dicLogData
                            )
                        }
                        else
                        {//SUCCESS
                            self.delegate?
                                .request(
                                    apiType: apiType,
                                    didReceiveResponse: dictionary,
                                    withMessage: nil,
                                    reqParams: dicLogData
                                )
                        }
                    }
                    else {
                        self.request(
                            apiType: apiType,
                            didReceiveError: ERR_UNKNOWN_RESULT,
                            message: nil,
                            withException: nil,
                            withData: dicLogData
                        )
                    }
                    
                case .failure(let error):
                    let errorCode = error.responseCode
                    let temp = CFNetworkErrors.self
                    
                    switch errorCode {
                    case Int(temp.cfurlErrorCancelled.rawValue):
                        break
                        
                    case Int(temp.cfurlErrorTimedOut.rawValue),
                         Int(temp.cfurlErrorNetworkConnectionLost.rawValue),
                         Int(temp.cfurlErrorNotConnectedToInternet.rawValue):
                        self.request(
                            apiType: apiType,
                            didReceiveError: errorCode!,
                            message: nil,
                            withException: error,
                            withData: dicLogData
                        )
                        
                    default:
//                       AS WAS : analyticsDebug 선언되어있다면(selector 여부로 판단.) delegate analytics 호출.
//                       TO BE : validator 이용해서, 해당 error case 라면 (status code 판별해야하는것이기 때문에 일단 success일것임.(Http 통신은 성공한것이지만, 원하는 success 결과가 아닌것임.))
//                       delegate의 analyticsDebug 호출하도록 함.
                        self.request(
                            apiType: apiType,
                            didReceiveError: ERR_SEND_FAILURE,
                            message: nil,
                            withException: error,
                            withData: dicLogData
                        )
                    }
                }

            }
    }
    
    //🎲
    func request(
        apiType: KCPA_APIType,
        didReceiveError errCode: Int,
        message: String?,
        withException error: Error?,
        withData dicLogData: [String: Any]
    ) {

        let errors = CFNetworkErrors.self
        
        var strErrMsg: String? = {
            switch errCode {
            case Int(errors.cfurlErrorTimedOut.rawValue):
                return "Request timed out"
                
            case Int(errors.cfurlErrorNetworkConnectionLost.rawValue):
                return "Network connection lost"
                
            case Int(errors.cfurlErrorNotConnectedToInternet.rawValue):
                return "Not connected to internet"
                
            case ERR_RESULT_DOES_NOT_EXIST:
                return "Response data does not exists"
                
            case ERR_UNKNOWN_RESULT:
                return "Invalid response data"
                
            case ERR_UNKNOWN_EXCEPTION:
                guard let error else { return nil }
                return String(format: "An unknown exception has occurred [%@]", error.localizedDescription)
                
                
            case ERR_SEND_FAILURE:
                guard let error else { return nil }
                return String(format: "Failed to send request [%@]", error.localizedDescription)
            
            default:
                guard let message else {
                    return "An unknown error has occurred"
                }
                return message
            }
        }()
        
        
        delegate?
            .request(
                apiType: apiType,
                didReceiveError: errCode,
                withMessage: strErrMsg,
                reqParams: dicLogData
            )
    }
    
    
}

