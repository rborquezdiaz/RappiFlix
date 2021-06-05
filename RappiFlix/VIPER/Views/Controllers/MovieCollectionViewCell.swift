//
//  MovieCollectionViewCell.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 02/06/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: NetworkImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(with posterURL: String?) {
        let fullPath =  (NetworkManager.shared().urlRequest(for: .poster(posterURL ?? ""))?.url?.absoluteString ?? "") + ServerRequest.poster(posterURL ?? "").path
        if let url = URL(string: fullPath) {
            posterImageView.loadImageWithUrl(url)
        } else {
            posterImageView.image = #imageLiteral(resourceName: "rappi-placeholder")
        }
    }
}
