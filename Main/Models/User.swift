//
//  User.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import Foundation

// Let's add a little more information about the user.
// You could add something like a settings page.

struct User {
    let name: String
    let email: String
    let profilePictureRef: String?
    // Additional information.
    let description: String?
    let author_name: String?
    let web_link: String?
    let twitter_link: String?
}
