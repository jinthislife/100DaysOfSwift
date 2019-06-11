//
//  ActionViewController.swift
//  Extension
//
//  Created by LeeKyungjin on 08/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    var scripts = [Script]()
    var history = [History]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedHistory = defaults.object(forKey: "History") as? Data {
            do {
                history = try JSONDecoder().decode([History].self, from: savedHistory)
            } catch {
                print("Failed to load history")
            }
        }
        
        if let savedScript = defaults.object(forKey: "Script") as? Data {
            do {
                scripts = try JSONDecoder().decode([Script].self, from: savedScript)
            } catch {
                print("Failed to load scripts")
            }
        }
        
        
        let examples = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showExamples))
        let historyButton = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(showHistory))
        navigationItem.leftBarButtonItems = [examples, historyButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(done))

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues =  itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print("JS VAlue: \(javaScriptValues)")
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["url"] as? String ?? ""
                    let h = History(title: self?.pageTitle, url: self?.pageURL)
                    self?.history.append(h)
                    self?.saveHistory()

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func saveHistory() {
        if let savedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(savedHistory, forKey: "History")
        } else {
            print("Failed to save history")
        }
    }
    
    func saveScript() {
        if let savedScript = try? JSONEncoder().encode(scripts) {
            UserDefaults.standard.set(savedScript, forKey: "Script")
        } else {
            print("Failed to save script")
        }
    }
    
    @objc func showHistory() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "history") as? HistoryViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.histories = history
        }
    }
    
    @objc func showExamples() {
        let ac = UIAlertController(title: "Prewritten Scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show URL", style: .default) { [weak self] _ in
            self?.excuteScript("alert(document.URL)")
        })
        ac.addAction(UIAlertAction(title: "Show Title", style: .default) {
            [weak self] _ in
            self?.excuteScript("alert(document.title)")
        })
        ac.addAction(UIAlertAction(title: "Show Cookie", style: .default) {
            [weak self] _ in
            self?.excuteScript("alert(document.cookie)")
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    func loadScriptList() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ScriptList") as? ScriptListTalbeViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.scriptList = scripts
        }
    }

    @IBAction func done() {
        let ac = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            guard let input = ac?.textFields?[0].text else { return }
            let script = Script(name: input, jscript: self?.script.text ?? "")
            self?.scripts.append(script)
            self?.saveScript()
            self?.loadScriptList()
        })
        present(ac, animated: true)

        
//        let item = NSExtensionItem()
//        let argument: NSDictionary = ["customJavaScript": script.text]
//        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
//        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
//        item.attachments = [customJavaScript]
//
//        extensionContext?.completeRequest(returningItems: [item])
    }

    func excuteScript(_ scriptText: String) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": scriptText]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }
}
