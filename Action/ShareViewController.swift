//
//  ShareViewController.swift
//  Action
//
//  Created by 益达达 on 24/5/19.
//  Copyright © 2019 UTS. All rights reserved.
//
import UIKit
import Social
import MobileCoreServices

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                  .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class ShareViewController: SLComposeServiceViewController {

    var content: String = ""

    override func viewDidLoad() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        let reminder = UILabel.init()
        reminder.text = "Edit Title"
        navigationItem.titleView = reminder
        navigationController?.navigationBar.topItem?.titleView = reminder
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Save"

        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary
                self.content = (results!["source"] as! String).html2String
            })
        } else {
            print("error")
        }
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let dict = ["title": textView.text ?? "", "content": self.content]
        print("user title: ", textView.text ?? "")
        let userDefault = UserDefaults(suiteName: "group.UTS.Paperweb")
        var i = 0
        var key = "paperweb" + String(i)
        while(true) {
            key = "paperweb" + String(i)
            if((userDefault?.object(forKey: key)) != nil) {
                i = i + 1
            } else {
                break
            }
        }
        userDefault!.set(dict, forKey: key)
        userDefault!.synchronize()
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
