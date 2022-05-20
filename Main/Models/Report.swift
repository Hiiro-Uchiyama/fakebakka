//
//  Report.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/04/18.
//

import Foundation

// A database associated with the reporting function.
// The system should be tied to the user.
struct Report {
    let identifier: String
    let email: String
    let title: String
    let timestamp: String
    let text: String
}
