//
//  BlogPost.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import Foundation

// Additional features such as user ties and categories
// In the meantime, data will be added.
// Insert the email address of the other party
struct BlogPost {
    let identifier: String
    let email: String
    let title: String
    let timestamp: String
    let headerImageUrl: URL?
    let text: String
    // Newly added.
    // Create a fictional author.
    let author: String
    let author_description: String
    let publisher: String
    let publisher_description: String
    // Counting as data.
    let watch_count: Int
    let like_count: Int
    let dislike_count: Int
    let comment_count: Int
    // Set up user information.
    // let user: User
    // It would be good to be able to add images.
}
