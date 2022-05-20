//
//  FinalPage.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/05/18.
//

import Foundation
import UIKit
import SwiftUI
import SafariServices

class FinalPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var TableViewList: UITableView!
    let textArry: [String] = [
        "Fakebakka公式",
        "公式サイト",
        "ログインページへ戻る",
    ]
    let sectionArry: [String] = [
        "Thanks for using",
    ]
    let ditailTextArry: [String] = [
        "Fakebakka公式アカウントを閲覧します",
        "Fakebakka公式サイトへアクセスします",
        "ログインページへ戻ります"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.layer.borderWidth = 0.50
        self.tabBarController?.tabBar.layer.borderColor = UIColor.white.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
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
    // Make the background white.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 15.0, *) {
            let appearanceUINav = UINavigationBarAppearance()
            appearanceUINav.configureWithOpaqueBackground()
            appearanceUINav.backgroundColor = UIColor.white
            let appearanceUITab = UITabBarAppearance()
            appearanceUITab.configureWithOpaqueBackground()
            appearanceUITab.backgroundColor = UIColor.white
            UINavigationBar.appearance().standardAppearance = appearanceUINav
            UINavigationBar.appearance().scrollEdgeAppearance = appearanceUINav
            UITabBar.appearance().standardAppearance = appearanceUITab
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
            UITabBar.appearance().barTintColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor.white
            // Background transparency
            UITabBar.appearance().backgroundImage = UIImage()
            // Boundary transparency
            UITabBar.appearance().shadowImage = UIImage()
            // Change color
            UITabBar.appearance().barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
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
        return 3
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
                let vc = SignInViewController()
                vc.title = "ログイン"
                vc.navigationItem.largeTitleDisplayMode = .never
                vc.hidesBottomBarWhenPushed = true
                vc.tabBarController?.tabBar.backgroundImage = UIImage()
                navigationController?.pushViewController(vc, animated: true)
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
