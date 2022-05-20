//
//  BlogComment.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/22.
//

import Foundation

struct BlogComment {
    let id: String
    let title: String
    let text: String
    let user: User
    let post: BlogPost
    let timestamp: String
}

struct BlogReComment {
    let id: String
    let title: String
    let text: String
    let user: User
    let re_user: User
    let post: BlogPost
    let timestamp: String
}
