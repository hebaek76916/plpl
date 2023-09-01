//
//  KCPA_DataSource.swift
//  temp1
//
//  Created by 현은백 on 2023/09/01.
//

import Foundation

public protocol KCPA_Datasource: AnyObject {
    func KCPA_GetPlaybackPosition() -> Int
    func KCPA_GetPlaybackBitrate() -> String
}
