//
//  ActionTypeValue.swift
//  temp1
//
//  Created by 현은백 on 2023/08/24.
//

import Foundation

// Common Action type
let kActionStart =                            "START"
let kActionExit =                             "EXIT"// session status, player status에서 돌려쓰고 잇슴.

// Session Action type
let kActionSignIn =                           "SIGNIN"
let kActionSignOut =                          "SIGNOUT"

// Player Action type
let kActionPlay =                            "PLAY"//
let kActionPlaying =                         "PLAYING"
let kActionBuffer =                          "BUFFER"//
let kActionBuffering =                       "BUFFERING"//<X 사용하고 있지않음.
let kActionPause =                           "PAUSE"//
let kActionStop =                            "STOP"//
let kActionSeek =                            "SEEK"//
let kActionSeeking =                         "SEEKING"//<X
let kActionDownload =                        "DOWNLOAD"
let kActionDelete =                          "DELETE"//<X
let kActionError =                           "ERROR"
