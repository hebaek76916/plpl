//
//  KCPA_HttpAPIClientDelegate.swift
//  temp1
//
//  Created by 현은백 on 2023/09/01.
//

import Alamofire
import Foundation

public protocol KCPA_HttpAPIClientDelegate: NSObject {
    
    //MARK: required methods
    
    //TODO: [ ]reqParam to Decodable Struct(json)
    func request(
        apiType: KCPA_APIType,
        didReceiveError errCode: Int,
        withMessage strErrMsg: String?,
        reqParams dicParams: [String: Any]
    )
    
    //Q. statusCode enum으로 안나눠도 되나?..
    func request(
        apiType: KCPA_APIType,
        didReceiveResponse responseObject: [String: Any],//<= class?..
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
    public func networkStatusDidChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus) {}
}
