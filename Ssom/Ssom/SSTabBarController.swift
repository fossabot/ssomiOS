//
//  SSTabBarController.swift
//  Ssom
//
//  Created by DongSoo Lee on 2017. 1. 3..
//  Copyright © 2017년 SsomCompany. All rights reserved.
//

import UIKit

class SSTabBarController: UITabBarController {

    var barButtonItems: SSNavigationBarItems!

    var imgViewSsomIcon: UIImageView!
    var lbTitle: UILabel!

    var unreadCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isDrawable = true
        }

        self.setNavigationBarView()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SSInternalNotification.PurchasedHeart.rawValue), object: nil, queue: nil) { [weak self] (notification) in

            guard let wself = self else { return }

            if let userInfo = notification.userInfo {
                if let heartsCount = userInfo["heartsCount"] as? Int {
                    wself.barButtonItems.changeHeartCount(heartsCount)
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setNavigationBarView() {
        self.navigationItem.titleView = UIView(frame: CGRect(x: UIScreen.main.bounds.width / 2.0 - 50, y: 20, width: 100, height: 44))
        self.navigationItem.titleView?.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        self.navigationItem.titleView?.clipsToBounds = false

        self.imgViewSsomIcon = UIImageView(image: #imageLiteral(resourceName: "iconSsomMapMini"))
        self.navigationItem.titleView!.addSubview(self.imgViewSsomIcon)
        self.imgViewSsomIcon.translatesAutoresizingMaskIntoConstraints = false

        self.lbTitle = UILabel()
        self.lbTitle.text = "현재 5,021명 접속 중"
        self.lbTitle.textColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        self.navigationItem.titleView!.addSubview(self.lbTitle)
        self.lbTitle.translatesAutoresizingMaskIntoConstraints = false

        self.navigationItem.titleView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[icon]-5-[title]", options: .alignAllCenterY, metrics: nil, views: ["icon" : self.imgViewSsomIcon, "title": self.lbTitle]))
        self.navigationItem.titleView!.addConstraint(NSLayoutConstraint(item: self.navigationItem.titleView!, attribute: .centerY, relatedBy: .equal, toItem: self.lbTitle, attribute: .centerY, multiplier: 1, constant: 0))
        self.navigationItem.titleView!.addConstraint(NSLayoutConstraint(item: self.navigationItem.titleView!, attribute: .centerX, relatedBy: .equal, toItem: self.lbTitle, attribute: .centerX, multiplier: 1, constant: -(#imageLiteral(resourceName: "iconSsomMapMini").size.width / 2.0)))

        if #available(iOS 8.2, *) {
            self.lbTitle.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        } else {
            // Fallback on earlier versions
            if let font = UIFont.init(name: "HelveticaNeue-Medium", size: 13) {
                self.lbTitle.font = font
            }
        }

        let leftBarButtonItem: UIBarButtonItem = self.navigationItem.leftBarButtonItem!
        leftBarButtonItem.title = ""
        leftBarButtonItem.image = UIImage.resizeImage(UIImage(named: "manu")!, frame: CGRect(x: 0, y: 0, width: 21, height: 14))
        leftBarButtonItem.target = self
        leftBarButtonItem.action = #selector(tapMenu)

        let rightBarButtonItems: Array = self.navigationItem.rightBarButtonItems!
        if rightBarButtonItems.count == 1 {
            self.barButtonItems = SSNavigationBarItems(animated: true)

            self.barButtonItems.btnMessageBar.addTarget(self, action: #selector(tapChat), for: UIControlEvents.touchUpInside)
            let messageBarButton = UIBarButtonItem(customView: self.barButtonItems.messageBarButtonView!)

            self.navigationItem.rightBarButtonItems = [messageBarButton]
        }
    }

    func tapMenu() {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.drawerController?.setMainState(.open, inDirection: .Left, animated: true, allowUserInterruption: true, completion: nil)
        }
    }

    func tapChat() {
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveLinear, animations: {
            self.barButtonItems.imgViewMessage.transform = CGAffineTransform.identity
        }) { (finish) in
            if SSAccountManager.sharedInstance.isAuthorized {

                let chatStoryboard: UIStoryboard = UIStoryboard(name: "SSChatStoryboard", bundle: nil)
                let vc = chatStoryboard.instantiateViewController(withIdentifier: "chatListViewController") as! SSChatListViewController

                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                SSAccountManager.sharedInstance.openSignIn(self, completion: { (finish) in
                    if finish {
                        let chatStoryboard: UIStoryboard = UIStoryboard(name: "SSChatStoryboard", bundle: nil)
                        let vc = chatStoryboard.instantiateViewController(withIdentifier: "chatListViewController") as! SSChatListViewController

                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        }
    }
}
