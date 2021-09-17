//
//  UserTableViewCell.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import Reusable
import AlamofireImage

final class UserTableViewCell: UITableViewCell, NibReusable {
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favCountLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.rounded()
        }
    }

    func setup(name: String?,
               favCount: Int?,
               avatar: String?) {
        nameLabel.text = name
        favCountLabel.text = "Total fav: \(favCount ?? 0)"
        if let urlString = avatar,
           let url = URL(string: urlString) {
            avatarImageView.af.setImage(withURL: url,
                                        completion: nil)
        } else {
            avatarImageView.image = nil
        }
    }
}
