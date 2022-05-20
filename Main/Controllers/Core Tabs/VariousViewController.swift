//
//  VariousViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/24.
//

// Well, it looks like I've got an idea of what it's like.
// It might be a good idea to include some text.
// I should also save where I fly to in the array.
// Built-in user withdrawal process
// A new input form will appear in a pop-up window.
// Transition to a three-dimensional structure, including alerts.

import UIKit
import SwiftUI
import SafariServices

class VariousViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var TableViewList: UITableView!
    let textArry: [String] = [
        "Fakebakka公式",
        "基本情報について",
        "利用規約",
        "プライバシーポリシー",
        "ユーザー情報の更新",
        "パスワード再設定",
        "ユーザーの退会",
    ]
    let sectionArry: [String] = [
        "基本情報",
    ]
    let ditailTextArry: [String] = [
        "Fakebakka公式アカウントへアクセスします",
        "Fakebakkaに関する基本情報を見ることができます",
        "利用規約を確認することができます",
        "プライバシーポリシーを確認することができます",
        "ユーザーの基本情報の更新を行うことができます",
        "パスワードの再設定とメールアドレスの変更を行うことができます",
        "これはログアウトではなく退会処理です",
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        TableViewList = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        TableViewList.delegate = self
        TableViewList.dataSource = self
        TableViewList.estimatedRowHeight = 100
        // Automatic height change
        // I'll put this in the main one.
        TableViewList.rowHeight = UITableView.automaticDimension
        TableViewList.backgroundColor = UIColor.white
        self.view.addSubview(TableViewList)
    }
    // Specify number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Specify section title.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArry[section]
    }
    // Specify the number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect cells.
        tableView.deselectRow(at: indexPath, animated: true)
        // Transition to another screen
        // performSegue(withIdentifier: controllerSelectArry[indexPath.row], sender: nil)
        switch indexPath.row{
            case 0:
                guard let url = URL(string: "https://twitter.com/pippi_kon") else { return }
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            case 1:
                guard let url = URL(string: "https://landlim.com/ja/") else { return }
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            case 2:
                guard let url = URL(string: "https://landlim.com/ja/") else { return }
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            case 3:
                guard let url = URL(string: "https://landlim.com/ja/") else { return }
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            case 4:
                let vc = UIHostingController(rootView: AuthUserInformationUpdateView())
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = UIHostingController(rootView: AuthEmailPasswordUpdateView())
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                let vc = UIHostingController(rootView: AuthDellUserView())
                self.navigationController?.pushViewController(vc, animated: true)
        default:
            fatalError()
        }
    }
    // formation
    // detailText
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                                   reuseIdentifier: "aaa\(indexPath.section)-\(indexPath.row)")
        cell.textLabel?.text = textArry[indexPath.row]
        // cell.detailTextLabel?.text = "行番号 : \(indexPath.row)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = ditailTextArry[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Charter-Roman", size: 15.5)
        cell.detailTextLabel!.font = UIFont(name: "Charter-Roman", size: 10.5)
        // Images can also be included.
        // cell.imageView?.image = UIImage(named: "dog2.png")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
