//
//  DellUserViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

// After the withdrawal process, skip to the sign-up screen.
// User Acquisition

import Foundation

import SwiftUI
import FirebaseAuth

struct AuthDellUserView: View {
    @State private var dellText = ""
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
                Text("退会処理").padding()
                Text("Fakebakkaのご利用は、お使いのアカウントではできなくなります。退会処理後、アカウント情報、及びフェイクニュースは削除されます。").padding().font(.system(size: 13.5))
                Text("上記内容について、問題が無ければ、下のフォームに「アカウント削除」とご入力後、退会するボタンを押して下さい。").padding().font(.system(size: 13.5))
                TextField("アカウント削除", text: $dellText).textFieldStyle(RoundedBorderTextFieldStyle()).overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), lineWidth: 1)
                ).padding()
                Button(action: {
                    if self.dellText.isEmpty {
                        self.isShowEmailUpdateAlert = true
                        self.isError = true
                        self.errorMessage = "「アカウント削除」が入力されていません"
                    } else {
                        print("処理は進行してますか?")
                        AuthManager.shared.dellUser(completion: { (error) in
                            if let error = error as! NSError? {
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
                    Text("退会する")
                }
                .alert(isPresented: $isShowEmailUpdateAlert) {
                    if self.isError {
                        return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK")))
                    } else {
                        return Alert(title: Text(""), message: Text("アカウントの退会が完了しました"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            Spacer().frame(width: 50)
        }
    }
}
