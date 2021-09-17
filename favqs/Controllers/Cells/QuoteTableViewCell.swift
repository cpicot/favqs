//
//  UserTableViewCell.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit
import Reusable

final class QuoteTableViewCell: UITableViewCell, NibReusable {
    // MARK: - Outlets
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    // MARK: - Internal Funcs
    func setup(author: String, body: String) {
        authorLabel.text = author
        bodyLabel.text = body
    }
}

// MARK: - Private Funcs
private extension QuoteTableViewCell {
}
