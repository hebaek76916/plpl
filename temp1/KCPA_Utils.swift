//
//  KCPA_Utils.swift
//  
//
//  Created by 현은백 on 2023/08/29.
//

import Foundation
//import UIKit

public class KCPA_Utils: NSObject {

    func generateUUID() -> String {
        let a = UUID()
        return a.uuidString.lowercased()//lower case가 필요한가?

    }
    
//    func getDeviceUUID() -> String? {
//        //key chain?..
//        return UIDevice.current.identiferForVendor?.uuidString
//    }
}
