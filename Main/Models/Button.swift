//
//  ButtonFunctions.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

import Foundation

struct BlogLike {
    let user_id: [String]
    let post_id: String
}

struct BlogDisLike {
    let user_id: [String]
    let post_id: String
}

struct GoodbyeUser {
    let user_id: String
    let post_id: [String]
    let vote_user_id: String
}
