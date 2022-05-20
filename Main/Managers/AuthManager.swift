//
//  AuthManager.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

// The withdrawal process refers to the logout process.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    // DATABASEMANAGER
    static let shared = AuthManager()
    // FIREBASE SETUP
    private let auth = Auth.auth()
    // INIT METHODS
    private init() {}
    // isSignedIn
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    // signUp
    public func signUp(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    // signIn
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    // signOut
    public func signOut(
        completion: (Bool) -> Void
    ){
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
    // We want to determine whether it is really Email.
    public func passwordResetting(
        email: String
    ){
        auth.languageCode = "ja_JP"
        auth.sendPasswordReset(withEmail: email) { err in
            if let err = err {
                print("再設定メールの送信に失敗しました。\(err)")
                return
            }
            print("再設定メールの送信に成功しました。")
        }
    }
    // delUser
    public func dellUser(
        completion: @escaping (Bool) -> Void
    ){
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil {
            // An error happened.
            print("削除に失敗しました。")
          } else {
            // Account deleted.
            print("削除に成功しました。")
          }
        }
    }
}
