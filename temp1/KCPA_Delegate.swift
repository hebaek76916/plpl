//
//  KCPA_Delegate.swift
//  temp1
//
//  Created by 현은백 on 2023/09/01.
//

import Foundation

public protocol KCPA_Delegate: AnyObject {
    
    func authentificationInfoDidReceived()
    
    func KCPA(
        apiName: String,
        didReceiveError errCode: Int,
        withMessage strErrMsg: String?,
        error: Error?,
        reqParam dicParams: [String: Any]
    )
    
    func analyticsDebug(
        apiName: String,
        statusCode: Int,
        header: [String:Any]
    )
}
