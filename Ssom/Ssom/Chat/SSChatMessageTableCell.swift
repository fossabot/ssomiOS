//
//  SSChatMessageTableCell.swift
//  Ssom
//
//  Created by DongSoo Lee on 2016. 7. 31..
//  Copyright © 2016년 SsomCompany. All rights reserved.
//

import UIKit

class SSChatMessageTableCell: UITableViewCell {
    @IBOutlet var imgViewPartnerProfile: UIImageView!
    @IBOutlet var imgViewPartnerProfileBorder: UIImageView!
    @IBOutlet var viewPartnerMessage: UIView!
    @IBOutlet var lbPartnerMessage: UILabel!
    @IBOutlet var lbPartnerMessageTime: UILabel!
    @IBOutlet var viewMyMessage: UIView!
    @IBOutlet var lbMyMessage: UILabel!
    @IBOutlet var lbMyMessageTime: UILabel!

    var ssomType: SSType = .SSOM
    var partnerImageUrl: String?
    var model: SSChatViewModel = SSChatViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewPartnerMessage.layer.cornerRadius = 2.3
        self.viewMyMessage.layer.cornerRadius = 2.3
    }

    func configView(model: SSChatViewModel) {
        self.model = model

        switch self.ssomType {
        case .SSOM:
            self.imgViewPartnerProfileBorder.image = UIImage(named: "profileBorderGreen")
            self.viewPartnerMessage.backgroundColor = UIColor(red: 0.0, green: 180.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        case .SSOSEYO:
            self.imgViewPartnerProfileBorder.image = UIImage(named: "profileBorderRed")
            self.viewPartnerMessage.backgroundColor = UIColor(red: 237.0/255.0, green: 52.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        }

        if let loginedUserId = SSAccountManager.sharedInstance.userModel?.userId {
            if model.fromUserId == loginedUserId {
                self.showMyViews()

                self.lbMyMessage.text = model.message
                self.lbMyMessageTime.text = Util.getDateString(model.messageDateTime)
            } else {
                self.showPartnerViews()

                if let imageUrl = self.partnerImageUrl {
                    self.imgViewPartnerProfile.sd_setImageWithURL(NSURL(string: imageUrl), completed: { (image, error, _, _) in
                        if error != nil {
                        } else {
                            let croppedProfileImage: UIImage = UIImage.cropInCircle(image, frame: CGRectMake(0, 0, self.imgViewPartnerProfile.bounds.size.width, self.imgViewPartnerProfile.bounds.size.height))

                            self.imgViewPartnerProfile.image = croppedProfileImage
                        }
                    })
                }
                self.lbPartnerMessage.text = model.message
                self.lbPartnerMessageTime.text = Util.getDateString(model.messageDateTime)
            }
        }
    }

    func showMyViews() {
        self.imgViewPartnerProfile.hidden = true
        self.imgViewPartnerProfileBorder.hidden = true
        self.viewPartnerMessage.hidden = true
        self.lbPartnerMessage.hidden = true
        self.lbPartnerMessageTime.hidden = true

        self.viewMyMessage.hidden = false
        self.lbMyMessage.hidden = false
        self.lbMyMessageTime.hidden = false
    }

    func showPartnerViews() {
        self.imgViewPartnerProfile.hidden = false
        self.imgViewPartnerProfileBorder.hidden = false
        self.viewPartnerMessage.hidden = false
        self.lbPartnerMessage.hidden = false
        self.lbPartnerMessageTime.hidden = false

        self.viewMyMessage.hidden = true
        self.lbMyMessage.hidden = true
        self.lbMyMessageTime.hidden = true
    }
}