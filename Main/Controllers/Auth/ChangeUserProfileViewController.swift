//
//  ChangeUserProfileViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import UIKit

struct AuthUserInformationUpdateView: View {
    @State private var email = ""
    @State private var author_name = ""
    @State private var description = ""
    @State private var web_link = ""
    @State private var twitter_link = ""
    @State private var isShowUserInformationUpdateAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            VStack {
                Text("編集者名").font(.system(size: 13.5))
                TextField("例) フェイク・バッカ", text: $author_name).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Text("紹介文").font(.system(size: 13.5))
                if #available(iOS 14.0, *) {
                    TextEditor(text: $description)
                        .lineSpacing(10)
                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.1))
                        .cornerRadius(10)
                        .frame(height: 200, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                        )
                } else {
                    // Fallback on earlier versions
                }
                Text("Webサイト").font(.system(size: 13.5))
                TextField("例) https://fakebakka.com", text: $web_link).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Text("Twitter").font(.system(size: 13.5))
                TextField("例) https;//twitter.com/fakebakka/", text: $twitter_link).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Button(action: {
                    if self.author_name.isEmpty && self.description.isEmpty && self.web_link.isEmpty && self.twitter_link.isEmpty {
                        self.isShowUserInformationUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "偽名、紹介文、Webサイトリンク、Twitterリンクのいずれかを入力して下さい"
                    } else {
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let currentEmail = user.email
                            DatabaseManager.shared.upadateUserInformation(
                                email: currentEmail!,
                                author_name: self.author_name,
                                description: self.description,
                                web_link: self.web_link,
                                twitter_link: self.twitter_link,
                                completion: { (error) in
                                    if let error = error as! NSError? {
                                        switch AuthErrorCode(rawValue: error.code) {
                                        case .invalidRecipientEmail:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Indicates an invalid recipient email was sent in the request."
                                            // Error: Indicates an invalid recipient email was sent in the request.
                                            print("Indicates an invalid recipient email was sent in the request.")
                                        case .invalidSender:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Indicates an invalid sender email is set in the console for this action."
                                            // Error: Indicates an invalid sender email is set in the console for this action.
                                            print("Indicates an invalid sender email is set in the console for this action.")
                                        case .invalidMessagePayload:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Indicates an invalid email template for sending update email."
                                            // Error: Indicates an invalid email template for sending update email.
                                            print("Indicates an invalid email template for sending update email.")
                                        case .emailAlreadyInUse:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Email has been already used by another user."
                                            // Error: The email address is already in use by another account.
                                            print("Email has been already used by another user.")
                                        case .invalidEmail:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Email is not well formatted"
                                            // Error: The email address is badly formatted.
                                            print("Email is not well formatted")
                                        case .requiresRecentLogin:
                                            self.isShowUserInformationUpdateAlert = true
                                            self.isError = true
                                            self.errorMessage = "Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser."
                                            // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                                            print("Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.")
                                        default:
                                            print("Error message: \(error.localizedDescription)")
                                        }
                                    } else {
                                        self.isShowUserInformationUpdateAlert = true
                                        self.isError = false
                                        print("Update email is successful")
                                    }
                                })
                        }
                    }
                }
                ) {
                    Text("更新")
                }
                .alert(isPresented: $isShowUserInformationUpdateAlert) {
                    if self.isError {
                        return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("プロフィール情報を更新しました"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            Spacer().frame(width: 50)
        }
    }
}
