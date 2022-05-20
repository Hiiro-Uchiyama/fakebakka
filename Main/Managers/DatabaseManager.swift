//
//  DatabaseManager.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// There is a slight problem; where created.
// It would be a good idea to create a user information change page and a user password reset page.
// Put your login on with Google.
// Start improving error handling and convenience of forms.
// It might be a good idea to display a message after an information change, for example.
// Add a method for deleting users and sending reports.
// Add a notification function.

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    // DATABASEMANAGER
    static let shared = DatabaseManager()
    // FIREBASE SETUP
    private let database = Firestore.firestore()
    // INIT METHODS
    private init() {}
    // POSTS FUNCTIONS
    public func insert(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "id": blogPost.identifier,
            "email": blogPost.email,
            "title": blogPost.title,
            "body": blogPost.text,
            "created": blogPost.timestamp,
            "headerImageUrl": blogPost.headerImageUrl?.absoluteString ?? "",
            "author": blogPost.author,
            "author_description": blogPost.author_description,
            "publisher": blogPost.publisher,
            "publisher_description": blogPost.publisher_description,
            "watch_count": 0,
            "like_count": 0,
            "dislike_count": 0,
            "comment_count": 0
        ]
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogPost.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    // REPORTS FUNCTION
    public func insert(
        Report: Report,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "id": Report.identifier,
            "email": Report.email,
            "title": Report.title,
            "text": Report.text,
            "timestamp": Report.timestamp
        ]
        database
            .collection("reports")
            .document(userEmail)
            .collection("report")
            .document(Report.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    // Functions to like
    // Vary the number of likes on the post itself.
    // To be honest, it may or may not be necessary.
    // It looks like it's finally done.
    public func insertBlogLike(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "user_id": email,
            "post_id": blogPost.identifier,
        ]
        database.collection("users").document(userEmail).collection("like").document(blogPost.identifier).getDocument { ( snap, error ) in
            if snap!["post_id"] == nil {
                print("ドキュメントが存在しなかったので、GoodFakeを追加しました")
                self.database
                    .collection("users")
                    .document(userEmail)
                    .collection("like")
                    .document(blogPost.identifier)
                    .setData(data) { error in
                        completion(error == nil)
                    }
                // Seems like you can't turn off the likes.
                // It's better to use a normal button.
                DatabaseManager.shared.increaseBlogLike(
                    blogPost: blogPost,
                    email: blogPost.email,
                    completion: { (error) in return })
            }
            else {
                print("ドキュメントは存在したので、GoodFakeを削除した")
                self.database
                    .collection("users")
                    .document(userEmail)
                    .collection("like")
                    .document(blogPost.identifier)
                    .delete() { error in
                        completion(error == nil)
                    }
                // Seems like you can't turn off the likes.
                // It's better to use a normal button.
                DatabaseManager.shared.decreaseBlogLike(
                    blogPost: blogPost,
                    email: blogPost.email,
                    completion: { (error) in return })
            }
        }
    }
    // increase
    public func increaseBlogLike(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "like_count": blogPost.like_count+1,
        ]
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogPost.identifier)
            .updateData(data) { error in
                completion(error == nil)
            }
    }
    // decrease
    public func decreaseBlogLike (
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
    let userEmail = email
        .replacingOccurrences(of: ".", with: "_")
        .replacingOccurrences(of: "@", with: "_")
    let data: [String: Any] = [
        "like_count": blogPost.like_count-1,
    ]
    database
        .collection("users")
        .document(userEmail)
        .collection("posts")
        .document(blogPost.identifier)
        .updateData(data) { error in
            completion(error == nil)
        }
    }
    // Functions to like
    // Vary the number of likes on the post itself.
    // To be honest, it may or may not be necessary.
    // It looks like it's finally done.
    public func insertBlogDisLike(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "user_id": email,
            "post_id": blogPost.identifier,
        ]
        database.collection("users").document(userEmail).collection("dislike").document(blogPost.identifier).getDocument { ( snap, error ) in
            if snap!["post_id"] == nil {
                print("ドキュメントが存在しなかったので、BadFakeを追加しました")
                self.database
                    .collection("users")
                    .document(userEmail)
                    .collection("dislike")
                    .document(blogPost.identifier)
                    .setData(data) { error in
                        completion(error == nil)
                    }
                // Seems like you can't turn off the likes.
                // It's better to use a normal button.
                DatabaseManager.shared.increaseBlogDisLike(
                    blogPost: blogPost,
                    email: blogPost.email,
                    completion: { (error) in return })
            }
            else {
                print("ドキュメントは存在したので、BadFakeを削除した")
                self.database
                    .collection("users")
                    .document(userEmail)
                    .collection("dislike")
                    .document(blogPost.identifier)
                    .delete() { error in
                        completion(error == nil)
                    }
                // Seems like you can't turn off the likes.
                // It's better to use a normal button.
                DatabaseManager.shared.decreaseBlogDisLike(
                    blogPost: blogPost,
                    email: blogPost.email,
                    completion: { (error) in return })
            }
        }
    }
    // increase
    public func increaseBlogDisLike(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "dislike_count": blogPost.dislike_count+1,
        ]
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogPost.identifier)
            .updateData(data) { error in
                completion(error == nil)
            }
    }
    // decrease
    public func decreaseBlogDisLike (
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ){
    let userEmail = email
        .replacingOccurrences(of: ".", with: "_")
        .replacingOccurrences(of: "@", with: "_")
    let data: [String: Any] = [
        "dislike_count": blogPost.dislike_count-1,
    ]
    database
        .collection("users")
        .document(userEmail)
        .collection("posts")
        .document(blogPost.identifier)
        .updateData(data) { error in
            completion(error == nil)
        }
    }
    // getAllPost
    public func getAllPosts(
        completion: @escaping ([BlogPost]) -> Void
    ){
        database
            .collection("users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                let emails: [String] = documents.compactMap({ $0["email"] as? String })
                print(emails)
                guard !emails.isEmpty else {
                    completion([])
                    return
                }
                let group = DispatchGroup()
                var result: [BlogPost] = []
                for email in emails {
                    group.enter()
                    self?.getPosts(for: email) { userPosts in
                        defer {
                            group.leave()
                        }
                        result.append(contentsOf: userPosts)
                    }
                }
                group.notify(queue: .global()) {
                    print("Feed posts: \(result.count)")
                    completion(result)
                }
            }
    }
    // getPosts
    public func getPosts(
        for email: String,
        completion: @escaping ([BlogPost]) -> Void
    ){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                let posts: [BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let email = dictionary["email"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? String,
                          let imageUrlString = dictionary["headerImageUrl"] as? String,
                          let author = dictionary["author"] as? String,
                          let author_description = dictionary["author_description"] as? String,
                          let publisher = dictionary["publisher"] as? String,
                          let publisher_description = dictionary["publisher_description"] as? String,
                          let watch_count = dictionary["watch_count"] as? Int,
                          let like_count = dictionary["like_count"] as? Int,
                          let dislike_count = dictionary["dislike_count"] as? Int,
                          let comment_count = dictionary["comment_count"] as? Int
                    else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    let post = BlogPost(
                        identifier: id,
                        email: email,
                        title: title,
                        timestamp: created,
                        headerImageUrl: URL(string: imageUrlString),
                        text: body,
                        author: author,
                        author_description: author_description,
                        publisher: publisher,
                        publisher_description: publisher_description,
                        watch_count: watch_count,
                        like_count: like_count,
                        dislike_count: dislike_count,
                        comment_count: comment_count
                    )
                    return post
                })
                completion(posts)
            }
    }
    // USERS FUNCTION
    // insertUser
    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void
    ){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data = [
            "email": user.email,
            "name": user.name
        ]
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    // getUser
    public func getUser(
        email: String,
        completion: @escaping (User?) -> Void
    ){
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      let description = data["description"],
                      let author_name = data["author_name"],
                      let web_link = data["web_link"],
                      let twitter_link = data["twitter_link"],
                      error == nil else {
                    return
                }
                let ref = data["profile_photo"]
                let user = User(name: name, email: email, profilePictureRef: ref, description: description, author_name: author_name, web_link: web_link, twitter_link: twitter_link)
                completion(user)
            }
    }
    // updateProfilePhoto
    func updateProfilePhoto(
        email: String,
        completion: @escaping (Bool) -> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        let photoReference = "profile_pictures/\(path)/photo.png"
        let dbRef = database
            .collection("users")
            .document(path)
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profile_photo"] = photoReference
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
    // updateUserInformation
    func upadateUserInformation(
        email: String,
        author_name: String?,
        description: String?,
        web_link: String?,
        twitter_link: String?,
        completion: @escaping (Bool) -> Void
    ){
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        let dbRef = database
            .collection("users")
            .document(path)
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["author_name"] = author_name
            data["description"] = description
            data["web_link"] = web_link
            data["twitter_link"] = twitter_link
            dbRef.setData(data) { error in
                print("Error code: 0")
            }
        }
    }
}
