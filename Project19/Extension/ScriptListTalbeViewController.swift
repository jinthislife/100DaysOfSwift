//
//  ScriptListTalbeViewController.swift
//  Extension
//
//  Created by LeeKyungjin on 09/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import MobileCoreServices

class ScriptListTalbeViewController: UITableViewController {

    var scriptList = [Script]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JavaScript Created"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Script")
        cell.textLabel?.text = scriptList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": scriptList[indexPath.row].jscript]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
    
            extensionContext?.completeRequest(returningItems: [item])
    }

}
