//
//  KCPA_APIIType.swift
//  temp1
//
//  Created by 현은백 on 2023/09/01.
//

import Foundation

public enum KCPA_APIType: Int {
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
    
    public var name: String {
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
