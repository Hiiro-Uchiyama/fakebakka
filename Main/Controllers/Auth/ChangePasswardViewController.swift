//
//  ChangePasswardViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

import Foundation

import SwiftUI
import FirebaseAuth

struct AuthEmailPasswordUpdateView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var isShowEmailUpdateAlert = false
    @State private var isShowPasswordUpdateAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            VStack {
                Text("新しいメールアドレス").font(.system(size: 13.5))
                TextField("mail@example.com", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Button(action: {
                    if self.email.isEmpty {
                        self.isShowEmailUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "メールアドレスが入力されていません"
                    } else {
                        Auth.auth().currentUser?.updateEmail(to: self.email, completion: { (error) in
                            if let error = error as NSError? {
                            switch AuthErrorCode(rawValue: error.code) {
                            case .invalidRecipientEmail:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Indicates an invalid recipient email was sent in the request."
                              // Error: Indicates an invalid recipient email was sent in the request.
                              print("Indicates an invalid recipient email was sent in the request.")
                            case .invalidSender:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Indicates an invalid sender email is set in the console for this action."
                              // Error: Indicates an invalid sender email is set in the console for this action.
                              print("Indicates an invalid sender email is set in the console for this action.")
                            case .invalidMessagePayload:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Indicates an invalid email template for sending update email."
                              // Error: Indicates an invalid email template for sending update email.
                              print("Indicates an invalid email template for sending update email.")
                            case .emailAlreadyInUse:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Email has been already used by another user."
                              // Error: The email address is already in use by another account.
                              print("Email has been already used by another user.")
                            case .invalidEmail:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Email is not well formatted"
                              // Error: The email address is badly formatted.
                              print("Email is not well formatted")
                            case .requiresRecentLogin:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser."
                              // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                              print("Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.")
                            default:
                              print("Error message: \(error.localizedDescription)")
                            }
                          } else {
                            self.isShowPasswordUpdateAlert = true
                            self.isError = false
                            print("Update email is successful")
                          }
                        })
                    }
                }) {
                    Text("メールアドレス変更")
                }
                .alert(isPresented: $isShowEmailUpdateAlert) {
                    if self.isError {
                        return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("メールアドレスが更新されました"), dismissButton: .default(Text("OK")))
                    }
                }
                Spacer().frame(height: 25)
                Text("新しいパスワード").font(.system(size: 13.5))
                SecureField("半角英数字", text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Text("パスワード確認").font(.system(size: 13.5))
                SecureField("半角英数字", text: $confirm).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                )
                Button(action: {
                    if self.password.isEmpty {
                        self.isShowPasswordUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "パスワードが入力されていません"
                    } else if self.confirm.isEmpty {
                        self.isShowPasswordUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "確認パスワードが入力されていません"
                    } else if self.password.compare(self.confirm) != .orderedSame {
                        self.isShowPasswordUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "パスワードと確認パスワードが一致しません"
                    } else {
                        Auth.auth().currentUser?.updatePassword(to: self.password, completion: { (error) in
                            if let error = error as NSError? {
                            switch AuthErrorCode(rawValue: error.code) {
                            case .userDisabled:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "The user account has been disabled by an administrator."
                              // Error: The user account has been disabled by an administrator.
                              print("Error: The user account has been disabled by an administrator.")
                            case .weakPassword:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "The password must be 6 characters long or more"
                              // Error: The password must be 6 characters long or more.
                              print("Error: The password must be 6 characters long or more.")
                            case .operationNotAllowed:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section"
                              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                              print("Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                            case .requiresRecentLogin:
                                self.isShowEmailUpdateAlert = true
                                self.isError = true
                                self.errorMessage = "Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser."
                              // Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.
                              print("Error: Updating a user’s password is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser.")
                            default:
                              print("Error message: \(error.localizedDescription)")
                            }
                          } else {
                            self.isShowPasswordUpdateAlert = true
                            self.isError = false
                            print("User signs up successfully")
                          }
                        })
                    }
                }) {
                    Text("パスワード変更")
                }
                .alert(isPresented: $isShowPasswordUpdateAlert) {
                    if self.isError {
                        return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("パスワードが更新されました"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            Spacer().frame(width: 50)
        }
    }
}
