//
//  Utility.swift
//  temp1
//
//  Created by 현은백 on 2023/08/23.
//

import Foundation

//Q. 이것도 header, member만들어야하나?
func KCPA_Log(_ format: String, _ args: CVarArg...) {
    let formattedString = "[KCPA] " + String(format: format, arguments: args)
    print(formattedString)
}



